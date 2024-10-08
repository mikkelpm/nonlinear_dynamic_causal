**** JORDATAXNEWS.DO

*** Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Tax news results using Leeper, Richter, Walker series


***
*** Requires:
***     homtaxdat.xlsx 

***************************************************************************************************

 #delimit;

drop _all;
clear all;

set more 1;
set matsize 1000;
set mem 400m;

capture log close;
log using jordataxnews_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/

import excel homtaxdat.xlsx, firstrow sheet("homtaxdat") case(lower);


gen qdate = q(1945q1) + _n-1;
tsset qdate, q;

drop if quarter<1954;

*******************************************************************************
** CONSTRUCT VARIABLES
*******************************************************************************/

* DEFINE QUADRATIC TREND;

gen t = _n;
gen t2 = t^2;

gen rfedtaxrev = nfedtaxrev/pgdp;
gen rgov = ngov/pgdp;
gen rfedgov = nfed/pgdp;

gen taxy = 100*nfedtaxrev/ngdp;


** CREATE PER CAPITA LOG VARIABLES;

foreach var in rgdp rcons rcndsv rcdur rinv rnri rres tothours rfedtaxrev rgov rfedgov {;
  gen l`var' = 100*ln(`var'/pop);
};


  ** RENAME TO SHORTER NAMES;
  
gen ly = lrgdp;
gen lcns = lrcndsv;
gen lcdur = lrcdur;
gen lnri = lrnri;
gen lres = lrres;
gen lh = tothours;
gen ltax = lrfedtaxrev;
gen lg = lrfedgov;

gen h = t - 1; /*h is the horizon for the irfs */

******************************************************************************;

/*

local p = 4; /* number of lags in regressions */

** aftr15 is tax news from Leeper, Richter, Walker AEJ Policy, based on bond spreads;

local shock aftr15; 

foreach var in ly lcns lcdur lnri lres lh ltax lg taxy {;

 gen b`var' = 0;
 gen se`var' = 0;
 gen up90b`var' = 0;
 gen lo90b`var' = 0;

};

forvalues i = 0/20 {;

display as text "  ";
display as text "BASELINE RESULTS";

foreach var in ly lcns lcdur lnri lres lh ltax lg taxy { ;

newey F`i'.`var' L(0/`p').`shock' L(1/`p').taxy L(1/`p').`var'  t t2 , lag(`=`i' + 1');

  gen b`var'h`i' = _b[`shock']; 
  gen se`var'h`i' = _se[`shock'];
  
  quietly replace b`var' = b`var'h`i' if h==`i';
 * quietly replace se`var' = se`var'h`i' if h==`i';
  
    quietly replace up90b`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
	quietly replace lo90b`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
	
  };

  
};


tw (rarea up90bly lo90bly h, bcolor(gs14) clw(medthin medthin)) 
  (scatter bly h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Output", size(medsmall)) legend(off) xtitle("") saving(ly_`shock'.gph,replace);

 tw (rarea up90blcns lo90blcns h, bcolor(gs14) clw(medthin medthin)) 
  (scatter blcns h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Nondur. + Services Consumption", size(medsmall)) legend(off) xtitle("") saving(lcns_`shock'.gph,replace);
   
 
 tw (rarea up90blcdur lo90blcdur h, bcolor(gs14) clw(medthin medthin)) 
  (scatter blcdur h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Durable Consumption", size(medsmall)) legend(off) xtitle("") saving(lcdur_`shock'.gph,replace);
 
 
 tw (rarea up90blnri lo90blnri h, bcolor(gs14) clw(medthin medthin)) 
  (scatter blnri h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Nonresidential Investment", size(medsmall)) legend(off) xtitle("") saving(lnri_`shock'.gph,replace);
 
 tw (rarea up90blres lo90blres h, bcolor(gs14) clw(medthin medthin)) 
  (scatter blres h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Residential Investment", size(medsmall)) legend(off) xtitle("") saving(lres_`shock'.gph,replace);
 
 tw (rarea up90blh lo90blh h, bcolor(gs14) clw(medthin medthin)) 
  (scatter blh h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Hours", size(medsmall)) legend(off) xtitle("") saving(lh_`shock'.gph,replace);
   
 tw (rarea up90btaxy lo90btaxy h, bcolor(gs14) clw(medthin medthin)) 
  (scatter btaxy h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Tax Rates", size(medsmall)) legend(off) xtitle("") saving(taxy_`shock'.gph,replace);

* long for paper;
* graph combine ly_`shock'.gph lh_`shock'.gph lcns_`shock'.gph lcdur_`shock'.gph lnri_`shock'.gph lres_`shock'.gph , iscale(0.8) col(2) ysize(10) xsize(8);
  
* wide for slides;
graph combine ly_`shock'.gph lh_`shock'.gph lcns_`shock'.gph lcdur_`shock'.gph lnri_`shock'.gph lres_`shock'.gph , iscale(0.8) col(3) ysize(10) xsize(8);
  
*/;
  
capture log close;
