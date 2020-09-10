# NetLogo
COVID-19 Agent-based Simulation

To run the model above, please download Dissertation.nlogo and the software NetLogo 6.1.1 using the following link (Approximately 200MB):
https://ccl.northwestern.edu/netlogo/6.1.1/

Adjust parameters if necessary, then simply click "Setup Environment" followed by "Begin Simulation" to run the simulation. <br/>
Adjust the random seed number to get slight variations using the same parameters. <br/>
Note that by default, the simulation space is 30 x 30 and the population is approximately 1000. However, almost all of the verification and validation experiments in the dissertation report are performed on a population size of 10000 and a simulation space of 100 x 100. However, a simulation space of 30 x 30 and population size of 1000 is sufficient to generate quick and interpretable results. Although a population size of 10000 and larger simulation space is less prone to anomalies, it takes a much longer time to finish running the simulation. <br/> 
The simulation space can be adjusted by right clicking the simulation animation space and setting 'max-pxcor' and 'max-pycor' both to 100, and the population size can be adjusted by right clicking the population slider bars and clicking 'Edit' to manually specify numbers. <br/>

netlogo_to_python_analysis.py is a preprocessing code that converts the NetLogo simulation results (from BehaviorSpace) into a pandas dataframe. It then contains various functions for graph-plotting, as well functions for generating and analysing Elementary Effects Method (EEM) trajectories.

**Saving simulation results to CSV files** <br/>
-To generate and save results from NetLogo, click tools -> BehaviourSpace -> New <br/>
-This will open a pop-up window which asks you to specify what values to set for each parameter, and which parameters to vary, as well as what parameters to record and write to the CSV file. <br/>
-Click OK -> Run -> Tick 'Table Output' <br/>
-A prompt will appear and ask where to save the file. Enter/select file directory <br/>
-Wait for simulation to finish running, and the results will be automatically saved to a CSV file <br/>

**Performing sensitivity analysis** <br/>
-Vary the parameter(s) of interest using BehaviorSpace, i.e. ["social_distancing_metres" 0 0.5 1 1.5 2] <br/>
-Read the results in Python using the file 'netlogo_to_python_analysis.py' and analyse the results using required sections of the code <br/>
-**Note:** Lines 256-342 of 'netlogo_to_python_analysis.py' is the python code for the Morris Elementary Effects Analysis for NetLogo. To run this section, the user must download the file __init__.py in the repository add it to their 'morris' folder which can be found in 'environment path + \Lib\site-packages\SALib\sample\'. More specifically, replace the existing '__init__.py' already in the corresponding file with the above new file. The reason for this is because the modified file has a parameter called 'grid_jump' which allows the user to specify 'delta' and also set random seed numbers to obtain reproducible results. <br/>


**Generating simulation results resembling the UK, Hong Kong and Italy** <br/>
-Open the 'Validation folder' in the GitHub repository <br/>
-Download parameters_to_observe.txt <br/>
-Open the country of interest <br/>
-Download 'Dissertation validation 10k *(country)*.nlogo **Note:** This simulation model is exactly the same as Dissertation.nlogo, except that certain events will automatically trigger at certain ticks to imitate the actions taken by the country. <br/>
-Download *(country)* validation parameters.txt <br/>
-Download 'NetLogo-plotter-SIRDplots *(country)*.py <br/>
-Open 'Dissertation validation 10k *(country)*.nlogo and open BehaviorSpace <br/>
-Copy and paste the contents from *(country)* validation parameters.txt into the 'Vary variables as follows' box <br/>
-Copy and paste the contents from 'parameters_to_observe.txt' into the 'Measure runs using these reporters' box <br/>
-Click OK -> Run -> Tick 'Table Output' <br/>
-A prompt will appear and ask where to save the file. Enter/select file directory <br/>
-Wait for simulation to finish running, and the results will be automatically saved to a CSV file (I have attached this CSV file as 'Dissertation validation 10k *(countries)* experiment-table.csv' in the GitHub repository, if the user wishes to skip all of the above steps. <br/>
-Open and run 'NetLogo-plotter-SIRDplots *(country)*.py <br/>
-Set the file directory to where the CSV results file was saved <br/>
-Run the code and save the generated figure
