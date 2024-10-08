**** GRAPHIRF.DO

***
*** Graphs impulse responses

***
*** Requires:
***     Monetary_irfs.xlsx 

***************************************************************************************************

#delimit;

drop _all;
clear all;

set more 1;

capture log close;


/*
*********************************************;
* FIGURE 1:  CEE OVER TWO SAMPLES AND TWO SPECIFICATIONS;
*********************************************;


import excel using Monetary_irfs.xlsx, firstrow sheet("CEE8307");
   
     foreach var in lipirf lcpiirf lpcomirf lnbrirf ltrirf lm1irf { ;
     gen `var'b = 100*`var';
  };
   gen ffrirfb = ffrirf;
   gen unempirfb = unempirf;
  
  sort horiz;
  
  keep horiz ffrirfb lipirfb lcpiirfb lcpiirfb unempirfb lpcomirfb lnbrirfb ltrirfb lm1irfb;
  save junkb.dta, replace;
  
  drop _all;
  clear all;
  
  import excel using Monetary_irfs.xlsx, firstrow sheet("CEE8307nomon");
   
     foreach var in lipirf lcpiirf lpcomirf  { ;
     gen `var'c = 100*`var';
  };
   gen ffrirfc = ffrirf;
   gen unempirfc = unempirf;
  
  sort horiz;
  
  keep horiz ffrirfc lipirfc lcpiirfc lcpiirfc unempirfc lpcomirfc ;
  save junkc.dta, replace;

foreach model in CEEorig {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
     foreach var in lip lcpi lpcom lnbr ltr lm1 { ;
     replace `var'irf = 100*`var'irf;
	 replace `var'lo = 100*`var'lo;
	 replace `var'up = 100*`var'up;
};


merge 1:1 horiz using junkb.dta;
sort horiz;
drop _merge;
merge 1:1 horiz using junkc.dta;

label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf ffrirfb ffrirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb lipirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lcpiirf lcpiirfb lcpiirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter unempirf unempirfb unempirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
   
 tw (rarea lpcomup lpcomlo h, bcolor(gs14) clw(medthin medthin))
 (scatter lpcomirf lpcomirfb lpcomirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
 title("Commodity Prices", size(medsmall)) legend(off) xtitle("") saving(`model'_lpcom.gph,replace);
 
 tw (rarea lnbrup lnbrlo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lnbrirf lnbrirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
 title("Nonborrowed Reserves", size(medsmall)) legend(off) xtitle("") saving(`model'_lnbr.gph,replace);
 
 tw (rarea ltrup ltrlo h, bcolor(gs14) clw(medthin medthin))
 (scatter ltrirf ltrirfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
 title("Total Reserves", size(medsmall)) legend(off) xtitle("") saving(`model'_ltr.gph,replace);
 
 tw (rarea lm1up lm1lo h, bcolor(gs14) clw(medthin medthin))
 (scatter lm1irf lm1irfb h, c(l l) clp(l -) ms(i i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
 title("M1", size(medsmall)) legend(off) xtitle("") saving(`model'_lm1.gph,replace);
 
 

graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph `model'_lcpi.gph, ysize(4) xsize(7) iscale(1.1);

* graph combine `model'_lpcom.gph `model'_lnbr.gph `model'_ltr.gph `model'_lm1.gph, ysize(4) xsize(7) iscale(1.1);
};
*/

/*

*********************************************;
* FIGURE 2A:  ROMER-ROMER OVER TWO SAMPLES;
*********************************************;


import excel using Monetary_irfs.xlsx, firstrow sheet("RR8307");
   
  foreach var in lipirf lcpiirf  { ;
     gen `var'b = 100*`var';
  };
   gen crrirfb = crrirf;
   gen unempirfb = unempirf;
  
  sort horiz;
  
  keep horiz crrirfb lipirfb lcpiirfb unempirfb ;
  save junkb.dta, replace;
  
  drop _all;
  clear all;
  
 import excel using Monetary_irfs.xlsx, firstrow sheet("RRfull");
   
     foreach var in lipirf lcpiirf  { ;
     gen `var'c = 100*`var';
  };
   gen crrirfc = crrirf;
   gen unempirfc = unempirf;
  
  sort horiz;
  
  keep horiz crrirfc lipirfc lcpiirfc lcpiirfc unempirfc  ;
  save junkc.dta, replace;


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
sort horiz;
drop _merge;
merge 1:1 horiz using junkc.dta;

label var crrirf "Target Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


tw (rarea crrup crrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter crrirf crrirfb crrirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Target Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_crr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb lipirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lcpiirf lcpiirfb lcpiirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter unempirf unempirfb unempirfc h, c(l l l) clp(l - _) ms(i i p) clc(black blue red) mc(black blue red) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
   
graph combine `model'_crr.gph `model'_lip.gph `model'_unemp.gph `model'_lcpi.gph, ysize(4) xsize(7) iscale(1.2);

};
*/


