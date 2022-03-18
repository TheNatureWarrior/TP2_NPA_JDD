library(tidyverse)
library(lubridate)
#Above is loading in libraries

#On top bar, go to Session:
#Set Working Directory:
#To Source File Location
df<-read.csv('Canada_Hosp1_COVID_Data_At_Admission.csv',sep=",")
#Going to drop all columns we dropped eventually in
#original project
df=subset(df,select = -c(id,ethnicity,ethnicity_other,received_covid_vaccine,
                         covid_vaccine,pao2,pao2_fio2,ph,
                         high_senstivity_cardiac_troponin,esr,ferritin,
                         hs_crp,aptt_aptr,medications,comorbidities_other))
#dropped columns.

#Now to rename.
newNames<-c('reason', 'age', 'sex', 'height', 'weight',
                      'comorb',
                      'smoke_hist', 'year_quit', 'er_2_weeks',
                      'adm_disp', 'systolic_bp',
                      'diastolic_bp', 'heart_rate', 'respiratory_rate',
                      'oxygen_sat', 'temp', 'motor', 'verbal', 'eye',
                      'intubated', 'wbc', 'rbc', 'hemoglobin', 'hematocrit', 'mcv', 'mch',
                      'mchc', 'rdw', 'platelet_count', 'pt', 'alt', 'ast', 'serum_creatinine',
                      'sodium', 'potassium', 'total_serum_bilirubin', 'lactate', 'inr',
                      'd_dimer', 'crp')
colnames(df)<-newNames

#Note that many values are "", which aren't counted as NA.
df %>% group_by(smoke_hist) %>%
  count()

#Fixing using mutate and na_if.
#Goes through all columns in df, checks if its a character
#column, and if it is, maps it through na_if, which replaces
#each "" value with NA.
df<-df %>%
  mutate(across(where(is.character),~na_if(.,"")))

#To also clean out nulls in comorb
df<-df %>%
  mutate(across(where(is.character),~na_if(.,"[]")))

df %>% group_by(comorb) %>%
  count()

#Now to fix up comorb and reason some
#Testing some functions I may use to make clean function
grepl("helpmeout","why dont you help me out", fixed=TRUE)
grepl("hel","why odnt you help me out", fixed=TRUE)
grepl("apple", "happlessness",fixed=TRUE)

streamreason<- function(x){
  ifelse(grepl("[J80]",x,fixed=TRUE),"ARDS",
         ifelse(grepl("[J18.9]",x,fixed=TRUE),"Pneumonia",
                ifelse(grepl("[U07.1]",x,fixed=TRUE),"COVID-19",
                ifelse(grepl("[U07.2]",x,fixed=TRUE),"Probable COVID-19",
                ifelse(grepl("[B34.2]",x,fixed=TRUE),"Coronavirus infection",
                ifelse(grepl("[R05]",x,fixed=TRUE),"Cough",
                ifelse(grepl("[J98.9, R50.9]",x,fixed=TRUE),"Febrile respiratory illness",
                ifelse(grepl("[R50.9]",x,fixed=TRUE),"Fever",
                ifelse(grepl("[R09.0]",x,fixed=TRUE),"Hypoxemia",                                                   
                ifelse(grepl("[M79.19]",x,fixed=TRUE),"Myalgia",
                ifelse(grepl("[U07.1, J12.8]",x,fixed=TRUE),"Pneumonia due to COVID-19",
                ifelse(grepl("[R06.0]",x,fixed=TRUE),"Shortness of breath",
                ifelse(grepl("[R06.0, U07.2]",x,fixed=TRUE),"Shortness of breath with exposure to COVID-19",
                ifelse(grepl("[R06.8]",x,fixed=TRUE),"Tachypnea",
                ifelse(grepl("[J12.9]",x,fixed=TRUE),"Viral pneumonia",
                ifelse(grepl("[J96.99]",x,fixed=TRUE),"Respiratory failure",
                       ifelse(grepl("[J98.8]",x,fixed=TRUE),"Respiratory tract infection", x)
                                                                                             
                                     ))))))))))))))))
}

#Applying function across dataframe, will only effect reason
#but might as well apply across all

df<-df %>%
  mutate(across(where(is.character),~(streamreason(.))))


df %>% group_by(reason) %>%
  count()

#Alright, now reason is fixed.
#Now going to quickly fix motor, verbal, and eye before I fix comorb.

df$motor<-as.character(df$motor)
df$eye<-as.character(df$eye)
df$verbal<-as.character(df$verbal)

#Fixed those, now onto comorb.
fixcomorb<-function(x){
  ifelse(grepl("Asthma",x,fixed=TRUE),
         ifelse("ypertension",x,fixed=TRUE),
         )
  
  
}