**** JORDA_ROMER.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Jorda method using Romer-Romer monetary shock - Figure 2B, part of Table 2 
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
log using jorda_romer_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/

import excel Monetarydat.xlsx, sheet("Monthly") firstrow case(l);

gen mdate = m(1959m1) + _n-1;
tsset mdate, m;

drop if mdate<m(1969m3);

gen rrshockorig = D.cumrrshockorig;

replace lip = 100*lip;
replace lcpi = 100*lcpi;
replace lpcom = 100*lpcom;

gen t = _n;

/*******************************************************************************
**  SET UP FOR LATER IRF PLOTTING
*******************************************************************************/
foreach var in ffr lip lcpi unemp  { ;
  quietly gen b`var' = .;
  quietly gen up90b`var' = .;
  quietly gen lo90b`var' = .;  
}; 

/*******************************************************************************
***  SET PARAMETERS THAT GOVERN SPECIFICATION
*******************************************************************************/

*  Sample;
gen sample_6996 = (mdate>=m(1969m3) & mdate<=m(1996m12));
gen sample_6907 = (mdate>=m(1969m3) & mdate<=m(2007m12));
gen sample_8307 = (mdate>=m(1983m1) & mdate<=m(2007m12));

local years 6996;  /*choices are 6996, 6907, or 8307 */

* use original Romer-Romer shock or updated one;
local shock rrshockorig; /*rrshockorig (available 1969-1996) or rrshock (available 1969-2007)*/

local p = 2;  /* p = number of lags */
local q = 1;  /* q = 0 corresponds to recursiveness assumption, q = 1 is less restrictive */

local favar = 1;  /* favar= 0 is no FAVAR, favar = 1 is with factors */

*******************************************************************************;

* ESTIMATE USING JORDA PROCEDURE AND GRAPH THE IRFS;

******************************************************************************;

gen h = t - 1 ; /* h is the horizon for the irfs */

 if `years'==8307 {;
         replace h = t - 1 - 168;  /* h is the horizon for the irfs */
   };

if `favar' ==0 {;

forvalues i = 0/48 {;

   foreach var in ffr lip lcpi unemp  {;

      newey F`i'.`var' L(0/`p').`shock'  L(`q'/`p').lip L(`q'/`p').unemp L(`q'/`p').lcpi L(`q'/`p').lpcom L(1/`p').ffr if sample_`years'==1, lag(`=`i' + 1');
	 
	  gen b`var'h`i' = _b[`shock'];
  
      gen se`var'h`i' = _se[`shock'];
 
      quietly replace b`var' = b`var'h`i' if h==`i'; 
      quietly replace up90b`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
	  quietly replace lo90b`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
	
  }; 
};

*******************************************************************************;
**** Commment these commands out when q = 1;
/*replace blip = 0 if h==0;
replace blcpi = 0 if h==0;
replace bunemp = 0 if h==0;
*/
*******************************************************************************;

foreach var in ffr lip lcpi unemp  { ;

tw (rarea up90b`var' lo90b`var' h, bcolor(gs14) clw(medthin medthin)) 
  (scatter b`var' h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick))if h<=48,
  saving(varromer_`var'.gph,replace);
};

graph combine varromer_ffr.gph varromer_lip.gph varromer_unemp.gph varromer_lcpi.gph ;



outsheet h bffr lo90bffr up90bffr blip lo90blip up90blip bunemp lo90bunemp up90bunemp
 blcpi lo90blcpi up90blcpi using junk.csv if h<=48, replace comma ;
 
/* Note that I copied this .csv file and pasted it into
  Monetary_irfs.xlsx to create nicer looking graphs in Stata.  In some cases,
  I normalized responses.*/

};

else {; 

 /******************************************************************************
 Includes 5 FAVAR factors, from Shihan Xie
 ******************************************************************************/
 
 forvalues i = 0/48 {;

  foreach var in ffr lip lcpi unemp { ;

    newey F`i'.`var' L(0/`p').`shock' L(1/`p').`var' L(1/`p').ffr L(`q'/`p').factor1 L(`q'/`p').factor2
       L(`q'/`p').factor3 L(`q'/`p').factor4 L(`q'/`p').factor5 if sample_`years'==1, lag(`=`i' + 1');

      gen b`var'h`i' = _b[`shock'];
   
      gen se`var'h`i' = _se[`shock'];
  
      quietly replace b`var' = b`var'h`i' if h==`i'; 
      quietly replace up90b`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
	  quietly replace lo90b`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
	
  };

  
};

foreach var in ffr lip lcpi unemp  { ;

tw (rarea up90b`var' lo90b`var' h, bcolor(gs14) clw(medthin medthin)) 
  (scatter b`var' h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick))if h<=48,
  saving(varromer_`var'.gph,replace);
};

graph combine varromer_ffr.gph varromer_lip.gph varromer_unemp.gph varromer_lcpi.gph ;

outsheet h bffr lo90bffr up90bffr blip lo90blip up90blip bunemp lo90bunemp up90bunemp
 blcpi lo90blcpi up90blcpi using junk.csv if h<=48, replace comma ;
 
 /* Note that I copied this .csv file and pasted it into
  Monetary_irfs.xlsx to create nicer looking graphs in Stata.  In some cases,
  I normalized responses.*/
 
};

capture log close;
