//reshape the data for Peru


reshape long x, i(regionregionid indicator) j(year)
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData1.dta", replace
drop indicatorname indicatornote regionname regionnote scale units

use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear

reshape wide x, i(regionregionid year) j(indicator) string
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", replace

//Add variables for local parties
gen governorparty=.
label var governorparty "party of local government, at region level"
gen execparty=.
label var execparty "Coded one of local party same as executive"

//add variables for US troops
gen ustroop=0
label var ustroop "Actual number of US development-oriented troops present that year"
**Note, this one isn't filled in yet


label var ustroopdeps "Number of deployments in that year"

gen ustroopdummy=0
label var ustroopdummy "Dummy variable for presence of US development deployment"
replace ustroopdummy=1 if ustroopdeps>0

//add variable for landlock
gen landlock=0
label var landlock "Landlocked region"


//come up with a numeric id for the regions
egen regionid=group(regionregionid)
tsset regionid year

//fill in population
label var xAJJ "Total Population, 2007 census"
rename xAJJ totpop
replace totpop=totpop[_n-1] if missing(totpop)
replace totpop=totpop[_n+1] if missing(totpop)
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", replace

	//urban population
label var xAWU "Total Urban, 2007 census"
rename xAWU urpop
replace urpop=urpop[_n-1] if missing(urpop)
replace urpop=urpop[_n+1] if missing(urpop)
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", replace

	//ration of urban to total population
	gen urpopratio=urpop/totpop
	label var urpopratio "ratio of urban to total population"

//add in the COW country code (this may come in handy if we do this analysis across states)
gen ccode=135

//agricultural area
label var agarea "Agricultural Area in Hectares, no variation across years"
rename xAAO agarea
replace agarea=agarea[_n-1] if missing(agarea)
replace agarea=agarea[_n+1] if missing(agarea)

//pop growth rate
label var xCAH "Annual Average Growth Rate of Population, percentagee"
rename xCAH popgrow

//infant mortality
label var xBZJ "Infant mortality rate, per 1000 live births" 
rename xBZJ mortinf

//vaccinations
	label var xAWD "Vaccine coverage among children under 1 year, percent" 
	rename xAWD vaccine

//gross value added
label var xANX "Gross value added at constant 1994 prices" 
rename xANX gva94

label var xANY "Gross value added at current prices" 
rename xANY gva

label var xANW "Gross value added precent" 
rename xANW gvaprecent

//illiteracy
label var xAPL "Illiteracy rate of population 15 years or overr" 
rename xAPL illiteracy



//landlock
gen landlock=0
replace landlock=1 if regionid==1
replace landlock=1 if regionid==3
replace landlock=1 if regionid==5
replace landlock=1 if regionid==6
replace landlock=1 if regionid==8
replace landlock=1 if regionid==9
replace landlock=1 if regionid==10
replace landlock=1 if regionid==12
replace landlock=1 if regionid==16
replace landlock=1 if regionid==17
replace landlock=1 if regionid==19
replace landlock=1 if regionid==22
replace landlock=1 if regionid==25
label var landlock "Coded 1 if region does not have a coastline" 
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", replace


**********************************************************
//Begin actual analysis

	//with illiteracy (some basic regressions)
regress illiteracy gva94 totpop urpop landlock agarea
regress illiteracy ustroopdeps
regress illiteracy gva94 totpop urpop landlock ustroopdeps
regress illiteracy gva94 ustroopdummy
**note, GVA only runs until 2011, which would make us lose several troop observations
regress illiteracy totpop urpop landlock ustroopdeps, robust
**lag troops
regress illiteracy totpop urpop popgrow landlock l.ustroopdeps, robust

	//with infant mortality
regress mortinf totpop urpop popgrow landlock l.ustroopdeps, robust

	//with vaccines
regress vaccine totpop urpop popgrow landlock l.ustroopdeps, robust

use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear

eststo clear
	
