#-------------------------------------------------------------------------------------
#Convert NetLogo to Python and create plots showing total infections
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("duration 10k experiment-table.csv", skiprows=6)
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
df.rename(columns={df.columns[7]: 'Dead'}, inplace=True)

df.rename(columns={df.columns[8]: 'Susceptible'}, inplace=True)
df.rename(columns={df.columns[9]: 'Infected'}, inplace=True)
df.rename(columns={df.columns[10]: 'Recovered'}, inplace=True)
df.rename(columns={df.columns[11]: 'Dead'}, inplace=True)

df['Days elapsed'] = df['Hours elapsed'] / 24

#Sort columns by simulation run, and keeping chronological order for each simulation
df = df.iloc[np.lexsort((df.index, df['Simulation Run'].values))]

#Split data by simulation run
df0 = df[df['Simulation Run'] == 1]
df1 = df[df['Simulation Run'] == 2]
df2 = df[df['Simulation Run'] == 3]
df3 = df[df['Simulation Run'] == 4]
df4 = df[df['Simulation Run'] == 5]
###df50["Total Infected"].max()


plt.figure(figsize=(8,8))
sns.set(rc = {'lines.linewidth': 2})
ax1=sns.lineplot(x=df0['Days elapsed'],y=df0['Total Infected'],color="r",label="Instant")
sns.lineplot(x=df1['Days elapsed'], y=df1['Total Infected'],color="orange",label="3 days",ax=ax1)
sns.lineplot(x=df2['Days elapsed'], y=df2['Total Infected'],color="yellow",label="6 days",ax=ax1)
sns.lineplot(x=df3['Days elapsed'], y=df3['Total Infected'],color="green",label="9 days",ax=ax1)
sns.lineplot(df4['Days elapsed'], y=df4['Total Infected'],color="cyan",label="12 days",ax=ax1)
plt.title("Asymptomatic duration of virus vs Infection", fontsize=18)
plt.xlabel("Days elapsed")
plt.ylabel("% Infected")

plt.show()
#-------------------------------------------------------------------------------------






#-------------------------------------------------------------------------------------
#matplotlib fivethirtyeight SIRD plots

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("SIRD adapted 10k experiment-table.csv", skiprows=6)
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


df.rename(columns={df.columns[12]: 'Cumulative Infected'}, inplace=True)
df.rename(columns={df.columns[13]: 'Cumulative Dead'}, inplace=True)
df.rename(columns={df.columns[14]: 'Cumulative Recovered'}, inplace=True)


df['Days elapsed'] = df['Hours elapsed'] / 24


#-----------------------------------------------------------------------------
#Plotting Infection Model
infection_data = df[['Total Infected', 'Asymptomatic', 'Symptomatic', 'Light symptoms', 'Severe symptoms', 'Deceased']]
colors = ['green', '#808000', 'blue', 'orange','red','purple']

import matplotlib.style as style
style.use('fivethirtyeight')
inf_curve = infection_data.plot(figsize = (13,8), legend = False, color=colors)
inf_curve.tick_params(axis = 'both', which = 'major', labelsize = 18)
inf_curve.set_ylabel('% Infected')
inf_curve.set_yticklabels(labels = [-10, '0   ', '10   ', '20   ', '30   ', '40   ', '50   ', '60%'])
xlabels = ['{:,.0f}'.format(x) for x in inf_curve.get_xticks()/24]
inf_curve.set_xticklabels(labels = xlabels)
inf_curve.axhline(y = 0, color = 'black', linewidth = 1.3, alpha = .7)
inf_curve.set_xlabel('Days Elapsed')
inf_curve.text(x = -360, y = -15,
    s = 'Adapted SIRD Model                                                                                                                Source: COVID-19 Simulation Model   ',
    fontsize = 14, color = '#f0f0f0', backgroundcolor = 'grey')
inf_curve.text(x = -350, y = 71, s = "What if no one did anything about COVID-19?",
               fontsize = 26, weight = 'bold', alpha = .75)
inf_curve.text(x = -350, y = 65,
               s = 'Infection curves showing the proportion of people in various states of COVID-19',
              fontsize = 19, alpha = .85)
# Add colored labels
inf_curve.text(x = 700, y = 45, s = 'Total Infected', color = colors[0], weight = 'bold', rotation = -60,
              backgroundcolor = '#f0f0f0')
inf_curve.text(x = 700, y = 6, s = 'Asymptomatic', color = colors[1], weight = 'bold', rotation = -30,
              backgroundcolor = '#f0f0f0')
inf_curve.text(x = 397, y = 48, s = 'Symptomatic', color = colors[2], weight = 'bold', rotation = 0,
               backgroundcolor = '#f0f0f0')
inf_curve.text(x = 600, y = 22, s = 'Light symptoms', color = colors[3], weight = 'bold', rotation = -50,
              backgroundcolor = '#f0f0f0')
