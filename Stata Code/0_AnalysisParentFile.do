*Analysis Parent File

*Replace xxx with your Stata username
	*If your forgot your username, run the following command to retrieve your username: [display "`c(username)'"] 
*Replace yyy with the applicable folder location

*User file paths
if "`c(username)'" =="xxx" {

	global Data "/yyy/PLOSOne-Ecolabel-Designs/Project folders-files/Data"
	global Code "/yyy/PLOSOne-Ecolabel-Designs/Stata Code"
	global ResultsEco "/yyy/PLOSOne-Ecolabel-Designs/Project folders-files/Results/Ecolabel"

}

global toofast = 616/3
//Median completion time from Cloud Connect interface = 616 sec

*************
*Run the codes below:

*Data cleaning and preparation
run "$Code/1.1_DataPrep.do"
run "$Code/1.2_Ecolabel DataPrep.do"

*Demographic Table (Table 1)
run "$Code/2_Table 1.do"

*Data analysis
run "$Code/3_Ecolabel Analysis.do"


