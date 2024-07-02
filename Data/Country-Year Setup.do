
* Country-Year Data setup

clear
tempfile clear
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data"

* Bilateral trade data
import excel "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/US Exports and Imports.xlsx", sheet("country") firstrow case(lower)
destring year, replace
keep if year >= 1999
keep year ctyname iyr eyr
kountry ctyname, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown) geo(cow)
keep if GEO == "North and South America" 
rename _COWN_ ccode
label var iyr "Exports to US"
label var eyr "Imports from US"
rename iyr exports_to_us
rename eyr imports_from_us
drop GEO

* Oroginal Census data are in current dollars
* Constant 2010 dollars
merge m:1 year using "~/Dropbox/Projects/Troops and Development/Data/Raw Data/cpi_1913_2015.dta", nogen
sum cpi if year == 2010
replace cpi = cpi/r(mean)
replace exports_to_us = exports_to_us/cpi
replace imports_from_us = imports_from_us/cpi
sort ccode year
tempfile ustrade
save `ustrade', replace



* Iraq contributions
clear
import excel "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/Iraq Coalition Contributions.xlsx", sheet("Sheet1") firstrow case(lower)
format beginyear %d
format endyear %d
gen beginyear2 = year(beginyear)
gen endyear2 = year(endyear)
drop beginyear endyear
rename beginyear beginyear
rename endyear endyear
gen duration = (endyear-beginyear)+1
expand duration
sort country
by country: egen year = seq()
replace year = (beginyear+year)-1
drop wounded begin end
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown) geo(cow)
keep if GEO == "North and South America"
drop iso3n GEO
rename _COWN_ ccode
sort ccode year

tempfile iraq
save `iraq', replace


* Polity IV (2014) release
clear
import excel "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/p4v2014.xls", sheet("p4v2014") firstrow
keep ccode year polity2 durable
keep if year >= 1999 
drop if ccode == .
sort ccode year

tempfile polity 
save `polity', replace


* World Bank GDP (Constant 2005 Dollars)
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank GDP/83a1e20c-ff2d-460d-b63d-3bfef7814e99_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ gdp_2005
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile gdp 
save `gdp', replace


* World Bank Infant Mortality Rate Data
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank IMR/09508e1d-4bb1-419a-a275-77169f9cc773_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ imr
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile imr
save `imr', replace


* World Bank Exports of Goods and Services as % of GDP
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Exports of Goods and Services/81eb36a3-eb8a-4cfa-969e-8e9faa56b254_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ exports_gs
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile exports
save `exports', replace


* World Bank Agricultural Employment (% total employment)
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Agriculture Employment/4c4f16f5-f664-4120-8f6c-71d85dd8ec52_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ agemploy
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile agemploy
save `agemploy', replace


* World Bank Net Enrollment (% elligible students)
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Net Enrollment/c0e43861-a182-4ff6-b222-5db9f981214e_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ enrollment
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile enroll
save `enroll', replace


* World Bank Rural Population (% Total Population)
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Rural Population/b854d068-fd28-47e4-b75d-dc851e072308_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ ruralpop
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile rural
save `rural', replace



* World Bank Total Population 
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Population/ab6d9678-03d9-4e2a-a845-a028e1b42be0_v2.csv", delimiter(comma) rowrange(6) encoding(ISO-8859-1)
rename v1 country
drop v2-v4
local i = 1960
foreach var of varlist v5-v59 {
rename `var' y_`i'
local i = `i'+1
}
drop v60 v61
reshape long y_ , i(country) j(year)
rename y_ tpop
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
drop if ccode == .
sort ccode year

tempfile pop
save `pop', replace


* World Bank Fuel Exports % Exports
clear
import delimited "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/World Bank Energy Data/Data_Extract_From_World_Development_Indicators_Data.csv", delimiter(comma) varnames(1) encoding(ISO-8859-1)
drop in 3211/3215
rename èàtime year
rename countryname country
rename fuelexportsofmerchandiseexportst  fuelexp
rename oilrentsofgdpnygdppetrrtzs oilrents
rename naturalgasrentsofgdpnygdpngasrtz natgasrents
destring year, replace
keep year country fuelexp oilrents natgasrents
destring natgasrents fuelexp oilrents, ignore("..") replace
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown) geo(cow)
rename _COWN_ ccode
drop if ccode == .
keep if GEO == "North and South America"
drop if ccode == 2
drop if ccode == 20
drop GEO iso3n
sort ccode year
tempfile fuel
save `fuel', replace



* UN Ideal Point Distance
clear
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/Dyadic13undirected.dta"
keep ccode1 ccode2 year s3un absidealimportantdiff
keep if year >= 1999
keep if ccode1 == 2
kountry ccode2, from(cown) geo(cow)
keep if GEO == "North and South America"
drop if ccode2 == 20
drop ccode1 NAMES_STD GEO
rename ccode2 ccode
sort ccode year

tempfile un
save `un', replace



