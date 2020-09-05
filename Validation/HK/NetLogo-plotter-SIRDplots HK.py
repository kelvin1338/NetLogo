import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("Dissertation validation 10k HK experiment-table.csv", skiprows=6)
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
inf_curve.legend(prop={'size': 10}, loc=(0.25,0.8))
inf_curve.tick_params(axis = 'both', which = 'major', labelsize = 18)
inf_curve.set_ylabel('% Infected')
#inf_curve.set_yticklabels(labels = [-10, '0   ', '10   ', '20   ', '30   ', '40   ', '50   ', '60%'])
xlabels = ['{:,.0f}'.format(x) for x in inf_curve.get_xticks()/24]
inf_curve.set_xticklabels(labels = xlabels)
inf_curve.axhline(y = 0, color = 'black', linewidth = 1.3, alpha = .7)
inf_curve.set_xlabel('Days Elapsed')
inf_curve.text(x = -360, y = -1.25,
    s = 'Simulation of Hong Kong                                                                                            Validation of COVID-19 Simulation Model   ',
    fontsize = 14, color = '#f0f0f0', backgroundcolor = 'grey')
inf_curve.text(x = -350, y = 7, s = "Hong Kong model validation",
               fontsize = 26, weight = 'bold', alpha = .75)
inf_curve.text(x = -350, y = 6.5,
               s = 'Infection curves showing the proportion of people in various states of COVID-19',
              fontsize = 19, alpha = .85)

inf_curve.axvline(x = 14*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 126*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 154*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')

inf_curve.axvline(x = 7*24, color = 'red', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 120*24, color = 'blue', linewidth = 1.3, alpha = .7, linestyle='--')


inf_curve.arrow(8*24,2.6,112*24,0, color='red', shape='full',head_width=0.1, head_length=2*24,length_includes_head=True)
inf_curve.arrow(121*24,4.5,33*24,0, color='blue', shape='full',head_width=0.1, head_length=2*24,length_includes_head=True)
inf_curve.arrow(155*24,4.8,40*24,0, color='red', shape='full',head_width=0.1, head_length=2*24,length_includes_head=True)


# Add colored labels
inf_curve.text(x = 15.5*24, y = 5.5, s = 'Semi-lockdown \nenforced', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 127.5*24, y = 4.75, s = 'No social \ndistancing', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 127.5*24, y = 5.5, s = 'Semi- \nlockdown \nstopped', color = 'black', weight = 'bold',
               backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 167*24, y = 5.5, s = 'Semi-lockdown + 1.5m social \ndistancing reinforced', color = 'black', weight = 'bold',
               backgroundcolor = '#f0f0f0', size=9)
               

inf_curve.text(x = 99*24, y = 4.4, s = 'Relaxed border \ncontrol', color = 'blue', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)               
inf_curve.text(x = 167*24, y = 5.1, s = 'Tightened border \ncontrol', color = 'red', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 8*24, y = 3, s = 'Tightened border \ncontrol', color = 'red', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)                   
               
               
#-----------------------------------------------------------------------------




