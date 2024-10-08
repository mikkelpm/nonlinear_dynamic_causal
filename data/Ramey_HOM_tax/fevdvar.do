**** FEVDVAR.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

***  Tax results

***  Estimates effects of unanticipated Romer-Romer tax shock using Jorda

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
log using fevdvar_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/
import excel homtaxdat.xlsx, firstrow sheet("homtaxdat") case(lower);


gen qdate = q(1945q1) + _n-1;
tsset qdate, q;

drop if quarter<1947;


gen rfedtaxrev = nfedtaxrev/pgdp; /* real federal tax revenue */
gen rgov = ngov/pgdp;  /* real government spending, using GDP deflator */
gen rfedgov = nfed/pgdp; /* real federal spending, using GDP deflator */

gen taxy = 100*nfedtaxrev/ngdp; /* average tax rate */


** CREATE PER CAPITA LOG VARIABLES;

foreach var in rgdp rcons rinv tothours rfedtaxrev rgov rfedgov {;
  gen l`var' = 100*ln(`var'/pop);
};


 
  ** RENAME TO SHORTER NAMES;
  
gen ly = lrgdp;
gen lc = lrcons;
gen li = lrinv;
gen lh = ltothours;
gen ltax = lrfedtaxrev;
gen lg = lrfedgov;


* Preset variables to missing for later replace for IRFS;

foreach var in ly lc li lh ltax lg taxy { ;

  quietly gen b`var' = .;
  quietly gen up90b`var' = .;
  quietly gen lo90b`var' = .;
  
}; 



drop if quarter<1950;

* DEFINE QUADRATIC TREND;

gen t = _n;
gen t2 = t^2;

* BLANCHARD-PEROTTI DUMMY VARIABLE;

gen dum75q2 = 0;
replace dum75q2 = 1 if qdate == q(1975q2);


*Possible shocks:  aftr15 rrtaxu taxu;

local shock aftr15;

local p = 4;


var `shock' ly lg ltax , lags(1/`p') exog(t t2) ;

irf create irf, step(21) set(irf, replace) nose ;
irf table fevd, impulse(`shock' ) response(ly) noci;

capture log close;