*********************************************;
* FIGURE 2B:  ROMER-ROMER, JORDA, WITH AND WITHOUT RECURSIVENESS;
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

  save junkb.dta, replace;
  
  drop _all;
  clear all;
  
  import excel using Monetary_irfs.xlsx, firstrow sheet("RRorig_Jorda_Factors_norec");
   
     foreach var in lipirf lcpiirf   { ;
     gen `var'c = 100*`var';
  };
   gen ffrirfc = ffrirf;
   gen unempirfc = unempirf;
  
  sort horiz;
  
  keep horiz ffrirfc lipirfc lcpiirfc lcpiirfc unempirfc ;
  save junkc.dta, replace;

foreach model in RRorig_Jorda {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
    foreach var in lip lcpi { ;
     replace `var'irf = 100*`var'irf;
	 replace `var'lo = 100*`var'lo;
	 replace `var'up = 100*`var'up;
    };


merge 1:1 horiz using junkb.dta;
sort horiz;
drop _merge;
merge 1:1 horiz using junkc.dta;

label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";


foreach var in ffr lip unemp lcpi {;
  gen `var'prod = `var'lob*`var'upb;
  gen `var'irfbsig = `var'irfb if `var'prod>0; /*means both ci bands same sign*/
};



tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf ffrirfb ffrirfc h, c(l l l) clp(l - _) ms(i i p) clc(black green purple) mc(black green purple) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb lipirfc h, c(l l l) clp(l - _) ms(i i p) clc(black green purple) mc(black green purple) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter unempirf unempirfb unempirfc h, c(l l l) clp(l - _) ms(i i p) clc(black green purple) mc(black green purple) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);
   
tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
 (scatter lcpiirf lcpiirfb lcpiirfc h, c(l l l) clp(l - _) ms(i i p) clc(black green purple) mc(black green purple) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
   
graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph `model'_lcpi.gph, ysize(4) xsize(7) iscale(1.2);


};
*/
/*
***********************************************************;
* ROMER PSVAR;
***********************************************************;
import excel using Monetary_irfs.xlsx, firstrow sheet("RRfull_psvar");
   
  foreach var in lipirf lcpiirf liplo lipup lcpilo lcpiup { ;
     gen `var'b = 100*`var';
  };
  
  foreach var in ffrirf ffrlo ffrup unempirf unemplo unempup {;
	   gen `var'b = `var';
  };
  
  sort horiz;
  
  keep horiz ffrirfb ffrlob ffrupb lipirfb liplob lipupb 
    unempirfb unemplob unempupb lcpiirfb lcpilob lcpiupb ;

  save junkb.dta, replace;

foreach model in RRorig_psvar {;

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
     foreach var in lipirf liplo lipup lcpiirf lcpilo lcpiup { ;
    replace `var' = 100*`var';
  };

  merge 1:1 horiz using junkb.dta;

label var ffrirf "Federal Funds Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var unempirf "Unemployment Rate";



tw (rarea ffrup ffrlo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ffrirf ffrirfb h, c(l l) clp(l _) ms(i i) clc(black red) mc(black red) clw(medthick)) if h<=48 ,
   title("Federal Funds Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_ffr.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf lipirfb h, c(l l) clp(l _) ms(i i) clc(black red) mc(black red) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lcpiirf lcpiirfb h, c(l l) clp(l _) ms(i i) clc(black red) mc(black red) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea unempup unemplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter unempirf unempirfb h, c(l l) clp(l _) ms(i i) clc(black red) mc(black red) clw(medthick)) if h<=48 ,
   title("Unemployment", size(medsmall)) legend(off) xtitle("") saving(`model'_unemp.gph,replace);

 


foreach var in lcpi {; 

tw (rarea `var'up `var'lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter `var'irf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title(" `var' ") legend(off) saving(`model'.gph,replace);
  
};


 
 graph combine `model'_ffr.gph `model'_lip.gph `model'_unemp.gph
   `model'_lcpi.gph, iscale(1) saving(`model'combine.gph, replace) ysize(4) xsize(7);

    };


