**** JORDATAX.DO

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
log using jordatax_results.log, replace;

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

* DEMEAN THE TAX SHOCK AS MERTENS-RAVEN DO;

gen rrtaxu_dm = 0;

summ rrtaxu if rrtaxu~=0;
replace rrtaxu_dm = rrtaxu - r(mean) if rrtaxu~=0;

gen dtaxy = D.taxy;
gen dltax = D.ltax;

gen h = t - 1; /* h is the horizon for the IRFs */

*******************************************************************************;
* REDUCED FORM JORDA
*******************************************************************************;

local shock rrtaxu;  /*choices are exogenrratio rrtaxu_dm rrtaxu;*/

local p=4; /* number of lags */

forvalues i = 0/20 {;

newey F`i'.ly `shock' L(1/`p').ly L(1/`p').lg L(1/`p').ltax t t2 dum75q2, lag(`=`i' + 1');

  gen blyh`i' = _b[`shock'];
  
  gen selyh`i' = _se[`shock'];
  
newey F`i'.ltax `shock' L(1/`p').ly L(1/`p').lg L(1/`p').ltax t t2 dum75q2, lag(`=`i' + 1');

  gen bltaxh`i' = _b[`shock'];
  
  gen seltaxh`i' = _se[`shock'];
   
  
  foreach var in ly ltax {;
  
    quietly replace b`var' = b`var'h`i' if h==`i';
    quietly replace up90b`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
	quietly replace lo90b`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
	
  };
 
};


tw (rarea up90bly lo90bly h, bcolor(gs14) clw(medthin medthin)) 
  (scatter bly h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Output", size(medsmall)) legend(off) xtitle("") saving(ly_`shock'.gph,replace);

 tw (rarea up90bltax lo90bltax h, bcolor(gs14) clw(medthin medthin)) 
  (scatter bltax h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Tax Revenue", size(medsmall)) legend(off) xtitle("") saving(ltax_`shock'.gph,replace);
   
 graph combine ltax_`shock'.gph ly_`shock'.gph  , iscale(1.8)  ysize(3) xsize(10);
 
 
*******************************************************************************;
** IV Jorda;
*******************************************************************************; 

drop blyh* selyh*;

reg dltax `shock' L(1/`p').ly L(1/`p').ltax L(1/`p').lg t t2 dum75q2, robust;
gen b`shock' = _b[`shock'];
 
 forvalues i = 0/20 {;
 
 ivreg2 F`i'.ly (dltax = `shock') L(1/`p').ly L(1/`p').ltax L(1/`p').lg t t2 dum75q2, robust bw(auto);

  gen blyh`i' = _b[dltax];
  
  gen selyh`i' = _se[dltax];
  

foreach var in ly {;
  
    quietly replace b`var' = b`var'h`i'*b`shock' if h==`i'; 
    quietly replace up90b`var' = (b`var'h`i' + 1.68*se`var'h`i')*b`shock' if h==`i';
	quietly replace lo90b`var' = (b`var'h`i' - 1.68*se`var'h`i')*b`shock' if h==`i';
	
  };

  
};

tw (rarea up90bly lo90bly h, bcolor(gs14) clw(medthin medthin)) 
  (scatter bly h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=20 ,
   title("Output", size(medsmall)) legend(off) xtitle("") saving(lyiv_`shock'.gph,replace) scale(1.2);
   

capture log close;
