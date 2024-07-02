

clear
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Subnational Analysis/PeruData.dta"
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"

encode regionregionid, gen(id)
xtset id year


regress F2.illiteracy totpop urpopratio popgrow  ustroopdeps, robust
margins, at(ustroopdeps=(0(1)2) (means) _all )
#delimit;
marginsplot, recastci(rcap) recast(scatter) ci1opts(lwidth(.25)) plot1opts(mlwidth(.25) msym(O) mfcolor(white)) graphregion(col(white)) plotregion(fcolor(white)) ///
title("") subtitle("The Effect of Deployments on Illiteracy In Peru") xtitle("US Deployments") ytitle("Illiteracy Rate");

graph export "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures/Illiteracy Peru.pdf", replace ;

regress F2.mortinf totpop urpopratio popgrow  ustroopdeps, robust
margins, at(ustroopdeps=(0(1)2) (means) _all )
#delimit;
marginsplot, recastci(rcap) recast(scatter) ci1opts(lwidth(.25)) plot1opts(mlwidth(.25) msym(O) mfcolor(white)) graphregion(col(white)) plotregion(fcolor(white)) subtitle("The Effect of Deployments on Infant Mortality in Peru") 
title("")xtitle("US Deployments") ytitle("Infant Mortality Rate");

graph export "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures/Infant Mortality Peru.pdf", replace ;


regress F2.vaccine totpop urpopratio popgrow  ustroopdeps, robust
margins, at(ustroopdeps=(0(1)2) (means) _all )
#delimit;
marginsplot, recastci(rcap) recast(scatter) ci1opts(lwidth(.25)) plot1opts(mlwidth(.25) msym(O) mfcolor(white)) graphregion(col(white)) plotregion(fcolor(white)) subtitle("The Effect of Deployments on Infant Vaccination in Peru") 
title("")xtitle("US Deployments") ytitle("Infant Vaccination Rate Linear Prediction");

graph export "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures/Vaccines Peru.pdf", replace ;
