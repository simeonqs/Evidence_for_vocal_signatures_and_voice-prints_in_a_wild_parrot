The analysis consist of the following steps:

- 00_run_methods:
	- 00_create_data_sets.R: creates a data set for all call types; the resulting object contains a dataframe with all information for each call as well as the file names
	- 00_run_methods.R: this sources the different steps for each method; each step can also be sourced independently from the respective folders
- 01_compare_methods:
	00_compare_methods.R: run comparison of the methods
- 02_compare_call_types: compares the individual signature within each call type using the different methods
	00_visualise_methods.R: 