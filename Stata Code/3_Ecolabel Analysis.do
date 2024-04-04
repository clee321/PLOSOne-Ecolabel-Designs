

use "$Data/FGGPilot_clean_long ecolabel primary.dta", clear

**Outcomes
*	perceived msg effectiveness (primary) - average pmeencXX##, pmeappealXX##
*	attention to the labels, - attnXX##
*	thinking about environmental effects, - elabXX## 
*	anticipated social interactions, and - talkXX##
*	believability. - believeXX##


**#Linear Mixed Effect Regression

foreach var in pme attn elab talk believe{

mixed `var' i.ecolabel || pid: , mle

margins, dydx (ecolabel)

	matrix a = r(table)'
	matrix list a

	putexcel set "$ResultsEco/Primary_LMER and pwcompare.xlsx", sheet("`var'") modify
	putexcel A1 = ("`var' LMER")
	putexcel A2 = "`e(cmdline)'"
	putexcel C1 = ("1: control | 2: numeric | 3: text | 4:icon | 5:text+icon")
	putexcel B4 = matrix(a), names nformat(number_d2)
	
	
*Pairwise comparisons
pwcompare 2.ecolabel 3.ecolabel 4.ecolabel 5.ecolabel, groups effects

matrix c = r(table_vs)'
matrix list c
putexcel set "$ResultsEco/Primary_LMER and pwcompare.xlsx", sheet("`var'") modify
putexcel A12 = ("`var' Pairwise comparisons")
putexcel A13 = "No adjustment"
putexcel C12 = ("1: control | 2: numeric | 3: text | 4:icon | 5:text+icon")
putexcel A14= matrix(c), names nformat(number_d2)

matrix b = r(table)'
matrix list b
putexcel set "$ResultsEco/Primary_LMER and pwcompare.xlsx", sheet("`var'") modify
putexcel A23 = ("`var' Pairwise comparisons")
putexcel A24 = "No adjustment"
putexcel C23 = ("1: control | 2: numeric | 3: text | 4:icon | 5:text+icon")
putexcel A25= matrix(b), names nformat(number_d2)

local row=26
forval f=1/5{
putexcel K`row'="`r(groups`f')'"
local ++row
}
}


**Means
foreach var in pme attn elab talk believe{

mixed `var' i.ecolabel || pid: , mle

margins i.ecolabel

	matrix a = r(table)'
	matrix list a

	putexcel set "$ResultsEco/Primary_LMER and pwcompare.xlsx", sheet("`var'_means") modify
	putexcel A1 = ("`var' Means")
	putexcel A2 = "`e(cmdline)'"
	putexcel C1 = ("1: control | 2: numeric | 3: text | 4:icon | 5:text+icon")
	putexcel B4 = matrix(a), names nformat(number_d2)
}

**#Moderation
*Younger and older adults

mixed pme i.ecolabel##i.youngadult || pid: , mle
testparm i.ecolabel#i.youngadult


/////////////////

**#Secondary Analysis
**#Topic

use "$Data/FGGPilot_clean_long ecolabel secondary.dta", clear

**LMER

**Topics

mixed enc i.ecotopic || pid:
matrix a = r(table)'
matrix list a

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Topic") modify
putexcel A1= "Topics"
putexcel A2= "`e(cmdline)'"
putexcel C1=("1: low climate impact | 2: earth-friendly | 3: sust. choice | 4: env-friendly | 5: climate-friendly | 6: low carbon")
putexcel A4= matrix (a), names nformat(number_d2)

**Pairwise comparisons
pwcompare 2.ecotopic 3.ecotopic 4.ecotopic 5.ecotopic 6.ecotopic, groups effects

matrix c = r(table_vs)'
matrix list c

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Topic") modify
putexcel A15 = ("Topic Pairwise comparisons")
putexcel A16 = "No adjustment"
putexcel C15 = ("1: low climate impact | 2: earth-friendly | 3: sust. choice | 4: env-friendly | 5: climate-friendly | 6: low carbon")
putexcel A17= matrix(c), names nformat(number_d2)

matrix b = r(table)'
matrix list b

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Topic") modify
putexcel A29 = ("Topic Pairwise comparisons")
putexcel A30 = "No adjustment"
putexcel C29 = ("1: low climate impact | 2: earth-friendly | 3: sust. choice | 4: env-friendly | 5: climate-friendly | 6: low carbon")
putexcel A31= matrix(b), names nformat(number_d2)

local row=32
forval f=1/6{
putexcel K`row'="`r(groups`f')'"
local ++row
}

**Means
margins i.ecotopic

	matrix a = r(table)'
	matrix list a

	putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Topic_means") modify
	putexcel A1 = ("Topic Means")
	putexcel A2 = "`e(cmdline)'"
	putexcel C1 = ("1: low climate impact | 2: earth-friendly | 3: sust. choice | 4: env-friendly | 5: climate-friendly | 6: low carbon")
	putexcel A4 = matrix(a), names nformat(number_d2)

	
**#Icons
mixed enc i.ecoicon || pid:
matrix a = r(table)'
matrix list a

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Icon") modify
putexcel A1= "Icons"
putexcel A2= "`e(cmdline)'"
putexcel C1=("1: leaves | 2: earth | 3: check | 4: coolfood")
putexcel A4= matrix (a), names nformat(number_d2)

**Pairwise comparisons
pwcompare 2.ecoicon 3.ecoicon 4.ecoicon, groups pveffects

matrix c = r(table_vs)'
matrix list c

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Icon") modify
putexcel A14 = ("Icon Pairwise comparisons")
putexcel A15 = "No adjustment"
putexcel C14 = ("1: leaves | 2: earth | 3: check | 4: coolfood")
putexcel A16 = matrix(c), names nformat(number_d2)

matrix b = r(table)'
matrix list b

putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Icon") modify
putexcel A22 = ("Icon Pairwise comparisons")
putexcel A23 = "No adjustment"
putexcel C22 = ("1: leaves | 2: earth | 3: check | 4: coolfood")
putexcel A24 = matrix(b), names nformat(number_d2)

local row=25
forval f=1/4{
putexcel K`row'="`r(groups`f')'"
local ++row
}

**Means
margins i.ecoicon

	matrix a = r(table)'
	matrix list a

	putexcel set "$ResultsEco/Secondary_LMER and pwcompare.xlsx", sheet("Icon_means") modify
	putexcel A1 = ("Icon Means")
	putexcel A2 = "`e(cmdline)'"
	putexcel C1 = ("1: leaves | 2: earth | 3: check | 4: coolfood")
	putexcel A4 = matrix(a), names nformat(number_d2)
	