import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import os

os.getcwd()
#Load BehaviorSpace data
experiment_data = pd.read_csv("10k-mask.csv", skiprows=6)
df = pd.DataFrame(experiment_data)

#Drop all irrelevant columns
cols = list(range(1,47))
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
df50 = df[df['Simulation Run'] == 2]
df100 = df[df['Simulation Run'] == 3]
###df50["Total Infected"].max()


plt.figure(figsize=(8,8))
sns.set(rc = {'lines.linewidth': 2})
ax1=sns.lineplot(x=df0['Days elapsed'],y=df0['Total Infected'],color="r",label="0% Mask usage")
sns.lineplot(x=df50['Days elapsed'], y=df50['Total Infected'],color="orange",label="50% Mask usage",ax=ax1)
sns.lineplot(df100['Days elapsed'], y=df100['Total Infected'],color="g",label="100% Mask usage",ax=ax1)
plt.title("Mask usage vs Infection", fontsize=18)
plt.xlabel("Days elapsed")
plt.ylabel("% Infected")

plt.show()

