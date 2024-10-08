**** JORDAGOV.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Government spending results

*** The first part estimates IRFs using Jorda on Gordon-Krenn transformation variables
*** The second part conducts F-tests and estimates multipliers using the one-step IV method
***    estension of Jorda 

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
log using jordagov_results.log, replace;

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

local p = 2; /*lags in regressions */

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


/*

* INITIALIZE SUM OF EFFECTS TO 0 AND PARAMETERS SERIES TO MISSING;

foreach var in y g tax cns cdur nri res hr tbill3 rint w  { ;
 
  quietly gen b`var' = .;
  quietly gen lo90`var' = .;
  quietly gen up90`var' = .;
  
}; 

gen ftest = .;

global `shock'xlist L(1/`p').`shock' L(1/`p').y L(1/`p').g L(1/`p').tax t t2;

*global bpxlist L(1/`p').y L(1/`p').g L(1/`p').tax t t2;


******************************************************************************;
/* I use ivreg2 even for basic regressions because it can do automatic bandwidth
    selection.  I also use it along with weakiv for actual IV below. */

*  ESTIMATE IRFS;

forvalues i = 0/20 {;

  foreach var in y g tax {;
  
    ivreg2 F`i'.`var' `shock' $`shock'xlist if `sample'==1, robust bw(auto);

    gen b`var'h`i' = _b[`shock'];
  
    gen se`var'h`i' = _se[`shock'];
  
  };
  
 
foreach var in cns cdur nri res hr tbill3 rint w { ; /* include lags of LHS variable on RHS */

  ivreg2 F`i'.`var' `shock' $`shock'xlist L(1/`p').`var' if `sample'==1, robust bw(auto);
 
  gen b`var'h`i' = _b[`shock'];
  
  gen se`var'h`i' = _se[`shock'];
};

foreach var in y g tax cns cdur nri res hr tbill3 rint w  { ;
   
  quietly replace b`var' = b`var'h`i' if h==`i';
  quietly replace up90`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
  quietly replace lo90`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
  
 };

  
};

* output results to a .csv file so they can be imported to Excel for better graphs;

outsheet by lo90y up90y bg lo90g up90g btax lo90tax up90tax brint lo90rint up90rint
  bcns lo90cns up90cns bcdur lo90cdur up90cdur bnri lo90nri up90nri bres lo90res up90res 
  bhr lo90hr up90hr bw lo90w up90w using junkirf.csv, comma replace;

  
/*******************************************************************************
** THIS PART ESTIMATES MULTIPLIERS USING THE ONE-STEP METHOD AND CALCULATES THE
INSTRUMENT RELEVANCE STATISTICS
*******************************************************************************/

* CREATE CUMULATIVE VARIABLES FOR ESTIMATING MULTIPLIERS;

foreach var in y g  {;
  gen cum_`var' = 0;
  gen mult_`var' = 0;
  gen semult_`var' = 0;
  
  forvalues i = 0/20 {;
  
   gen cum`i'_`var' = F`i'.`var' + cum_`var';
	replace cum_`var' = cum`i'_`var';
  };	
};


 forvalues i = 0/20 {; 
 
ivreg2 cum`i'_y (cum`i'_g = `shock') $`shock'xlist , robust bw(auto);			
				
     gen multh`i'_y = _b[cum`i'_g]; 
     gen semulth`i'_y = _se[cum`i'_g];	 
	 gen ftesth`i'= e(widstat); /* Kleibergen-Paap rk Wald F statistic*/
	 
     weakivtest; /* Run this to get the Montiel and Pflueger's critical values*/
	
     quietly replace mult_y = multh`i'_y if h==`i';
     quietly replace semult_y = semulth`i'_y if h==`i';
	 quietly replace ftest = ftesth`i' if h==`i';
  
  };

display as text "MULTIPLIERS, STANDARD ERRORS, EFFECTIVE F-STATISTICS";

list h mult_y semult_y ftest if h<=20;

* output results to a .csv file so they can be imported to Excel for better graphs;
outsheet h mult_y semult_y ftest using junkf.csv if h<=20, comma replace;

*/;

capture log close;

