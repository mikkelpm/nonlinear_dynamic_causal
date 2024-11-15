# Causal weights for macroeconomic shocks

Replication code and data for "Dynamic Causal Effects in a Nonlinear World: the Good, the Bad, and the Ugly" by [Michal Kolesár](https://github.com/kolesarm) and [Mikkel Plagborg-Møller](https://github.com/mikkelpm)

## Replication instructions
1. Execute [save_shocks.do](save_shocks.do) in Stata
2. Execute [compute_weights.do](compute_weights.do) in Stata
3. Execute [plot_weights.do](plot_weights.do) in Stata
4. The generated figures will be stored in a folder called "fig"

Tested in Stata SE 17.0 on a Windows 11 PC

## Acknowledgements

We rely on the [replication files](https://econweb.ucsd.edu/~vramey/research.html) for [Valerie Ramey's (2016) handbook chapter](https://doi.org/10.1016/bs.hesmac.2016.03.003). These files are stored in the folder [data](data). They have not been modified in any way, except that files whose name ends in "_edit" have had parts commented out to avoid running unnecessary commands.

Kolesár acknowledges support by the National Science Foundation under Grant [SES-2049356](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2049356). Plagborg-Møller acknowledges support from the National Science Foundation under Grant [SES-2238049](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2238049) and from the Alfred P. Sloan Foundation.