inf_curve.text(x = 230, y = 5, s = 'Severe symptoms', color = colors[4], weight = 'bold', rotation = 5,
              backgroundcolor = '#f0f0f0')
inf_curve.text(x = 1230, y = 3.75, s = 'Dead', color = colors[5], weight = 'bold', rotation = 2,
              backgroundcolor = '#f0f0f0')
#-----------------------------------------------------------------------------
SIRD_data = df[['Susceptible', 'Infected', 'Recovered', 'Dead']]
colors_sird = ['green', '#808000', '#009999', 'red']


import matplotlib.style as style
style.use('fivethirtyeight')
sird_curve = SIRD_data.plot(figsize = (13,8), legend = False, color=colors_sird)
sird_curve.tick_params(axis = 'both', which = 'major', labelsize = 18)
sird_curve.set_ylabel('% of Population')
sird_curve.yaxis.set_ticks(np.arange(0, 110, 10))
sird_curve.set_yticklabels(labels = ['0   ', '10   ', '20   ', '30   ', '40   ', '50   ', '60   ', '70   ', '80   ', '90   ', '100%'])

xlabels = ['{:,.0f}'.format(x) for x in sird_curve.get_xticks()/24]

sird_curve.set_xticklabels(labels = xlabels)

sird_curve.axhline(y = 0, color = 'black', linewidth = 1.3, alpha = .7)
sird_curve.set_xlabel('Days Elapsed')
sird_curve.text(x = -390, y = -20,
    s = 'Adapted SIRD Model                                                                                                                Source: COVID-19 Simulation Model   ',
    fontsize = 14, color = '#f0f0f0', backgroundcolor = 'grey')


sird_curve.text(x = -380, y = 115, s = "What if no one did anything about COVID-19?",
               fontsize = 26, weight = 'bold', alpha = .75)
sird_curve.text(x = -380, y = 109,
               s = 'Proportion of susceptible, infected, recovered and dead people through time',
              fontsize = 19, alpha = .85)


# Add colored labels
sird_curve.text(x = 160, y = 65, s = 'Susceptible', color = colors_sird[0], weight = 'bold', rotation = -65,
              backgroundcolor = '#f0f0f0')
sird_curve.text(x = 80, y = 22, s = 'Infected', color = colors_sird[1], weight = 'bold', rotation = 60,
              backgroundcolor = '#f0f0f0')
sird_curve.text(x = 900, y = 62, s = 'Recovered', color = colors_sird[2], weight = 'bold', rotation = 53,
               backgroundcolor = '#f0f0f0')
sird_curve.text(x = 800, y = 3, s = 'Dead', color = colors_sird[3], weight = 'bold', rotation = 3,
              backgroundcolor = '#f0f0f0')
#-------------------------------------------------------------------------------------
#Sensitivity Analysis
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#Load BehaviorSpace data
experiment_data = pd.read_csv("Sensitivity Analysis/radius 10k experiment-table.csv", skiprows=6)

df = pd.DataFrame(experiment_data)


df = df.iloc[np.lexsort((df.index, df['[run number]'].values))]

df['max pop_infected_daily']
df.rename(columns={'maximum_infectious_distance': 'Maximum infection radius'}, inplace=True)
df.rename(columns={'days_before_symptom_showing': 'Asymptomatic period'}, inplace=True)
df.rename(columns={'Essential_workers': '% not following lockdown guidelines'}, inplace=True)
df.rename(columns={'lockdown_delay': 'Lockdown delay'}, inplace=True)
df.rename(columns={'use_mask_pop': 'Mask usage rate'}, inplace=True)
df.rename(columns={'social_distancing_metres': 'Social distancing metres'}, inplace=True)
df.rename(columns={'max pop_infected_daily': 'Peak infection %'}, inplace=True)

#df['Symptomatic isolation rate'] = df['Symptomatic isolation rate'].astype('category')
df['Maximum infection radius'] = df['Maximum infection radius'].astype('category')
a = df[['Maximum infection radius', 'Peak infection %']]

ax1 = sns.set_style("whitegrid")
ax1 = sns.catplot(x='Maximum infection radius', y='Peak infection %', data=a, alpha=0.6)
ax1 = sns.boxplot(x='Maximum infection radius', y='Peak infection %', data=a, boxprops=dict(alpha=0.2), linewidth=0.75)
ax1 = sns.pointplot(x='Maximum infection radius', y='Peak infection %',data=a.groupby('Maximum infection radius', as_index=False).mean(), markers="x", color="red", scale=0.3)
ax1 = ax1.set(title="Sensitivity analysis of maximum infection radius", xlabel='Maximum infection radius', ylabel='Peak infection %')
plt.title("Maximum infection radius vs Peak infection", fontsize=18)
plt.xlabel("Maximum infection radius")
plt.ylabel("Peak infection %")
plt.show()