la var mortinf "Infant Mortality"
la var vaccine "Infant Vaccination"
la var illiteracy "Illiteracy"
la var totpop "Total Population"
la var urpop "Urban Population"
la var popgrow "Population Growth"
la var landlock "Landlock"
la var ustroopdeps "Development-Oriented Deployments" 
la var ustroopdummy "Dummy Development-Oriented Deployments"
la var urpopratio "Urban Population Ratio"

	eststo: regress illiteracy totpop urpopratio popgrow landlock l.ustroopdeps, robust
	eststo: regress mortinf totpop urpopratio popgrow landlock l.ustroopdeps, robust
	eststo: regress vaccine totpop urpopratio popgrow landlock l.ustroopdeps, robust

	


#delimit;
esttab _all using Table1.tex, se starlevels(* .10 ** .05 *** .01) label scalars(N r2) 
title("The Effect of US Troops on Development Outcomes in Peruvian Regions")  replace;

//look at changes in variables

regress d.illiteracy totpop urpop popgrow landlock l.ustroopdeps, robust
regress d.mortinf totpop urpop popgrow landlock l.ustroopdeps, robust
regress d.vaccine totpop urpop popgrow landlock l.ustroopdeps, robust

eststo clear
	
la var mortinf "Infant Mortality"
la var vaccine "Infant Vaccination"
la var illiteracy "Illiteracy"
la var totpop "Total Population"
la var urpop "Urban Population"
la var popgrow "Population Growth"
la var landlock "Landlock"
la var ustroopdeps "Development-Oriented Deployments" 
la var ustroopdummy "Dummy Development-Oriented Deployments"
la var urpopratio "Urban Population Ratio"

	eststo: regress d.illiteracy totpop urpopratio popgrow landlock l.ustroopdeps, robust
	eststo: regress d.mortinf totpop urpopratio popgrow landlock l.ustroopdeps, robust
	eststo: regress d.vaccine totpop urpopratio popgrow landlock l.ustroopdeps, robust



#delimit;
esttab _all using Table2.tex, se starlevels(* .10 ** .05 *** .01) label scalars(N r2) 
title("The Effect of US Troops on Change in Development Outcomes in Peruvian Regions")  replace;


//Marginal Effects Figures
use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear
capture cd "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Figures"
gen lagustroopdeps=ustroopdeps[_n-1]
regress illiteracy totpop urpopratio popgrow landlock lagustroopdeps, robust
margins, at(lagustroopdeps=(0(1)2))
#delimit;
marginsplot, recastci(rarea) recast(line) graphregion(col(white)) plotregion(fcolor(white)) title("The Effect of Deployments on Illiteracy in Peru") 
subtitle("Predictive Margins with 95% CIs")xtitle("US Deployments") ytitle("Illiteracy Rate Linear Prediction");

		graph export "IlliteracyPeru.pdf", as(pdf) replace;	
		
use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear
capture cd "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Figures"
gen lagustroopdeps=ustroopdeps[_n-1]
regress mortinf totpop urpopratio popgrow landlock lagustroopdeps, robust
margins, at(lagustroopdeps=(0(1)2))
#delimit;
marginsplot, recastci(rarea) recast(line) graphregion(col(white)) plotregion(fcolor(white)) title("The Effect of Deployments on Infant Mortality in Peru") 
subtitle("Predictive Margins with 95% CIs")xtitle("US Deployments") ytitle("Infant Mortality Rate Linear Prediction");

		graph export "MortInfPeru.pdf", as(pdf) replace;

//This last one is not particularly pretty		
use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear
capture cd "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Figures"
gen lagustroopdeps=ustroopdeps[_n-1]
regress vaccine totpop urpopratio popgrow landlock lagustroopdeps, robust
margins, at(lagustroopdeps=(0(1)2))
#delimit;
marginsplot, recastci(rarea) recast(line) graphregion(col(white)) plotregion(fcolor(white)) title("The Effect of Deployments on Infant Vaccination in Peru") 
subtitle("Predictive Margins with 95% CIs")xtitle("US Deployments") ytitle("Infant Vaccination Rate Linear Prediction");

		graph export "VaccinePeru.pdf", as(pdf) replace;	

		
//Look at the determinants of subnational deployments
regress ustroopdeps l.urpop l.illiteracy l.totpop l.popgrow, vce(robust)
regress ustroopdeps l.urpop l.vaccine l.totpop l.popgrow, vce(robust)
regress ustroopdeps l.urpop l.mortinf l.totpop l.popgrow, vce(robust)
regress ustroopdeps l.urpop l2.mortinf l2.vaccine l2.illiteracy l.totpop l2.popgrow, vce(robust)
eststo clear
	
