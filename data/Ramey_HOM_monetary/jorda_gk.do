**** JORDA_GK.DO

***  Valerie A. Ramey "Macroeconomic Shocks and Their Propagation" Handbook of Macroeconomics

*** Jorda method using Gertler-Karadi monetary shock - Figure 3B
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
log using jorda_gk_results.log, replace;

/*******************************************************************************
** RAW DATA IMPORTATION AND DATA SETUP

** SEE README SHEET OF EXCEL FILE FOR VARIABLE DEFINTIIONS
*******************************************************************************/

import excel Monetarydat.xlsx, sheet("Monthly") firstrow case(l);

gen mdate = m(1959m1) + _n-1;
tsset mdate, m;

drop if mdate<m(1984m1) | mdate>m(2012m6);

gen t = _n;

/*******************************************************************************
**  SET UP FOR LATER IRF PLOTTING
*******************************************************************************/
foreach var in ffr lip lcpi gs1 ebp { ;

  quietly gen b`var' = .;
  quietly gen up90b`var' = .;
  quietly gen lo90b`var' = .;
  
}; 


gen h = t - 1 ;  /* h is the horizon for the IRFs */

* BASELINE: RUN JORDA PROCEDURE AND CREATE MULTIPLIERS AT EACH HORIZON AND SERIES TO GRAPH THE IRFS;

******************************************************************************;

** The irfs for horizon = 0 are 1 for FFR and 0 for everything else;


*replace h = t - 1 - 72;


local p = 2;
local q = 1;  /* q = 0 corresponds to recursiveness assumption, q = 1 is less restrictive */

*  COMMENT OUT REPLACE BLIP ETC. COMMANDS BELOW WHEN q = 1 ;

global shock ff4_tc; /* ff4_tc ed2_tc ff4_gkgreen ed2_gkgreen*/


forvalues i = 0/48 {;


 foreach var in lip lcpi gs1 ebp  {;

     newey F`i'.`var' L(0/`p').$shock  L(`q'/`p').lip L(`q'/`p').gs1 L(`q'/`p').lcpi L(`q'/`p').ebp if mdate>=m(1990m1) & mdate<=m(2012m6), lag(`=`i' + 1');

     gen b`var'h`i' = _b[$shock];
  
     gen se`var'h`i' = _se[$shock];
  
     quietly replace b`var' = b`var'h`i' if h==`i'; 
     quietly replace up90b`var' = b`var'h`i' + 1.68*se`var'h`i' if h==`i';
	 quietly replace lo90b`var' = b`var'h`i' - 1.68*se`var'h`i' if h==`i';
	
  };

  
};

*replace bffr = 1 if h==0;

*************************************************;
**** Commment these commands out when q = 1;
/*
replace blip = 0 if h==0;
replace blcpi = 0 if h==0;
replace bgs1 = 0 if h==0;
replace bebp = 0 if h==0;
*/
*************************************************;


foreach var in lip lcpi gs1 ebp { ;

tw (rarea up90b`var' lo90b`var' h, bcolor(gs14) clw(medthin medthin)) 
  (scatter b`var' h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick))if h<=48,
  saving(vargk_`var'.gph,replace);
};

graph combine vargk_gs1.gph vargk_lip.gph vargk_ebp.gph vargk_lcpi.gph ;
 
outsheet h blip lo90blip up90blip bgs1 lo90bgs1 up90bgs1
 blcpi lo90blcpi up90blcpi bebp lo90bebp up90bebp using junk.csv if h<=48, replace comma;
 
/* Note that I copied this .csv file and pasted it into
  Monetary_irfs.xlsx to create nicer looking graphs in Stata.  In some cases,
  I normalized responses.*/
 

capture log close;
