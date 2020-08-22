# NetLogo
COVID-19 Agent-based Simulation


To run the model above, please download Dissertation.nlogo and the software NetLogo 6.1.1 using the following link (Approximately 200MB):
https://ccl.northwestern.edu/netlogo/6.1.1/

Adjust parameters if necessary, then simply click "Setup Environment" followed by "Begin Simulation" to run the simulation.
Adjust the random seed number to get slight variations using the same parameters.

netlogo_to_python_analysis.py is a preprocessing code that converts the NetLogo simulation results (from BehaviorSpace) into a pandas dataframe, and contains various functions for graph-plotting, as well as generate and analyse Elementary Effects Method (EEM) trajectories.