la var mortinf "Infant Mortality"
la var vaccine "Infant Vaccination"
la var illiteracy "Illiteracy"
la var totpop "Total Population"
la var urpop "Urban Population"
la var popgrow "Population Growth"
la var landlock "Landlock"
la var ustroopdeps "Development-Oriented Deployments" 
la var ustroopdummy "Dummy Development-Oriented Deployments"
la var urpopratio "Urban Population Ratio"

eststo: regress ustroopdeps l2.urpopratio l2.illiteracy l2.totpop l2.popgrow, vce(robust)
eststo: regress ustroopdeps l2.urpopratio l2.vaccine l2.totpop l2.popgrow, vce(robust)
eststo: regress ustroopdeps l2.urpopratio l2.mortinf l2.totpop l2.popgrow, vce(robust)
eststo: regress ustroopdeps l2.urpopratio l2.mortinf l2.vaccine l2.illiteracy l2.totpop l2.popgrow, vce(robust)



#delimit;
esttab _all using Table3.tex, se starlevels(* .10 ** .05 *** .01) label scalars(N r2) nodepvars
title("Predicting Deployment for Region Year in Peru, 2002-2013")  replace;		


**********************Appendix Stuff******************************

	****Like Table 1, but with dummy vars

use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear

eststo clear
	
la var mortinf "Infant Mortality"
la var vaccine "Infant Vaccination"
la var illiteracy "Illiteracy"
la var totpop "Total Population"
la var urpop "Urban Population"
la var popgrow "Population Growth"
la var landlock "Landlock"
la var ustroopdeps "Development-Oriented Deployments" 
la var ustroopdummy "Dummy Development-Oriented Deployments"
la var urpopratio "Urban Population Ratio"

	eststo: regress illiteracy totpop urpopratio popgrow landlock l.ustroopdummy, robust
	eststo: regress mortinf totpop urpopratio popgrow landlock l.ustroopdummy, robust
	eststo: regress vaccine totpop urpopratio popgrow landlock l.ustroopdummy, robust

	


#delimit;
esttab _all using TableA1.tex, se starlevels(* .10 ** .05 *** .01) label scalars(N r2) 
title("The Effect of US Troops on Development Outcomes in Peruvian Regions, Dummy DV")  replace;
	
	
		**Like Table 3, but with dummy vars
gen ustroopdummy=0
label var ustroopdummy "Dummy variable for presence of US development deployment"
replace ustroopdummy=1 if ustroopdeps>0

save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\Subnational Analysis\PeruData.dta", replace		

eststo clear
	
la var mortinf "Infant Mortality"
la var vaccine "Infant Vaccination"
la var illiteracy "Illiteracy"
la var totpop "Total Population"
la var urpop "Urban Population"
la var popgrow "Population Growth"
la var landlock "Landlock"
la var ustroopdeps "Development-Oriented Deployments" 
la var ustroopdummy "Dummy Development-Oriented Deployments"
la var urpopratio "Urban Population Ratio"

eststo: probit ustroopdummy l2.urpopratio l2.illiteracy l2.totpop l2.popgrow, vce(robust)
eststo: probit ustroopdummy l2.urpopratio l2.vaccine l2.totpop l2.popgrow, vce(robust)
eststo: probit ustroopdummy l2.urpopratio l2.mortinf l2.totpop l2.popgrow, vce(robust)
eststo: probit ustroopdummy l2.urpopratio l2.mortinf l2.vaccine l2.illiteracy l2.totpop l2.popgrow, vce(robust)



#delimit;
esttab _all using TableA3.tex, se starlevels(* .10 ** .05 *** .01) label scalars(N r2) nodepvars
title("Predicting Deployment (Dichotomous) for Region Year in Peru, 2002-2013")  replace;		






**********Stuff with political variables******************************


//Look at the effect of the troops on politics?	
regress divstate_match totpop urpop popgrow l.ustroopdeps, robust
regress divexec_ideology totpop urpop popgrow l.ustroopdeps, robust	
		
