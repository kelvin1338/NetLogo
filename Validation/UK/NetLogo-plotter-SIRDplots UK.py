import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("Dissertation validation 10k UK experiment-table.csv", skiprows=6)
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
inf_curve.legend(prop={'size': 10}, loc=(0.8,0.8))
inf_curve.tick_params(axis = 'both', which = 'major', labelsize = 18)
inf_curve.set_ylabel('% Infected')
#inf_curve.set_yticklabels(labels = [-10, '0   ', '10   ', '20   ', '30   ', '40   ', '50   ', '60%'])
xlabels = ['{:,.0f}'.format(x) for x in inf_curve.get_xticks()/24]
inf_curve.set_xticklabels(labels = xlabels)
inf_curve.axhline(y = 0, color = 'black', linewidth = 1.3, alpha = .7)
inf_curve.set_xlabel('Days Elapsed')
inf_curve.text(x = -5.2*24, y = -10.25,
    s = 'Simulation of the United Kingdom                                                                                            Validation of COVID-19 Simulation Model   ',
    fontsize = 14, color = '#f0f0f0', backgroundcolor = 'grey')
inf_curve.text(x = -5*24, y = 60, s = "UK model validation",
               fontsize = 26, weight = 'bold', alpha = .75)
inf_curve.text(x = -5*24, y = 55,
               s = 'Infection curves showing the proportion of people in various states of COVID-19',
              fontsize = 19, alpha = .85)

inf_curve.axvline(x = 15*24, color = 'red', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 38*24, color = 'red', linewidth = 1.3, alpha = .7, linestyle='--')

inf_curve.axvline(x = 0.1*24, color = 'purple', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 10*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 15*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 28*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')
inf_curve.axvline(x = 52*24, color = 'black', linewidth = 1.3, alpha = .7, linestyle='--')

inf_curve.arrow(0,43,10*24,0, color='purple', shape='full',head_width=1, head_length=0.8*24,length_includes_head=True)
inf_curve.arrow(15*24,25,23*24,0, color='red', shape='full',head_width=1, head_length=0.8*24,length_includes_head=True)
inf_curve.arrow(38*24,20,30*24,0, color='blue', shape='full',head_width=1, head_length=0.8*24,length_includes_head=True)


# Add colored labels
inf_curve.text(x = 0.5*24, y = 40, s = 'Herd immunity \nstrategy', color = 'purple', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 15.5*24, y = 22, s = 'Tightened border \ncontrol', color = 'red', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 15.5*24, y = 18, s = 'Full lockdown \nimplemented', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 38.5*24, y = 17, s = 'Relaxed border \ncontrol', color = 'blue', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 28.5*24, y = 40, s = 'Partially relaxed \nlockdown rules', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)
inf_curve.text(x = 52.5*24, y = 30, s = 'Partially reopening \npubilc facilities', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9) 

inf_curve.text(x = 10.5*24, y = 49.5, s = 'Partial closure of \npubilc facilities', color = 'black', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9) 
inf_curve.text(x = 10.5*24, y = 46.5, s = 'Social \ndistancing', color = 'brown', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9) 
inf_curve.text(x = 52.5*24, y = 27, s = 'Relaxed social \ndistancing', color = 'brown', weight = 'bold',
              backgroundcolor = '#f0f0f0', size=9)               

#-----------------------------------------------------------------------------




