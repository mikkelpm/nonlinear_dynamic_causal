clear all; close all;

DATASET.TSERIES=xlsread('Monetarydat.xlsx','Monthlydat6996');

DATASET.LABEL   = {'DATES','LIP','UNEMP','LCPI','FFR', 'LPCOM','LRCDUR','LRCND','LRCSV','RRORIG','CUMRRORIG'};
DATASET.VALUE   = [  1,       2,     3,     4,    5 ,    6 ,     7 ,     8  ,   9 ,    10,  11 ];
DATASET.UNIT    = [  0,       2,     2,     2,    2 ,    2,      2 ,     2  ,   2 ,    2,   2  ];

%DATASET.LABEL   = {'DATES','LIP','UNEMP','LCPI','FFR', 'LPCOM','LRCDUR','LRCND','LRCSV','FF4_TC','CUMFF4_TC'};
%DATASET.VALUE   = [  1,       2,     3,     4,    5 ,    6 ,     7 ,     8  ,   9 ,    10,  11 ];
%DATASET.UNIT    = [  0,       2,     2,     2,    2 ,    2,      2 ,     2  ,   2 ,    2,   2  ];

%DATASET.LABEL   = {'DATES','LOGCPI','LOGIP','FF','GS1', 'EBP','FF4_TC'};
%DATASET.VALUE   = [  1,       2,     3,     4,    5 ,    6 ,     7  ];
%DATASET.UNIT    = [  0,       2,     2,     2,    2 ,    2,      2  ];

DATASET.MAP = containers.Map(DATASET.LABEL,DATASET.VALUE);

DATASET.FIGLABELS{1,1}  = 'Month';                                   
DATASET.FIGLABELS{2,1}  = 'Industrial Production';                                   
DATASET.FIGLABELS{3,1}  = 'Unemployment Rate';  
DATASET.FIGLABELS{4,1}  = 'CPI';  
DATASET.FIGLABELS{5,1} = 'Fed Funds Rate';  
DATASET.FIGLABELS{6,1} = 'Commodity Prices';                             
DATASET.FIGLABELS{7,1} = 'Durable Consumption';               
DATASET.FIGLABELS{8,1} = 'Nondurable Consumption';               
DATASET.FIGLABELS{9,1} = 'Services Consumption';               
DATASET.FIGLABELS{10,1} = 'Romer-Romer Shock';               
DATASET.FIGLABELS{11,1} = 'Cumulative RR Shock'; 
              
save('DATASET','DATASET');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