//Just  look at the selection of regions on its own
regress ustroopdeps l.divstate_match, vce(robust)
regress ustroopdeps l.divstate_match urpop illiteracy vaccine totpop popgrow, vce(robust)

regress ustroopdeps l.divstate_matchideo, vce(robust)
regress ustroopdeps l.divstate_matchideo urpop landlock, vce(robust)
regress ustroopdeps l.divstate_match totpop urpop popgrow landlock illiteracy, vce(robust)

probit ustroopdummy l.divstate_match, vce(robust)
probit ustroopdummy l.divstate_match urpop illiteracy, vce(robust)
//Heckman selection model?

heckman illiteracy urpop totpop landlock l.ustroopdeps, select(ustroopdummy= totpop urpop popgrow illiteracy) vce(robust)

///////////politics in Peru

gen ExecPartyMatch=.
replace ExecPartyMatch=0 if year>2002
replace ExecPartyMatch=1 if year==2006 & regionid==5
replace ExecPartyMatch=1 if year==2006 & regionid==6
replace ExecPartyMatch=1 if year>2005 & year<2011 & regionid==13
replace ExecPartyMatch=1 if year==2006 & regionid==15
replace ExecPartyMatch=1 if year>2005 & year<2011 & regionid==20
replace ExecPartyMatch=1 if year==2006 & regionid==22
replace ExecPartyMatch=1 if year==2006 & regionid==23
replace ExecPartyMatch=1 if year==2006 & regionid==24
la var ExecPartyMatch "Region governor same party as President"

	**merge in Becca's political data
		**copy the data into stata
	drop country
	replace division="PE-ANC" if division=="Áncash"
	replace division="PE-AMA" if division=="Amazonas"
	replace division="PE-APU" if division=="Apurímac"
	replace division="PE-ARE" if division=="Arequipa"
	replace division="PE-AYA" if division=="Ayacucho"
	replace division="PE-CAJ" if division=="Cajamarca"
	replace division="PE-CAL" if division=="Callao"
	replace division="PE-CUS" if division=="Cuzco"
	replace division="PE-HUV" if division=="Huancavelica"
	replace division="PE-HUC" if division=="Huánuco"
	replace division="PE-JUN" if division=="Junín"
	replace division="PE-ICA" if division=="Ica"
	replace division="PE-LAL" if division=="La Libertad"
	replace division="PE-LAM" if division=="Lambayeque"
	replace division="PE-LIM" if division=="Lima"
	replace division="PE-LOR" if division=="Loreto"
	replace division="PE-MDD" if division=="Madre de Dios"
	replace division="PE-MOQ" if division=="Moquegua"
	replace division="PE-PAS" if division=="Pasco"
	replace division="PE-PIU" if division=="Pirua"
	replace division="PE-PIU" if division=="Piura"
	replace division="PE-PUN" if division=="Puno"
	replace division="PE-SAM" if division=="San Martin"
	replace division="PE-TAC" if division=="Tacna"
	replace division="PE-TUM" if division=="Tumbes"
	replace division="PE-UCA" if division=="Ucayali"
	
	sort division year
	
	egen regionid=group(division)
	save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\Subnational Analysis\PeruPoliData.dta", replace

	use "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", clear
	
	merge 1:1 regionid year using "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\Subnational Analysis\PeruPoliData.dta"
	drop if _merge==2
	drop _merge

	
	la var divstate_match "Region governor same party as President"
	la var divexec_ideology "Region governor ideology, 1-left, 0-right"
	la var stateexec_ideology "President ideology that year, 1-left, 0-right"
	la var stateexec_homediv "Home division of President"
	la var divexec "Name of governor"
	la var stateexec "Name of President that year"
	rename staetexec_party stateexec_party
	la var stateexec_party "President's party"
	
	gen divstate_matchideo=.
	replace divstate_matchideo=0 if year>2002
	replace divstate_matchideo=1 if stateexec_ideology==divexec_ideology & stateexec_ideology~=.
	la var divstate_matchideo "Region governor same ideology as President" 


	
save "C:\Users\carlamm\Dropbox\Working Papers\Troops and Development\Data\PeruData.dta", replace
