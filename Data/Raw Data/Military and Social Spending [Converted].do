

clear 
cd "/Users/michaelflynn/Dropbox/My Courses/Media"
import excel "/Users/michaelflynn/Dropbox/Data Files/US Government Files/historical_superfunction.xls", sheet("Table") cellrange(A3:CE58) firstrow case(lower) clear
set more off

drop am

local i = 1940
foreach var of varlist b-ce {
rename `var' y_`i'
local i = `i'+1
}

destring y_1940-y_2020, force replace

rename inmillionsofdollars category

encode category, gen(cat)
drop category
order cat, before(y_1940)

keep if cat==20 | cat==16 | cat==30 | cat==27 | cat==21 

gen idno = 1000+[_n]

reshape long y_, i(idno) j(year)
rename y_ spend

merge m:1 year  using "~/Dropbox/Data Files/US Government Files/BLS/cpi_1913_2015.dta"
keep if year >= 1940
replace cpi = cpi/100
drop _merge
sum cpi if year == 2014
local cpi = r(mean)
replace cpi = cpi/`cpi'

gen spend_cons = spend/cpi if spend>100
drop cpi
sort idno year
drop cat
reshape wide  spend spend_cons, i(year) j(idno)

rename spend1001 def
rename spend_cons1001 def_cons
rename spend1002 hr
rename spend_cons1002 hr_cons
rename spend1003 vets
rename spend_cons1003 vets_cons
rename spend1004 federal
rename spend_cons1004 federal_cons
rename spend1005 def_fed
rename spend1006 hr_fed
rename spend1007 fed_totalperc
rename spend1008 def_gdp
rename spend1009 hr_gdp
rename spend1010 fed_gdp


replace vets_cons = vets_cons/1000
* US Veterans spending
twoway bar vets_cons year, fcolor(eltblue) ///
xlabel(1940(10)2020) xtitle(Year) ///
ytitle("Billions of 2014 dollars") ///
title("US Spending on Veterans Benefits and Services") ///
note("Data obtained from https://www.whitehouse.gov/omb/budget/Historicals", size(vsmall))
graph export "US Veterans Spending.pdf", replace


* Defense as a percentage of federal expenditures and gdp
twoway bar def_fed year,  fcolor(eltblue) ///
|| bar def_gdp year, fcolor(emidblue) ///
xlabel(1940(10)2020) xtitle(Year) ///
ylabel(0(20)100) ///
ytitle("Percent") ///
legend(lab(1 "Defense as % Federal Spending") lab(2 "Defense as % GDP") ring(0) pos(1) symxsize(4)) ///
title("US Military Spending as a Percentage of Total Federal Spending and GDP") ///
note("Data obtained from https://www.whitehouse.gov/omb/budget/Historicals", size(vsmall))
graph export "US Military Spending over Federal Spending and GDP.pdf", replace


* Defense Expenditures and Social Spending
graph bar def_fed hr_fed, over(year, label(angle(90) labsize(tiny))) stack ///
bar(1, fcolor(emidblue)) bar(2, fcolor(eltblue)) ///
legend(lab(1 "Defense as % Federal Spending") lab(2 "Social Spending as % Federal Spending") ring(0) pos(1) symxsize(4)) ///
ylabel(0(20)105) yline(100) ///
b1title(Year) ///
ytitle(Percentage) ///
title("Military and Social Spending as a Percentage of Federal Spending") ///
note("Data obtained from https://www.whitehouse.gov/omb/budget/Historicals", size(vsmall))
graph export "US Military and Social Spending Over Federal.pdf", replace

replace def_cons = def_cons/1000
twoway bar def_cons year, fcolor(eltblue)  ///
xlabel(1940(10)2020) ///
ylabel(0(200)1200) ///
ytitle("Billions of constant 2014 Dollars") ///
xtitle(Year) ///
title("US Military Spending, 1940–2014") ///
note("Data obtained from https://www.whitehouse.gov/omb/budget/Historicals", size(vsmall))
graph export "US Military Spending 1940-2015.pdf", replace


graph bar def_cons vets_cons, stack over(year, label(labsize(tiny) angle(90)))  ///
ylabel(0(200)1200) ///
ytitle("Billions of constant 2014 Dollars") ///
b1title(Year) ///
bar(1, fcolor(emidblue)) bar(2, fcolor(eltblue)) ///
title("US Military Spending Including Veteran Spending, 1940–2014") ///
legend(lab(1 "Defense Spending") lab(2 "Veterans' Spendings") symxsize(4) ring(0) pos(1)) ///
note("Data obtained from https://www.whitehouse.gov/omb/budget/Historicals", size(vsmall))
graph export "US Military Spending Including Veterans.pdf", replace


