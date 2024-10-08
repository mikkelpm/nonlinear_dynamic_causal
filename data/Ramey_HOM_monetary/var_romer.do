**** VAR_ROMER.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Estimation for Figure 2A and Table 2 (R&R rows):  Romer-Romer-type VARs 
***
*** Requires:
***     Monetarydat.xlsx

***************************************************************************************************

 #delimit;

drop _all;
clear all;

set more 1;
set matsize 1000;
set mem 400m;

capture log close;
log using var_romer_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/

import excel Monetarydat.xlsx, sheet("Monthly") firstrow case(l);

gen mdate = m(1959m1) + _n-1;
tsset mdate, m;


/*******************************************************************************
** TEST OF HYBRID VAR RECURSIVENESS RESTRICTION USING ROMER-ROMER AS INSTRUMENT
*******************************************************************************/
gen dffr = D.ffr;

ivreg2 lip (dffr = rrshock) L(1/12).lip L(1/12).unemp L(1/12).lpcom L(1/12).lcpi L(1/12).ffr, robust;
 
ivreg2 unemp (dffr = rrshock) L(1/12).lip L(1/12).unemp L(1/12).lpcom L(1/12).lcpi L(1/12).ffr, robust;

* Recursiveness assumption requires that the coefficient on dffr = 0;

/*******************************************************************************
* ROMER-ROMER HYBRID VAR 

** Note that I copied the output of 'irf table' and pasted it into
  Monetary_irfs.xlsx to create nicer looking graphs in Stata.  In some cases,
  I normalized responses.
	
** to estimate bootstrap standard errors with 500 replications, include the 
   option "bs resp(500)" in "irf create" after the ","
 
*******************************************************************************/


*** 1969:1 - 1996:12 ORIGINAL SAMPLE;

var lip unemp lcpi lpcom cumrrshockorig if mdate>=m(1969m1) & mdate<=m(1996m12), lags(1/12) level(90) ; 

irf create irf, step(48) set(irf, replace);
irf table oirf, impulse(cumrrshockorig) response(cumrrshockorig lip lcpi unemp);
irf graph oirf, impulse(cumrrshockorig) response(lip);
irf table fevd, impulse(cumrrshockorig) response(lip);


*** 1969:1 - 2007:12 SAMPLE;

var lip unemp lcpi lpcom cumrrshock if mdate>=m(1969m1) & mdate<=m(2007m12), lags(1/12) level(90) ; 

/* "nose" option implies run with no standard errors - remove option to obtain standard errors*/

irf create irf, step(48) set(irf, replace) nose; 
irf table oirf, impulse(cumrrshock) response(cumrrshock lip lcpi unemp) level(90);
irf graph oirf, impulse(cumrrshock) response(lip);
irf table fevd, impulse(cumrrshock) response(lip);


*** 1983:1 - 2007:12 SAMPLE;

var lip unemp lcpi lpcom cumrrshock83 if mdate>=m(1983m1) & mdate<=m(1996m12), lags(1/12) level(90) ; 

irf create irf, step(48) set(irf, replace) nose;
irf table oirf, impulse(cumrrshock83) response(cumrrshock83 lip lcpi unemp) noci;
irf graph oirf, impulse(cumrrshock83) response(cumrrshock83 lip unemp lcpi) byopts(rescale);


capture log close;
