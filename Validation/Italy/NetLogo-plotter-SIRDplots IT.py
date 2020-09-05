import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("Dissertation validation 10k IT experiment-table.csv", skiprows=6)
df = pd.DataFrame(experiment_data)

#Drop all irrelevant columns
cols = list(range(1,48))
df.drop(df.columns[cols],axis=1,inplace=True)

#Rename remaining columns
df.rename(columns={df.columns[0]: 'Simulation Run'}, inplace=True)
df.rename(columns={df.columns[1]: 'Hours elapsed'}, inplace=True)
df.rename(columns={df.columns[2]: 'Total Infected'}, inplace=True)
df.rename(columns={df.columns[3]: 'Asymptomatic'}, inplace=True)
df.rename(columns={df.columns[4]: 'Symptomatic'}, inplace=True)
df.rename(columns={df.columns[5]: 'Light symptoms'}, inplace=True)
df.rename(columns={df.columns[6]: 'Severe symptoms'}, inplace=True)
df.rename(columns={df.columns[7]: 'Deceased'}, inplace=True)

df.rename(columns={df.columns[8]: 'Susceptible'}, inplace=True)
df.rename(columns={df.columns[9]: 'Infected'}, inplace=True)
df.rename(columns={df.columns[10]: 'Recovered'}, inplace=True)
df.rename(columns={df.columns[11]: 'Dead'}, inplace=True)


#df.rename(columns={df.columns[12]: 'Cumulative Infected'}, inplace=True)
#df.rename(columns={df.columns[13]: 'Cumulative Dead'}, inplace=True)
#df.rename(columns={df.columns[14]: 'Cumulative Recovered'}, inplace=True)


df['Days elapsed'] = df['Hours elapsed'] / 24


#-----------------------------------------------------------------------------
#Plotting Infection Model
infection_data = df[['Total Infected', 'Asymptomatic', 'Symptomatic', 'Light symptoms', 'Severe symptoms', 'Deceased']]
colors = ['green', '#808000', 'blue', 'orange','red','purple']

import matplotlib.style as style
style.use('fivethirtyeight')
inf_curve = infection_data.plot(figsize = (13,8), color=colors, linewidth=1.5)
inf_curve.legend(prop={'size': 10}, loc=(0.85,0.8))
inf_curve.tick_params(axis = 'both', which = 'major', labelsize = 18)
inf_curve.set_ylabel('% Infected')
#inf_curve.set_yticklabels(labels = [-10, '0   ', '10   ', '20   ', '30   ', '40   ', '50   ', '60%'])
xlabels = ['{:,.0f}'.format(x) for x in inf_curve.get_xticks()/24]
inf_curve.set_xticklabels(labels = xlabels)
inf_curve.axhline(y = 0, color = 'black', linewidth = 1.3, alpha = .7)
inf_curve.set_xlabel('Days Elapsed')
inf_curve.text(x = -5.2*24, y = -4,
    s = 'Simulation of Italy                                                                                                       Validation of COVID-19 Simulation Model   ',
    fontsize = 14, color = '#f0f0f0', backgroundcolor = 'grey')
inf_curve.text(x = -5*24, y = 22, s = "Italy model validation",
               fontsize = 26, weight = 'bold', alpha = .75)
inf_curve.text(x = -5*24, y = 20,
               s = 'Infection curves showing the proportion of people in various states of COVID-19',
              fontsize = 19, alpha = .85)

inf_curve.axvline(x = 0.2*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 7*24, color = 'purple', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 10*24, color = 'red', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 12*24, color = 'blue', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 15*24, color = 'brown', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 42*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 52*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')

inf_curve.text(x = 0.5*24, y = 9, s = 'Tightened border \ncontrols', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 7.2*24, y = 14, s = 'Confinement \nof cities', color = 'purple', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 7.2*24, y = 15.5, s = 'Closure of \nschools', color = 'purple', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 10.2*24, y = 17, s = 'Social distancing \nenforced', color = 'red', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 12.2*24, y = 18.5, s = 'Mobility restrictions', color = 'blue', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 15.2*24, y = 9, s = 'Further tightened \nborder control', color = 'brown', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 15.2*24, y = 7, s = 'Full lockdown \nenforced', color = 'darkcyan', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 42.2*24, y = 7, s = 'Public facilities \npartially reopened', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 
inf_curve.text(x = 52.2*24, y = 9, s = 'Borders partially \nreopened', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9, bbox=dict(facecolor='none', edgecolor='none')) 



inf_curve.arrow(0,8.5,15*24,0, color='black', shape='full',head_width=0.4, head_length=0.8*24,length_includes_head=True)
inf_curve.arrow(15*24,8.25,37*24,0, color='brown', shape='full',head_width=0.4, head_length=0.8*24,length_includes_head=True)
inf_curve.arrow(52*24,8,12.5*24,0, color='black', shape='full',head_width=0.4, head_length=0.8*24,length_includes_head=True)
inf_curve.arrow(15*24,6.5,27*24,0, color='darkcyan', shape='full',head_width=0.4, head_length=0.8*24,length_includes_head=True)

#-----------------------------------------------------------------------------




