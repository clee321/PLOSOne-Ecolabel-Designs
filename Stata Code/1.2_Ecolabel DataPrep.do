**Transform datasets from wide to long for:
* Primary analysis
* Secondary analysis

use "$Data/FGGPilot_clean.dta", clear
count

**#Data Prep - Primary Analysis

*Participants saw 3 labels for each condition (3 controls, 3 numeric, etc.). Outcomes were measured for each of the 3 labels - e.g. attn1, attn2, attn3 
*Re-organize outcomes - first measures altogether in one column, same for second and third measures

forvalues f=1/3{
	foreach var in pmeenc pmeappeal attn elab talk believe {
			
gen `var'`f' = .
replace `var'`f'=`var'control0`f' if ecolabel==1
replace `var'`f'=`var'numeric0`f' if ecolabel==2
replace `var'`f'=`var'text0`f' if ecolabel==3
replace `var'`f'=`var'icon0`f' if ecolabel==4
replace `var'`f'=`var'texticon0`f' if ecolabel==5
		
	}
}

**Reshape to Long
**Reshaped e.g. attn1, attn2, attn3 to attn (3 rows for each id)
 
reshape long pmeenc pmeappeal attn elab talk believe, i(pid) j(ecoseq)

*recode ecolabel arms
gen ecolabel2 = ecolabel
label define ecolabel_lab 1 "control" 2 "numeric" 3 "text" 4 "icon" 5 "texticon"
label values ecolabel ecolabel_lab

*check total counts, range of values for attn and ecolabel
tab attn ecolabel


**Averaged pme - pmeenc and pmeappeal

spearman pmeenc pmeappeal

local sbpf = 2*r(rho) / (1+r(rho))
di "The Spearman-Brown Prophesy Reliability Estimate is `sbpf'" 

egen pme = rowmean (pmeenc pmeappeal) 

save "$Data/FGGPilot_clean_long ecolabel primary.dta", replace


///////////


**#Data Prep - Secondary Analysis
*(enctopic1-6, encicon1-4)

use "$Data/FGGPilot_clean.dta", clear

**Reshape to Long
**10 columns will be collapsed into 1. Participants rated 10 different labels. Within-subject design.

reshape long enc, i(pid) j(ecodesign) string

**Create two variables - ecotopic and ecoicon (from ecodesign)
gen ecotopic =.
	replace ecotopic = 1 if ecodesign=="topic1"
	replace ecotopic = 2 if ecodesign=="topic2"
	replace ecotopic = 3 if ecodesign=="topic3"
	replace ecotopic = 4 if ecodesign=="topic4"
	replace ecotopic = 5 if ecodesign=="topic5"
	replace ecotopic = 6 if ecodesign=="topic6"	
	
gen ecoicon =.
	replace ecoicon = 1 if ecodesign=="icon1"
	replace ecoicon = 2 if ecodesign=="icon2"
	replace ecoicon = 3 if ecodesign=="icon3"
	replace ecoicon = 4 if ecodesign=="icon4"

				
save "$Data/FGGPilot_clean_long ecolabel secondary.dta", replace
