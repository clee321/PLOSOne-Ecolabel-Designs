
use "$Data/FGGPilot_clean.dta", clear

label define ecolabel_lab 1 "control" 2 "numeric" 3 "text" 4 "icon" 5 "texticon"
label values ecolabel ecolabel_lab

dtable i.agecat i.gendercat i.racecat i.latinocat i.educcat i.income4cat i.hhsizenumcat i.childrennumcat i.partyidcat, by (ecolabel) ///
nformat(%9.0f percent fvpercent) ///
nformat(%9.1f mean sd)

putexcel set "$ResultsEco/Eco_Table 1.xlsx", modify
putexcel A2 = collect