b = a[a['Maximum infection radius'] == 5]
b['Peak infection %'].median()
b['Peak infection %'].mean()
b['Peak infection %'].max() - b['Peak infection %'].min()
b['Peak infection %'].var()
b['Peak infection %'].std()
b['Peak infection %'].std()/12
#-------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------
#Morris Elementary Effects Method Analysis

import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from SALib.sample import morris
from SALib.analyze import morris as morris_a
#Load BehaviorSpace data
experiment_data = pd.read_csv("Sensitivity Analysis/elementary effects.csv", skiprows=6)

df = pd.DataFrame(experiment_data)


df = df.iloc[np.lexsort((df.index, df['[run number]'].values))]

df.rename(columns={'lockdown_delay': 'Lockdown delay'}, inplace=True)
df.rename(columns={'use_mask_pop': 'Mask usage rate'}, inplace=True)
df.rename(columns={'social_distancing_metres': 'Social distancing metres'}, inplace=True)
df.rename(columns={'symptomatic_isolation_rate': 'Symptomatic Isolation Rate'}, inplace=True)
df.rename(columns={'max pop_infected_daily': 'Peak infection %'}, inplace=True)


EEM_var = df[['Mask usage rate', 'Symptomatic Isolation Rate', 'Social distancing metres', 'Lockdown delay', 'Peak infection %']]
EEM_parameters = ['Mask usage rate', 'Symptomatic Isolation Rate', 'Social distancing metres', 'Lockdown delay']


scaler = MinMaxScaler()
x = EEM_var[EEM_parameters].values
x_scaled = scaler.fit_transform(x)
df_temp = pd.DataFrame(x_scaled, columns=EEM_parameters, index = EEM_var.index)
EEM_var[EEM_parameters] = df_temp


#EEM
problem = {
    'num_vars': 4,
    'names': ['Mask usage rate', 'Symptomatic Isolation Rate', 'Social distancing metres', 'Lockdown delay'],
    'bounds': [[0,1],
               [0,1],
               [0,1],
               [0,1]]
               
    }


#seed 1
sample_EEM = morris.sample(problem, 30, num_levels=6, grid_jump=1, seed=1)


EEM_results = np.array([38.04, 33.37, 29.6, 32.31, 29.66, #0-4
                    7.97, 8.85, 6.61, 8.53, 7.84, #5-9
                    34.21, 29, 30.02, 33.41, 21.46, #10-14
                    13.74, 15.89, 20.35, 18,16.98, #15-19
                    14.04, 15.11, 19.26, 16.84, 17.66, #20-24
                    21.38, 23.01, 26.34, 23.58, 32.82, #25-29
                    16.13, 14.94, 15.28, 24.37, 28.76, #30-34
                    13.92, 20.89, 32.71, 29.21, 26.51, #35-39
                    7.04, 9.93, 6.68, 5.32, 7.28, #40-44
                    13.4, 18.75, 16.68, 16.41, 16.67, #45-49
                    7.06, 4.18, 6.61, 4.65, 5.76, #50-54
                    13.99, 10.05, 12.17, 16.09, 16.33, #55-59
                    6.11, 5.6, 4.04, 4.21, 4.13, #60-64
                    9.68, 8.86, 15.71, 17.32, 17.66, #65-69
                    15.68, 14.94, 13.18, 15.44, 29.21, #70-74
                    18.75, 24.04, 26.09, 28.54, 31.12, #75-79
                    14.22, 16.31, 13.01, 13.89, 16.63, #80-84
                    52.09, 51.03, 51.37, 29.79, 26.34, #85-89
                    19.33, 15.04, 16.63, 13.89, 13.4, #90-94
                    31.82, 25.65, 23.05, 21.03, 14, #95-99
                    8.65, 10.14, 7.52, 12.03, 15.47, #100-104
                    7.28, 10.88, 8.68, 9.93, 11.03, #105-109
                    13.66, 15.36, 15.49, 14.19, 10.15, #110-114
                    5.69, 5.38, 4.57, 6.75, 8.5, #115-119
                    6.91, 7.52, 6.33, 4.52, 4.67, #120-124
                    24.71, 15.63, 19.24, 18.57, 18.84, #125-129
                    5.59, 5.98, 6.01, 8.31, 10.33, #130-134
                    28.77, 21.4, 20.44, 37.89, 36.34, #135-139
                    20.35, 15.89, 13.92, 13.13, 18.12, #140-144
                    16.22, 7.85, 6.7, 9.49, 6.94
                    ])




morris_a.analyze(problem, sample_EEM, EEM_results, num_resamples=1000, seed=1)
#-------------------------------------------------------------------------------------


              
              