*/

/*
***********************************************************;
* GK JORDA;
***********************************************************;

import excel using Monetary_irfs.xlsx, firstrow sheet("GKgreen_Jorda");
   
     gen fac = 0.2567/4.255;  /* rescale to match proxy svar results */
	 
  foreach var in lipirf lcpiirf liplo lipup lcpilo lcpiup { ;
     gen `var'b = 100*fac*`var';
  };
  
  foreach var in gs1irf gs1lo gs1up ebpirf ebplo ebpup {;
	   gen `var'b = `var';
  };
  
  sort horiz;
  
  keep horiz gs1irfb gs1lob gs1upb lipirfb liplob lipupb 
    ebpirfb ebplob ebpupb lcpiirfb lcpilob lcpiupb ;

  save junkb.dta, replace;


foreach model in GKorig_Jorda {; /* GKorig_Jorda_norec BC_Jorda_norec*/

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
   gen fac`model' = 0.2567/4.255;  /* rescale to match proxy svar results */
     foreach var in lipirf liplo lipup lcpiirf lcpilo lcpiup { ;
    replace `var' = 100*fac`model'*`var';
  };

foreach var in gs1irf gs1lo gs1up ebpirf ebplo ebpup {;
  replace `var' = fac`model'*`var';
};

 merge 1:1 horiz using junkb.dta;
 gen h = horiz;

label var gs1irf "One-Year Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var ebpirf "Excess Bond Premium";



tw (rarea gs1up gs1lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter gs1irf  h, c(l l) clp(l -) ms(i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("One-Year Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_gs1.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf  h, c(l l) clp(l -) ms(i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lcpiirf  h, c(l l) clp(l -) ms(i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea ebpup ebplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ebpirf  h, c(l l) clp(l -) ms(i ) clc(black blue) mc(black blue) clw(medthick)) if h<=48 ,
   title("Excess Bond Premium", size(medsmall)) legend(off) xtitle("") saving(`model'_ebp.gph,replace);

 

 
 graph combine `model'_gs1.gph `model'_lip.gph `model'_ebp.gph
   `model'_lcpi.gph, iscale(1) saving(`model'combine.gph, replace) ysize(4) xsize(7);

    };

/*
***********************************************************;
* BC JORDA;
***********************************************************;

foreach model in BC_Jorda_norec {; 

   drop _all;
   clear all;
   import excel using Monetary_irfs.xlsx, firstrow sheet("`model'");
   
*   gen fac`model' = 0.2567/3.488;  /* rescale to match proxy svar results */
     foreach var in lipirf liplo lipup lcpiirf lcpilo lcpiup { ;
*    replace `var' = 100*fac`model'*`var';
  };

foreach var in gs1irf gs1lo gs1up ebpirf ebplo ebpup {;
  replace `var' = fac`model'*`var';
};

label var gs1irf "One-Year Rate";
label var lipirf "Industrial Production";
label var lcpiirf "CPI";
label var ebpirf "Excess Bond Premium";



tw (rarea gs1up gs1lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter gs1irf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("One-Year Rate", size(medsmall)) legend(off) xtitle("") saving(`model'_gs1.gph,replace);
   
 tw (rarea lipup liplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lipirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Industrial Production", size(medsmall)) legend(off) xtitle("") saving(`model'_lip.gph,replace);
   
 tw (rarea lcpiup lcpilo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter lcpiirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("CPI", size(medsmall)) legend(off) xtitle("") saving(`model'_lcpi.gph,replace);
   
 tw (rarea ebpup ebplo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter ebpirf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title("Excess Bond Premium", size(medsmall)) legend(off) xtitle("") saving(`model'_ebp.gph,replace);

 


foreach var in lcpi {; 

tw (rarea `var'up `var'lo h, bcolor(gs14) clw(medthin medthin)) 
  (scatter `var'irf h, c(l ) clp(l ) ms(i ) clc(black) mc(black) clw(medthick)) if h<=48 ,
   title(" `var' ") legend(off) saving(`model'.gph,replace);
  
};


 
 graph combine `model'_gs1.gph `model'_lip.gph `model'_ebp.gph
   `model'_lcpi.gph, iscale(1) saving(`model'combine.gph, replace) ysize(4) xsize(7);

    };


