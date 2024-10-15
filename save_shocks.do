#delimit;
clear all;
set more off;

/*
SAVE IDENTIFIED SHOCKS FROM RAMEY (2016) HANDBOOK CHAPTER

MPM 2024-10-08
*/;


* Government spending shocks;

cd data/Ramey_HOM_govtspending;
do jordagov_edit;

local p = 2;
local sample postwwii;

foreach v of varlist newsy mfev top3xsret bpshock {;
	reg `v' L(1/`p').`v' L(1/`p').y L(1/`p').g L(1/`p').tax t t2 if `sample'==1; // Follows lines 172 & 187 in "jordagov.do"
	predict `v'_res, resid;
};
keep qdate *_res;
rename *_res *;
rename newsy gov_ramey;
label var gov_ramey "Ramey (2011) military spending shock, following Ramey (2016) handbook chapter";
rename mfev gov_benzeevpappa;
label var gov_benzeevpappa "Ben Zeev & Pappa (2017) defense spending shock, following Ramey (2016) handbook chapter";
rename top3xsret gov_fisherpeters;
label var gov_fisherpeters "Fisher & Peters (2010) government spending shock, following Ramey (2016) handbook chapter";
rename bpshock gov_blanchardperotti;
label var gov_blanchardperotti "Blanchard & Perotti (2002) government spending shock, following Ramey (2016) handbook chapter";
cd ../..;
save shock_q, replace;


* Tax shocks: unanticipated;

cd data/Ramey_HOM_tax;
do jordatax_edit;

local p=4;

foreach v of varlist exogenrratio rrtaxu_dm rrtaxu {;
	reg `v' L(1/`p').`v' L(1/`p').ly L(1/`p').lg L(1/`p').ltax t t2 dum75q2; // Follows line 111 in "jordatax.do" (note: Ramey does not control for lags of the shock itself)
	predict `v'_res, resid;
};
keep qdate *_res;
rename *_res *;
rename exogenrratio tax_romer;
label var tax_romer "Romer & Romer (2010) tax shock, following Ramey (2016) handbook chapter";
rename rrtaxu tax_mertensravn;
label var tax_mertensravn "Mertens & Ravn (2011) tax shock, following Ramey (2016) handbook chapter";
rename rrtaxu_dm tax_mertensravn_dm;
label var tax_mertensravn_dm "Mertens & Ravn (2011) tax shock with original de-meaning, following Ramey (2016) handbook chapter";
cd ../..;
merge 1:1 qdate using shock_q, nogen;
save shock_q, replace;


* Tax shocks: anticipated;

cd data/Ramey_HOM_tax;
do jordataxnews_edit;

local v aftr15;
reg `v' L(1/`p').`v' L(1/`p').taxy L(1/`p').ly t t2; // Follows line 100 in "jordataxnews.do" when the outcome variable is "ly"
predict `v'_res, resid;
keep qdate *_res;
rename aftr15_res taxnews_lrw;
label var taxnews_lrw "Leeper, Richter & Walker (2012) tax news shock, following Ramey (2016) handbook chapter";
cd ../..;
merge 1:1 qdate using shock_q, nogen;
save shock_q, replace;


* Technology shocks;

cd data/Ramey_HOM_technology;
do jordatech_edit;

local p = 2;

foreach v of varlist ford_tfp jf_tfp jpt_tfp jpt_mei {;
	reg `v' L(1/`p').`v' L(1/`p').lrgdp L(1/`p').lrstockp L(1/`p').lxtot t t2; // Follows line 185 in "jordatech.do" when the outcome variable is "lrgdp"
	predict `v'_res, resid;
};
keep qdate *_res;
rename *_res *;
rename ford_tfp tfp_ford;
label var tfp_ford "Francis, Owyang, Roush & DiCecio (2014) TFP shock, following Ramey (2016) handbook chapter";
rename jf_tfp tfp_fernald;
label var tfp_fernald "Fernald (2014) utilization-adjusted TFP shock, following Ramey (2016) handbook chapter";
rename jpt_tfp tfp_jpt;
label var tfp_jpt "Justiniano, Primiceri & Tambalotti (2011) TFP shock, following Ramey (2016) handbook chapter";
rename jpt_mei ist_jpt;
label var ist_jpt "Justiniano, Primiceri & Tambalotti (2011) IST shock, following Ramey (2016) handbook chapter";
cd ../..;
merge 1:1 qdate using shock_q, nogen;
save shock_q, replace;


* Monetary shocks: Christiano-Eichenbaum-Evans;

cd data/Ramey_HOM_monetary;
do var_cee_edit;

local p = 12;
local shock ffr;

reg `shock' L(1/`p').`shock' L(0/`p').lip L(0/`p').unemp L(0/`p').lcpi L(0/`p').lpcom L(1/`p').lnbr L(1/`p').ltr L(1/`p').lm1 if mdate>=m(1965m1) & mdate<=m(1995m6); // Follows lines 53-58 in "var_cee.do"
predict `shock'_res, resid;
keep mdate *_res;
rename ffr_res mon_cee;
label var mon_cee "Christiano, Eichenbaum & Evans (1999) monetary shock, following Ramey (2016) handbook chapter";
cd ../..;
save shock_m, replace;


* Monetary shocks: Romer-Romer;

cd data/Ramey_HOM_monetary;
do var_romer_edit;

local p = 12;
local shock cumrrshockorig;

reg `shock' L(1/`p').`shock' L(0/`p').lip L(0/`p').unemp L(0/`p').lcpi L(0/`p').lpcom if mdate>=m(1969m1) & mdate<=m(1996m12);  // Follows lines 62-67 in "var_romer.do"
predict `shock'_res, resid;
keep mdate *_res;
rename `shock'_res mon_romer;
label var mon_romer "Romer & Romer (2004) monetary shock, following Ramey (2016) handbook chapter";
cd ../..;
merge 1:1 mdate using shock_m, nogen;
save shock_m, replace;


* Monetary shocks: Gertler-Karadi;

cd data/Ramey_HOM_monetary;
do jorda_gk_edit;

local p = 2;
local shock ff4_tc;

reg `shock' L(1/`p').`shock' L(1/`p').lip L(1/`p').gs1 L(1/`p').lcpi L(1/`p').ebp if mdate>=m(1990m1) & mdate<=m(2012m6); // Follows line 77 in "jorda_gk.do"
predict `shock'_res, resid;
keep mdate *_res;
rename `shock'_res mon_gertlerkaradi;
label var mon_gertlerkaradi "Gertler & Karadi (2015) monetary shock, following Ramey (2016) handbook chapter";
cd ../..;
merge 1:1 mdate using shock_m, nogen;
save shock_m, replace;


* Clean up;

foreach f in q m {;
	use shock_`f', clear;
	tsset `f'date;
	compress;
	label data "Macroeconomic shocks from Ramey (2016) handbook chapter";
	save shock_`f', replace;
};

