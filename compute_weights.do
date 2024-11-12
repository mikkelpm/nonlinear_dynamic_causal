#delimit;
clear all;
set more off;

/*
COMPUTE IMPLIED SHOCK WEIGHT FUNCTION

Please run "save_shocks.do" before this file

MPM 2024-11-11
*/;


* Compute weights;

cap mkdir fig;
cap erase "weights.dta";

foreach f in q m {; // For quarterly and monthly shocks...;

	use shock_`f', clear;
	
	foreach v of varlist * {;
	
		if "`v'" == "`f'date" {;
			continue;
		};
		
		su `v';
		replace `v' = `v'/`r(sd)'; // Change units to standard deviations;
	
		* Compute weight function via regression;
		levelsof `v', local(levels); // Values of shock in sample;
		su `v';
		local levels "`levels' `=`r(min)'-0.01' `=`r(max)'+.01'"; // Add values slightly smaller and larger than support, so weights drop to 0;
		
		tempfile fil;
		postfile handle x b se using `fil', replace;
		foreach l of local levels {; // For each x value...;
			gen ind = (`v'>=`l'); // Indicator;
			reg ind `v', robust; // Regression to compute weight;
			post handle (`l') (_b[`v']) (_se[`v']); // Store coefficient and SE;
			drop ind;
		};
		postclose handle;
		
		* Compute total weight on positive shocks;
		gen max0 = max(`v',0) if !missing(`v');
		reg max0 `v', robust;
		local weight_pos : display %4.3f _b[`v'];
		local weight_pos_se : display %4.3f _se[`v'];
		drop max0;
		local label: variable label `v';
		
		* Store results for later plotting;
		preserve;
		use `fil', clear;
		rename (b se) `v'_=;
		label var `v'_b "`label' ({&omega}>0: `weight_pos')"; // Variable label with weight;
		cap merge 1:1 x using weights, nogen;
		save weights, replace;
		restore;
	
	};

};

use weights, clear;
compress;
save weights, replace;