* Merge BTH Data
clear
import excel "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Raw Data/BTH History.xlsx", sheet("Sheet1") firstrow case(lower)
sort country year
kountry country, from(other) stuck
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(cown)
drop iso3n
rename _COWN_ ccode
order ccode country year
gen intervention = 1
collapse (mean) intervention, by(ccode year)
sort ccode year

tempfile milint
save `milint', replace



* Merge Data
clear
use `polity'
merge 1:1 ccode year using `ustrade', nogen
merge 1:1 ccode year using `gdp', nogen
merge 1:1 ccode year using `imr', nogen
merge 1:1 ccode year using `exports', nogen
merge 1:1 ccode year using `agemploy', nogen
merge 1:1 ccode year using `enroll', nogen
merge 1:1 ccode year using `rural', nogen
merge 1:1 ccode year using `pop', nogen
merge 1:1 ccode year using `fuel', nogen
merge 1:1 ccode year using `un', nogen
merge 1:1 ccode year using `iraq', nogen
merge 1:1 ccode year using `milint', nogen

drop if year < 2002

kountry ccode, from(cown) geo(cow)
rename GEO region
keep if region == "North and South America"
sort ccode
drop if ccode == 2
drop if ccode == 20
drop region
drop NAMES_STD 
order ccode country year

gen lngdp = ln(gdp_2005)
gen lntpop = ln(tpop)
gen gdppc = gdp_2005/tpop
gen lngdppc = ln(gdppc)
gen lnimr = ln(imr)
gen lnexports_to_us = ln(exports_to_us)
gen lnimports_from_us = ln(imports_from_us)
gen lnfuel = ln(fuel+1)
gen lnoil = ln(oil+1)
gen lnnatgas = ln(natgasrents+1)

replace intervention = 0 if intervention == .
foreach var of varlist troopstotal troopspeak dead duration {
replace `var' = 0 if `var' == .
}

gen iraqcoal = 0
replace iraqcoal = 1 if troopstotal > 0

gen aor = 0
replace aor = 1 if ccode == 40
replace aor = 1 if ccode == 41
replace aor = 1 if ccode == 42
replace aor = 1 if ccode == 51
replace aor = 1 if ccode == 52
replace aor = 1 if ccode == 53
replace aor = 1 if ccode == 54
replace aor = 1 if ccode == 55
replace aor = 1 if ccode == 56
replace aor = 1 if ccode == 57
replace aor = 1 if ccode == 58
replace aor = 1 if ccode == 60
replace aor = 1 if ccode == 80
replace aor = 1 if ccode == 90
replace aor = 1 if ccode == 91
replace aor = 1 if ccode == 92
replace aor = 1 if ccode == 93
replace aor = 1 if ccode == 94
replace aor = 1 if ccode == 95
replace aor = 1 if ccode == 100
replace aor = 1 if ccode == 101
replace aor = 1 if ccode == 110
replace aor = 1 if ccode == 115
replace aor = 1 if ccode == 130
replace aor = 1 if ccode == 135
replace aor = 1 if ccode == 140
replace aor = 1 if ccode == 145
replace aor = 1 if ccode == 150
replace aor = 1 if ccode == 155
replace aor = 1 if ccode == 165

gen alba = 0
replace alba = 1 if ccode == 58 & year>=2009
replace alba = 1 if ccode == 145 & year>=2006
replace alba = 1 if ccode == 40 & year>=2004
replace alba = 1 if ccode == 54 & year>=2008
replace alba = 1 if ccode == 130 & year>=2009
replace alba = 1 if ccode == 55 & year>=2014
replace alba = 1 if ccode == 93 & year>=2007
replace alba = 1 if ccode == 60 & year>=2014
replace alba = 1 if ccode == 56 & year>=2013
replace alba = 1 if ccode == 57 & year>=2009
replace alba = 1 if ccode == 101 & year>=2004
replace alba = 1 if ccode == 91 & year>=2008 & year <= 2009



label var aor "SOUTHCOM AOR"
label var ruralpop "Rural Population"
label var s3un "UN Voting"
label var iraqcoal "Iraq Coalition"
label var lngdppc "ln(GDP Per Capita)"
label var polity2 "Polity"
label var enrollment "Educational Enrollment" 
label var lnexports_to_us "ln(Exports to US)"
label var lnimports_from_us "ln(Imports from US)"
label var imr "Infant Mortality Rate"
label var alba  "ALBA Member"
label var fuelexp "Fuel Exports"
label var natgasrents "Natural Gas Rents"
label var oilrents "Oil Rents"
label var lnfuel "Fuel Exports"
label var lnnatgas "Natural Gas Rents"
label var lnoil "Oil Rents"


save "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta", replace


