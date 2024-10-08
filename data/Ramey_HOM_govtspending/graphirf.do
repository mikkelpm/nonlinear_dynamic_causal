**** GRAPHIRF.DO

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


*foreach model in var_baseline var_quadtrend romervar_baseline romervar_quadtrend psvar_baseline psvar_1983 psvar_quadtrend
*  jorda_cholesk jorda_romer jorda_romer_small jorda_romer_small_quadtrend { ;

/*RomerVAR RomerVAR83 psvar_baseline psvar_1983 psvar_1983b Jorda_IV_Romer Jorda_IV_Romer83
   Jorda_IV_RR_GK psvar_bc Jorda_IV_BC psvar_90 psvar_90b Jorda_IV_RR_BC_GK*/
   
   *psvar_90 is GK ff4_TC used in the Coibion regression;
/*
foreach model in psvar_90b {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
     foreach var in lipirf liplo lipup lcpiirf lcpilo lcpiup { ;
    replace `var' = 100*`var';
  };


label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";



tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lcpiirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter unempirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);

 


foreach var in lcpi {; 

tw (rarea `var'up `var'lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter `var'irf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title(" `var' ") legend(off) saving(`model'.gph,replace);
  
};


 
 graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph
   `model'_lcpi.gph, iscale(1) saving(`model'combine.gph, replace) ysize(4) xsize(7);

    };
	
capture log close;





foreach model in jordaiv_romer_gk { ;

  drop _all;
  clear all;
	
  insheet using irf_`model'.csv;
  
*  sort h;
*  merge 1:1 h using junk.dta;
  
  foreach var in lipirf liplo lipup lcpiirf lcpilo lcpiup { ;
    replace `var' = 100*`var';
  };


label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lcpiirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter unempirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
    

 


foreach var in lcpi {; 

tw (rarea `var'up `var'lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter `var'irf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title(" `var' ") legend(off) saving(`model'.gph,replace);
  
};


 graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph
   `model'_lcpi.gph, iscale(1) saving(`model'combine.gph, replace) ysize(4) xsize(7);

    };
	
capture log close;
*/

*********************************************;
* FIGURE 4.2:  Govt spending;
*********************************************;

import excel using Multipliersirfs.xlsx, firstrow sheet("bpshock");

summ girf; 
scalar gnorm = r(max);
   
  foreach var in yirf girf taxirf cnsirf cdurirf nriirf resirf hrirf wirf { ;
     gen `var'b = `var'/gnorm;
  };
   
  gen rintirfb = rintirf/(gnorm*100);
  sort horiz;
  
  keep horiz yirfb girfb taxirfb rintirfb cnsirfb cdurirfb nriirfb resirfb hrirfb wirfb;
  save junkb.dta, replace;

clear all;

import excel using Multipliersirfs.xlsx, firstrow sheet("mfev");

summ girf; 
scalar gnorm = r(max);
   
  foreach var in yirf girf taxirf cnsirf cdurirf nriirf resirf hrirf wirf { ;
     gen `var'm = `var'/gnorm;
  };
   
  gen rintirfm = rintirf/(gnorm*100);
  sort horiz;
  
  keep horiz yirfm girfm taxirfm rintirfm cnsirfm cdurirfm nriirfm resirfm hrirfm wirfm;
  save junkm.dta, replace;

foreach model in newsy {;

   drop _all;
   clear all;
   import excel using Multipliersirfs.xlsx, firstrow sheet("`model'");
   
   summ girf; 
   scalar gnorm = r(max);
   
   foreach var in y g tax cns cdur nri res hr w { ;
     replace `var'irf = `var'irf/gnorm;
	 replace `var'lo = `var'lo/gnorm;
	 replace `var'up = `var'up/gnorm;
  };
 
     replace rintirf = rintirf/(gnorm*100);
	 replace rintlo = rintlo/(gnorm*100);
	 replace rintup = rintup/(gnorm*100);

merge 1:1 horiz using junkb.dta; drop _merge;
sort horiz;
merge 1:1 horiz using junkm.dta;

gen h = horiz;

label var yirf "GDP";
label var girf "Government Purchases";
label var taxirf "Average Tax Rate";
label var rintirf "Real Interest Rate";
label var cnsirf "Consumption - Nondurable + Services";
label var cdurirf "Consumption - Durables";
label var nriirf "Nonresidential Investment";
label var resirf "Residential Investment";
label var hrirf "Hours";
label var wirf "Real Wages";


tw (rarea gup glo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter girf girfb girfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 , 
   title("Government Purchases", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_g.gph,replace);
   
tw (rarea yup ylo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter yirf yirfb yirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("GDP", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_y.gph,replace);
   
 tw (rarea taxup taxlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter taxirf taxirfb taxirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Tax Rate", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_tax.gph,replace);
   
 tw (rarea rintup rintlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter rintirf rintirfb rintirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Real Interest Rate", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_rint.gph,replace);

 tw (rarea cnsup cnslo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter cnsirf cnsirfb cnsirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Nondurable + Services Consumption", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_cns.gph,replace);
  
 tw (rarea cdurup cdurlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter cdurirf cdurirfb cdurirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   ylab(, angle(horizontal)) 
   title("Durable Consumption", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_cdur.gph,replace);
  
 tw (rarea nriup nrilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter nriirf nriirfb nriirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Nonresidential Investment", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_nri.gph,replace);
  
 tw (rarea resup reslo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter resirf resirfb resirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Residential Investment", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_res.gph,replace);
 
 tw (rarea hrup hrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter hrirf hrirfb hrirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Hours", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_hr.gph,replace);
  
 tw (rarea wup wlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter wirf wirfb wirfm h, c(l l l) clp(l - .) ms(o i i) clc(blue red green) mc(blue red green) clw(medthick)) if h<=48 ,
   title("Real Wages", size(medsmall)) legend(off) xtitle("") scale(0.9) saving(`model'_w.gph,replace);
 


graph combine `model'_g.gph `model'_y.gph `model'_tax.gph `model'_rint.gph
  `model'_cns.gph `model'_cdur.gph `model'_nri.gph `model'_res.gph `model'_hr.gph `model'_w.gph,
 col(2) ysize(10) xsize(8) ;

 };


/*
*********************************************;
* FIGURE 3.2:  ROMER-ROMER OVER TWO SAMPLES;
*********************************************;


import excel using Monetary_irfs.xlsx, firstrow sheet("RR8307");
   
     foreach var in lipirf lcpiirf  { ;
     gen `var'b = 100*`var';
  };
   gen crrirfb = crrirf;
   gen unempirfb = unempirf;
  
  sort horiz;
  
  keep horiz crrirfb lipirfb lcpiirfb unempirfb ;
  save junk.dta, replace;

foreach model in RRorig {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
     foreach var in lip lcpi { ;
     replace `var'irf = 100*`var'irf;
	 replace `var'lo = 100*`var'lo;
	 replace `var'up = 100*`var'up;
};


merge 1:1 horiz using junk.dta;

label var crrirf "Target Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


tw (rarea crrup crrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter crrirf crrirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("Target Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_crr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lcpiirf lcpiirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter unempirf unempirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
   
graph combine `model'_crr.gph `model'_lip.gph `model'_unemp.gph `model'_lcpi.gph, ysize(4) xsize(7) iscale(1.2);

};

*/
/*
*********************************************;
* FIGURE 3.3:  ROMER-ROMER ORIGINAL SAMPLE, JORDA, WITH AND WITHOUT RECURSIVENESS;
*********************************************;


import excel using Monetary_irfs.xlsx, firstrow sheet("RRorig_Jorda_norec");
   
  foreach var in lipirf lcpiirf liplo lipup lcpilo lcpiup { ;
     gen `var'b = 100*`var';
  };
  foreach var in ffrirf ffrlo ffrup unempirf unemplo unempup {;
	   gen `var'b = `var';
  };
  
  sort horiz;
  
  keep horiz ffrirfb ffrlob ffrupb lipirfb liplob lipupb 
    unempirfb unemplob unempupb lcpiirfb lcpilob lcpiupb ;

  save junk.dta, replace;

foreach model in RRorig_Jorda {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
    foreach var in lip lcpi { ;
     replace `var'irf = 100*`var'irf;
	 replace `var'lo = 100*`var'lo;
	 replace `var'up = 100*`var'up;
    };


merge 1:1 horiz using junk.dta;

label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


foreach var in ffr lip unemp lcpi {;
  gen `var'prod = `var'lob*`var'upb;
  gen `var'irfbsig = `var'irfb if `var'prod>0; /*means both ci bands same sign*/
};



tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf ffrirfb h, c(l l) clp(l -) ms(i i o) clc(black blue) mc(black blue blue) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb h, c(l l) clp(l -) ms(i i o) clc(black blue) mc(black blue blue) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter unempirf unempirfb h, c(l l) clp(l -) ms(i i o) clc(black blue) mc(black blue blue) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
   
tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lcpiirf lcpiirfb h, c(l l) clp(l -) ms(i i o) clc(black blue) mc(black blue blue) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
   
graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph `model'_lcpi.gph, ysize(4) xsize(7) iscale(1.2);


};
*/
