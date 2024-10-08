**** FEVDVAR.DO

****  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

***  Government Spending results

*** Performs forecast error variance decomposition using government spending shocks in a standard VAR

***
*** Requires:
***     homgovdat.xlsx 

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

import excel homgovdat.xlsx, sheet("govdat") firstrow;

gen qdate = q(1947q1) + _n-1;
tsset qdate, q;
/*******************************************************************************
***  SET PARAMETERS THAT GOVERN SPECIFICATION
*******************************************************************************/

local ynorm yquad; /* Gordon-Krenn trend normalization - baseline is yquad; other possibilities are yquart, or rypot */

local shock newsy; /* possible shocks are newsy (Ramey military news), mfev (Ben Zeev-Pappa), top3xsret (Fisher-Peters), bpshock (Blanchard-Perotti) */

local sample postwwii; /* possible samples are postwwi (1947-) or postkorea (1954-) */

local p = 4; /*lags in var */

*******************************************************************************;

/*******************************************************************************
** CONSTRUCT VARIABLES
*******************************************************************************/

* define quartic trend;

gen t = _n;
gen t2 = t^2;
gen t3 = t^3;
gen t4 = t^4;

* sample indicator;

gen postwwii = 1;
gen postkorea = (qdate>=q(1954q1));

gen taxrate = nfedreceipts/ngdp; /* average tax rate */
gen ncndsv = ncnd + ncsv; /* nominal nondurable plus services consumption */
gen tothourspc = tothours/pop; /* per capita hours worked */
gen rwbus = nwbus/pbus;  /* real compensation in business, divided by deflator for business */
gen lrwbus = ln(rwbus);
gen ltothourspc = ln(tothourspc);
gen lpgdp = ln(pgdp);
gen infl = 400*ln(pgdp/L.pgdp); /* inflation */
gen rint = tbill3 - infl; /* real interest rate */

* define real NIPA variables with common GDP deflator;

foreach var in gdp gov fedreceipts cons totinv cndsv cdur nri res {;
  gen r`var' = 100*n`var'/pgdp;
};

* define log variables for estimating Blanchard-Perotti (BP) shock;

gen lrgdp = ln(rgdp);
gen lrgov = ln(rgov);
gen lrtax = ln(rfedreceipts);


* estimate trend GDP for Gordon-Krenn normalization;

reg lrgdp t t2 t3 t4;
predict lyquart;
gen yquart = exp(lyquart);

reg lrgdp t t2;
predict lyquad;
gen yquad = exp(lyquad);

* military news shock;

gen newsy = 100*rameynews/(L.`ynorm'*L.pgdp); /* Ramey narrative military news, divided by normalization */

* normalize a la Gordon-Krenn;

foreach var in rgdp rgov rfedreceipts rcndsv rcdur rnri rres rcons rtotinv {;
  gen `var'x = `var'/`ynorm';
 
 };
 

  ** RENAME TO SHORTER NAMES;
  
gen y = rgdpx;
gen g = rgovx;
gen c = rconsx;
gen inv = rtotinvx;
gen tax = taxrate;
gen cns = rcndsvx;
gen cdur = rcdurx;
gen nri = rnrix;
gen res = rresx;
gen hr = ltothourspc;
gen w = lrwbus;

if `sample'==postwwii {;
  gen h = t - 1; /* h is the horizon */
};

else {;
   gen h = t - 1 - 28;
};


*******************************************************************************;
/* CREATE BP SHOCK

I estimate the BP shock from a standard 4 lag, log specification.

The  results are very similar if one instead estimates the BP shock directly in 
the local projection.  Since the BP shock is just the part of government 
spending orthogonal to the lagged valuesof government spending, GDP and taxes,
 one can just set bp = current GDP and include it in the local projection 
 (along with the lagged variables as controls).

To implement this alternative:  
     Substitute "gen bpshock = g;" for "reg ...;" and "predict bpshock, resid;" below */

*To estimate the BP shock separtely using logs and 4 lags;

reg lrgov L(1/4).lrgov L(1/4).lrgdp L(1/4).lrtax t t2;
predict bpshock, resid;

*******************************************************************************;


var `shock' y g tax, lags(1/`p') exog(t t2) ;

irf create irf, step(21) set(irf, replace) nose;
*irf table oirf, impulse(ffr) response(ffr lip lcpi unemp lpcom lnbr ltr lm1) noci;
*irf graph oirf, impulse(ffr) response(ffr lip lcpi unemp) byopts(rescale);
irf table fevd, impulse(`shock') response(g y) noci ;



capture log close;

