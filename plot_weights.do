#delimit;
clear all;
set more off;

/*
PLOT IMPLIED SHOCK WEIGHT FUNCTION

Please run "compute_weights.do" before this file

MPM 2024-11-11
*/;


* Plot weight functions grouped by type of shock;

use weights;

foreach gr in gov tax tfp mon {;
	preserve;
	egen nonmiss = rownonmiss(`gr'*_b);
	drop if nonmiss == 0;
	line `gr'*_b x, connect(stairstep ..) lwidth(thick ..)
				lcolor(ebblue black cranberry gs6) lpattern(solid shortdash dash longdash)
				xline(0, lcolor(black) lwidth(vthin) lpattern(shortdash))
				legend(symxsize(*0.5) position(6) ring(1) cols(2))
				xtitle("") graphregion(color(white)) xsize(8) ysize(5);
			graph export fig/`gr'.png, replace;
			graph export fig/`gr'.eps, replace;
	restore;
};
