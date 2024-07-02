


clear
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Tables"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"

xtset ccode year

eststo clear
eststo: probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal if ccode != 70, robust
eststo: probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal s3un if ccode != 70, robust
eststo: probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal s3un ruralpop enrollment if ccode != 70, robust
eststo: probit F2.intervention c.lngdppc##c.lnimports_from_us polity2 imr alba iraqcoal s3un if ccode != 70, robust


#delimit ;
esttab _all using Table_CYModels_20160224.tex, replace 
	scalars("p Prob $ > \chi^2$") 
	nodep
	nomtitles
	se(3) 
	b(3) 
	obslast 
	label 
	se 
	nogaps 
	star(* 0.10 ** 0.05 *** 0.01)  
	compress
	order(lngdppc lnimports_from_us c.lngdppc#c.lnimports_from_us imr ruralpop enrollment polity2 alba iraqcoal s3un)  
	nonotes 
	addnote("Robust standard errors in parentheses. Two-tailed significance tests used." "$*$ p$\leq$ 0.10; $**$ p$\leq$ 0.05; $***$ p$\leq$0.01") 
	;		
	
	#delimit cr
	
	

* Predicted probability of development deployment
* Imports from US
clear 
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"

xtset ccode year

probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal if ccode != 70, robust

		sum lnimports_from_us if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, at(lnimports_from_us=(`min'(`interval')`max') (means) _all alba=0 iraqcoal=0) level(95) vsquish

		
		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100))   
		plot1opts(lwidth(.50)) 
		xlabel(, format(%9.1fc)) 
		xdimension(lnimports_from_us)
		ylabel()
		ytitle("Pr(Deployment)")
		legend(off)
		title("")
		;	
		
		
		
* Predicted probability of development deployment (Using End-point transformation)
* Imports from US
clear 
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"

xtset ccode year

probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal if ccode != 70, robust

		sum lnimports_from_us if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, at(lnimports_from_us=(`min'(`interval')`max') (means) _all alba=0 iraqcoal=0) level(95) vsquish predict(xb)
		
		matrix drop _all
		transform_margins normal(@), mat(results)
		svmat results, names(col)
		keep if b != .
		keep b ll ul
		
		range trade `min' `max'
		twoway rarea ll ul trade , fi(100) color(gs14) ///
		|| line b trade, lwidth(.6)  ///
		xlab(`min'(`interval')`max', format(%9.1fc)) ///
		xtitle("ln(Imports from US)") ///
		ytitle("Pr(Deployment)") ///
		legend(off) ///
		name(prtrade, replace)
		
		
		
		

* Predicted probability of development deployment
* ln(GDP Per Capita)
clear
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"

xtset ccode year

probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal if ccode != 70, robust

		sum lngdppc if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, at(lngdppc=(`min'(`interval')`max') ) vsquish 

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100))   
		plot1opts(lwidth(.50)) 
		xlabel(, format(%9.1fc)) 
		xdimension(lngdppc)
		ylabel()
		ytitle("Pr(Deployment)")
		legend(off)
		title("")
		;	
		
		

		
* Predicted probability of development deployment (Using End-point transformation)
* GDP per capita
clear 
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"

xtset ccode year

probit F2.intervention lngdppc polity2 imr lnimports_from_us alba iraqcoal if ccode != 70, robust

		sum lngdppc if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, at(lngdppc=(`min'(`interval')`max') (means) _all alba=0 iraqcoal=0) level(95) vsquish predict(xb)
		
		matrix drop _all
		transform_margins normal(@), mat(results)
		svmat results, names(col)
		keep if b != .
		keep b ll ul
		
		range gdp `min' `max'
		twoway rarea ll ul gdp , fi(100) color(gs14) ///
		|| line b gdp, lwidth(.6)  ///
		xlab(`min'(`interval')`max', format(%9.1fc)) ///
		xtitle("ln(GDP Per Capita)") ///
		ytitle("Pr(Deployment)") ///
		legend(off) ///
		name(prgdp, replace)
		
		graph combine prtrade prgdp, ycommon cols(2) xsize(8) ysize(4) iscale(0.85)
		graph export PR_gdp_trade_combined.pdf, replace
		
		
		
		
		

	
* Marginal Effects of imports from US and GDP Per Capita
* dydx(imports)
clear
cd "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Figures"
use "/Users/michaelflynn/Dropbox/Projects/Troops and Development/Data/Country Level Data.dta"
xtset ccode year

		probit F2.intervention c.lngdppc##c.lnimports_from_us polity2 imr alba iraqcoal s3un if ccode != 70, robust
		
		sum lngdppc if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, dydx(lnimports_from_us) at(lngdppc=(`min'(`interval')`max')) vsquish

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.1fc)) 
		xdimension(lngdppc)
		ylabel(, axis(2) format(%9.1fc))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity lngdppc if e(sample), xlab(`min'(`interval')`max') color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("(a)")
		name(graph1, replace)
		;
		#delimit cr

* Marginal Effects of imports from US and GDP Per Capita
* dydx(gdppc)


		probit F2.intervention c.lngdppc##c.lnimports_from_us polity2 imr alba iraqcoal s3un if ccode != 70, robust
		
		sum lnimports_from_us if e(sample)
		local min = r(min)
		local max = r(max)
		local interval = ((`max'-`min')/15)
		margins, dydx(lngdppc) at(lnimports_from_us=(`min'(`interval')`max')) vsquish 

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.1fc)) 
		xdimension(lnimports_from_us)
		ylabel(, axis(2) format(%9.1fc))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity lnimports_from_us if e(sample), xlab(`min'(`interval')`max') color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("(b)")
		name(graph2, replace)
		;
		#delimit cr
		
	graph combine graph1 graph2, ycommon cols(2) xsize(4) ysize(2) iscale(0.90)
	graph export "ME_trade_income.pdf", replace
