clear all; close all; addpath('auxfiles');

%%%% Run Import_Data.m first for specification to create the DATASET: either "Monthlydat6996"
%%%%     or "Monthlydat6907" 
%%%% Change the shock variable in the VAR1.proxies statement for each
%%%% specification - RRORIG for Monthlydat6996 and RR for Monthlydat6907

load DATASET;

nboot  = 1000;  % Number of Bootstrap Samples 
clevel = [90];  % Bootstrap Percentile Shown

% VAR specification
%%%%%%%%%%%%%%%%%%%%
 VAR1.p      = 12;                                 % Number of Lags
 VAR1.irhor  = 60;                                % Impulse Response Horizon
 VAR1.select_vars      = {'FFR','LIP','UNEMP','LCPI','LPCOM'};
 VAR1.vars             = DATASET.TSERIES(:,cell2mat(values(DATASET.MAP,VAR1.select_vars)));
 VAR1.MAP              = containers.Map([VAR1.select_vars],[1:size(VAR1.vars,2)]);
 VAR1.proxies          = DATASET.TSERIES(:,cell2mat(values(DATASET.MAP,{'RRORIG'})));
 [T,n]  = size(VAR1.vars);
%  VAR1.DET             = [ones(T,1) (1:T)' ((1:T).^2)']; % deterministic terms
 VAR1.DET             = [ones(T,1)];
 
 % Estimation
 %%%%%%%%%%%%%
 
 VAR1      = doProxySVAR_single(VAR1,DATASET);

 VAR1bs    = doProxySVARbootstrap_single(VAR1,nboot,clevel,DATASET);



