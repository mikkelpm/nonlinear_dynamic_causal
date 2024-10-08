**** GRAPHFSTAT.DO

***
*** Graphs impulse responses

***
*** Requires:
***     irfdat*.csv 

***************************************************************************************************

 #delimit;

drop _all;
clear all;

set more 1;

capture log close;



import excel using Multipliersirfs.xlsx, firstrow sheet("ftestdat");

foreach var in newsy newsyb mfev mfevb bpshock bpshockb top3xsret top3xsretb {;
  replace `var' = 50 if `var'>50;
};


tw scatter newsy mfev bpshock top3xsret h, c(l l l l) clp(l l _ _) ms(o i d i) clc(blue green red orange) mc(blue green red orange)
  clw(medthick medthick medthick medthick)  ylabel(, nogrid) yline(23.1 37.4, lc(black) lp(-) lw(thin)) ytitle("F-statistic")
  ylabel(,angle(horizontal)) title("A. 1947q1 - latest", size(medsmall)) legend(off) xtitle("Horizon") scale(0.9) saving(ffull.gph,replace);
  
  tw scatter newsyb mfevb bpshockb top3xsretb h, c(l l l l) clp(l l _ _) ms(o i d i) clc(blue green red orange) mc(blue green red orange)
  clw(medthick medthick medthick medthick)  ylabel(, nogrid) yline(23.1 37.4, lc(black) lp(-) lw(thin)) ytitle("F-statistic")
  ylabel(,angle(horizontal)) title("B. 1954q1 - latest", size(medsmall)) legend(off) xtitle("Horizon") scale(0.9) saving(f1954.gph,replace);
  
*graph combine ffull.gph f1954.gph, col(1) ysize(7) xsize(5) iscale(1.3);
graph combine ffull.gph f1954.gph, col(2) ysize(4) xsize(7) iscale(1.3);
