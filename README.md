# NetLogo
COVID-19 Agent-based Simulation

To run the model above, please download Dissertation.nlogo and the software NetLogo 6.1.1 using the following link (Approximately 200MB):
https://ccl.northwestern.edu/netlogo/6.1.1/

Adjust parameters if necessary, then simply click "Setup Environment" followed by "Begin Simulation" to run the simulation.
Adjust the random seed number to get slight variations using the same parameters.

netlogo_to_python_analysis.py is a preprocessing code that converts the NetLogo simulation results (from BehaviorSpace) into a pandas dataframe. It then contains various functions for graph-plotting, as well functions for generating and analysing Elementary Effects Method (EEM) trajectories.

**Saving simulation results to CSV files**
-To generate and save results from NetLogo, click tools -> BehaviourSpace -> New
-This will open a pop-up window which asks you to specify what values to set for each parameter, and which parameters to vary, as well as what parameters to record and write to the CSV file.
-Click OK -> Run -> Tick 'Table Output'
-A prompt will appear and ask where to save the file. Enter/select file directory
-Wait for simulation to finish running, and the results will be automatically saved to a CSV file

**Performing sensitivity analysis**
-Vary the parameter(s) of interest using BehaviorSpace, i.e. '
-Read the results in Python using the file 'netlogo_to_python_analysis.py' and analyse the results using required sections of the code


**How to generate simulation results resembling the UK, Hong Kong and Italy**
-Open the 'Validation folder' in the GitHub repository
-Download parameters_to_observe.txt
-Open the country of interest
-Download 'Dissertation validation 10k *(country)*.nlogo **Note:** This simulation model is exactly the same as Dissertation.nlogo, except that certain events will automatically trigger at certain ticks to imitate the actions taken by the country.
-Download *(country)* validation parameters.txt
-Download 'NetLogo-plotter-SIRDplots *(country)*.py
-Open 'Dissertation validation 10k *(country)*.nlogo and open BehaviorSpace
-Copy and paste the contents from *(country)* validation parameters.txt into the 'Vary variables as follows' box
-Copy and paste the contents from 'parameters_to_observe.txt' into the 'Measure runs using these reporters' box
-Click OK -> Run -> Tick 'Table Output'
-A prompt will appear and ask where to save the file. Enter/select file directory
-Wait for simulation to finish running, and the results will be automatically saved to a CSV file (I have attached this CSV file as 'Dissertation validation 10k *(countries)* experiment-table.csv' in the GitHub repository, if the user wishes to skip all of the above steps
-Open and run 'NetLogo-plotter-SIRDplots *(country)*.py
-Set the file directory to where the CSV results file was saved
-Run the code and save the generated figure
