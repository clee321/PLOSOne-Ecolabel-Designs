*Import Raw data
import excel "$Data/EcolabelDesign_raw.xlsx", firstrow clear

*Drop participants who did not consent
drop if consent==0

*Drop participants who are too young
drop if svy_status=="tooyoung"

*Drop those who did not complete the survey
drop if svy_status!="complete"

*Drop people who completed too quickly
drop if Q_TotalDuration<$toofast

*Destring numeric variables 
destring *, replace

*Decode missing values (-99) to use system missing
mvdecode *, mv(-99)

*Create numeric id
gen pid = _n


*****
*Recode age
*****
recode age (0/17 = 0) (18/29 = 1) (30/44 = 2) (45/59 = 3) (60/115 = 4) , generate(agecat)
label define agelabels 0 "0-17" 1 "18-29 years" 2 "30-44 years" 3 "45-59 years" 4 "60-115 years"
label values agecat agelabels
tab agecat

*data check
count if age>=18 & age<=29
*Result should be the same as tab for agecat group 1 (n=218)

*****
*Create Young Adult variable for moderation analyses
*****
gen youngadult=.
replace youngadult=1 if age>=18 & age <=29
replace youngadult=0 if age>29 & age!=.

*****
*Recode gender
*****
recode gender ("1" = 1) ("2" = 2) ("3" = 3) ("4" = 3) , generate(gendercat)
label define genderlabels 1 "Female" 2 "Male" 3 "Non-binary or another gender" 
label values gendercat genderlabels
tab gendercat

*data check
count if gender ==3 | gender==4
*Result should be the same as tab for gendercat group 3 (n=99)

**Create gender category with females and males only for moderation analyses
gen female =.
replace female =1 if gender ==1
replace female =0 if gender ==2
label define femalelabels 1 "Female" 0 "Male" 
label values female femalelabels
tab female

*****
*Recode race
*****

/*From codebook:
race_1=American Indian or Alaska Native
race_2=Asian
race_3=Black or African American
race_4=Native Hawaiian or Other Pacific Islander
race_5=White
race_6=Another race: __________*/

gen racecat=.
		replace racecat = 1 if race_1==1 & race_2==0 & race_3==0 & race_4==0 & race_5==0 & race_6==0 //AmInd only
		replace racecat = 2 if (race_2==1 | race_4==1) & race_1==0 & race_3==0 & race_5==0 & race_6==0 //Asian or Pacific Islander 
		replace racecat = 3 if race_3==1 & race_1==0 & race_2==0 & race_4==0 & race_5==0 & race_6==0 //Black only
		replace racecat = 4 if  race_5==1 & (race_1==0 & race_2==0 & race_3==0 & race_6==0) //White only
		replace racecat = 5 if race_6 ==1 //Other 
		
		*count total races marked and replace those who marked more than 1 race as "other or mutliracial"
		egen totalraces = rowtotal(race_1 race_2 race_3 race_4 race_5 race_6)
		replace totalraces = 1 if totalraces==2 & race_4==1 & race_2==1 //replace total races as 1 if exactly 2 races were selected and those 2 races were Asian and Pacific Islander (which we combined)
		replace racecat = 5 if totalraces>=2 & totalraces!=.
	
	label define racecatlabels 1 "Amer Ind Alas Native" 2 "Asian or Pacific Islander" 3 "Black" 4 "White" 5 "Other or multi-racial"
	label values racecat racecatlabels

*****
*Recode Latino
*****
recode latino (1=1) (0=0), generate(latinocat)
label define latinolabels 1 "Latino(a) or Hispanic" 0 "Non-Hispanic" 
label values latinocat latinolabels
tab latinocat

*****
*Recode education
*****
recode educ ("1"=1) ("2"=1) ("3"=2) ("4"=3) ("5"=3) ("6"=4), generate(educcat)
label define educlabels 1 "High school diploma or less" 2 "Some college" 3 "College graduate or associates degree" 4 "Graduate degree"
label values educcat educlabels
tab educcat

*data check
count if educ>=4 & educ<=5
	
*****
*Recode income
*****
recode income10cat (1/3 = 1) (4/5 = 2) (6 = 3) (7/10 =4) , generate(income4cat)
label define incomelabel 1 "$0 to $24,999" 2 "$25,000 to $49,999" 3 "$50,000 to $74,999" 4 "$75,000 or more"
label values income4cat incomelabel
tab income4cat

*data check
count if income10cat >=7 & income10cat!=.

*****
*Recode household size
*****
recode hhsizenum (1/2 =1) (3/4=2) (5/20=3), generate(hhsizenumcat)
label define hhsizenumlabels 1 "1-2" 2 "3-4" 3 "5 or more"
label values hhsizenumcat hhsizenumlabels
tab hhsizenumcat

*data check
count if hhsizenum >=5 & hhsizenum <=20

*****
*Recode children in household
*****
recode childrennum (0=1) (1/2=2) (3/15=3), generate(childrennumcat)
label define childrennumlabels 1 "0" 2 "1-2" 3 "3 or more"
label values childrennumcat childrennumlabels
tab childrennumcat

*data check
count if childrennum >=3 & childrennum <=15

*****
*recode party ID
*****
recode partyid ("1" =1) ("2"=1) ("3"=1) ("4"=2) ("5"=2) ("6"=2) ("7"=3) ("8"=4), generate(partyidcat)
label define partyidlabels 1 "Democrat" 2 "Republican" 3 "Independent" 4 "Other"
label values partyidcat partyidlabels
tab partyidcat

*data check
count if partyid >=1 & partyid <=3


*****
*Create BMI from weight and height
*****

*First, convert pounds to kg
generate weightkg = weightlbs*0.4536
label variable weightkg "weight (kg)"

	*check
	sum weightlbs weightkg

*Second, convert inch to feet (decimals)
generate height_heightft = height_heightinch/12
label variable height_heightft "height inches to feet"

*check
sum height_heightinch height_heightft

*Third, add inches (converted) to height in feet
generate height_total_feet = (height_heightfeet +height_heightft) 
label variable height_total_feet

*Fourth, convert height in feet to meters
*generate height_heightmeter = (height_heightfeet + height_heightft)*0.3048
gen height_heightmeter = (height_total_feet)*0.3048
label variable height_heightmeter "height (meters)"

*check
sum height_total_feet height_heightmeter

*Fifth, calculate BMI = weight (kg) / height (m)^2
generate bmi= weightkg/(height_heightmeter^2)
label variable bmi "bmi"
sum bmi
	

*Save cleaned dataset
save "$Data/FGGPilot_clean.dta", replace
