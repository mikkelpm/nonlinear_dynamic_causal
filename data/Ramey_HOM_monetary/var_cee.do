**** VAR_CEE.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Estimation for Figure 1 and Table 2 (first few rows):  Christiano, Eichenbaum, Evans (1999)-type VARs 
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
log using var_cee_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/

import excel Monetarydat.xlsx, sheet("Monthly") firstrow case(l);

gen mdate = m(1959m1) + _n-1;
tsset mdate, m;


/*******************************************************************************
* ESTIMATION 

** Note that I copied the output of 'irf table' and pasted it into
  Monetary_irfs.xlsx to create nicer looking graphs in Stata.  In some cases,
  I normalized responses.
	
** Note that the "bs resp(500)" bootstrap standard error option in "irf create"
  below makes it take a long time to run.  To obtain coefficient estimates more 
  quickly without bootstrap standard errors, use the versions given at the end 
  of the program
********************************************************************************/

*******************************************************************************;
** CEE SAMPLE, WITH MONETARY VARIABLES;
*******************************************************************************;

var lip unemp lcpi lpcom ffr lnbr ltr lm1 if mdate>=m(1965m1) & mdate<=m(1995m6), lags(1/12) level(90); 

irf create irf, step(48) bs reps(500) set(cee, replace);
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr lnbr ltr lm1) level(90);
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale) level(90);
irf table fevd, impulse(ffr) response(lip);

*******************************************************************************;
** FULL SAMPLE, WITH MONETARY VARIABLES;
*******************************************************************************;

var lip unemp lcpi lpcom ffr lnbr ltr lm1 if mdate>=m(1959m1) & mdate<=m(2007m12), lags(1/12) level(90); 

irf create irf, step(48) bs reps(500) set(cee, replace);
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr lnbr ltr lm1) level(90);
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale) level(90);
irf table fevd, impulse(ffr) response(lip);

*******************************************************************************;
** LATER SAMPLE, WITH MONETARY VARIABLES;
*******************************************************************************;

var lip unemp lcpi lpcom ffr lnbr ltr lm1 if mdate>=m(1983m1) & mdate<=m(2007m12), lags(1/12) level(90); 

irf create irf, step(48) bs reps(500) set(cee, replace);
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr lnbr ltr lm1) level(90);
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale) level(90);
irf table fevd, impulse(ffr) response(lip);

*******************************************************************************;
** LATER SAMPLE, NO MONETARY VARIABLES;
*******************************************************************************;

var lip unemp lcpi lpcom ffr if mdate>=m(1983m1) & mdate<=m(2007m12), lags(1/12) level(90); 

irf create irf, step(48) bs reps(500) set(cee, replace);
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr) level(90);
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale) level(90);
irf table fevd, impulse(ffr) response(lip);

*******************************************************************************;
/* To estimate things more quickly with the default conventional standard errors, substitute:

irf create irf, step(48) set(cee, replace);
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr lnbr ltr lm1) level(90);
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale) level(90);
irf table fevd, impulse(ffr) response(lip);

or for quick estimates with no standard errors (nose) and no confidence intervals (noci):

irf create irf, step(48) set(cee, replace) nose;
irf table oirf, impulse(ffr) response(lip unemp lcpi lpcom ffr lnbr ltr lm1) noci;
irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale);
irf table fevd, impulse(ffr) response(lip) noci;

*******************************************************************************/

capture log close;
