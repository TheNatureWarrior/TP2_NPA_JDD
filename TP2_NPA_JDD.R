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
