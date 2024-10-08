#delimit;
clear all;
set more off;

/*
PLOT IMPLIED SHOCK WEIGHT FUNCTION

Please run "save_shocks.do" before this file

MPM 2024-10-08
*/;


* Settings;

local plot_q "bpshock newsy mfev top3xsret rrtaxu_dm exogenrratio aftr15 ford_tfp jf_tfp jpt_tfp"; // Quarterly shocks to plot;
local plot_m "*"; // Monthly shocks to plot;
local cv = 1.96; // Critical value for SE band;


* Compute and plot weights;

cap mkdir fig;

foreach f in q m {; // For quarterly and monthly shocks...;

	use shock_`f', clear;
	
	foreach v of varlist `plot_`f'' {;
	
		if "`v'" == "`f'date" {;
			continue;
		};
	
		* Compute weight function via regression;
		qui: levelsof `v';
		local levels "`r(levels)'"; // Values of shock in sample;
		
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
		
		* Plot weights with SE band;
		preserve;
		use `fil', clear;
		gen upper = b+`cv'*se;
		gen lower = b-`cv'*se;
		
		su upper;
		local maxy = `r(max)'; // Determine placement of textbox in plot;
		su x;
		local minx = `r(min)';
		
		line b upper lower x, connect(stairstep ..) lcolor(black ..) lwidth(thick vthin vthin)
			xline(0, lcolor(black) lwidth(vthin) lpattern(shortdash))
			text(`maxy' `minx' "Weight>0 = `weight_pos' (`weight_pos_se')", box bcolor(black) fcolor(white) margin(vsmall) placement(se))
			xtitle("") legend(off) graphregion(color(white));
		graph export fig/`v'.png, replace;
		restore;
	
	};

};
