function VAR = doProxySVAR_single(VAR,DATASET)

 X      = lagmatrix(VAR.vars,1:VAR.p);
 X      = X(VAR.p+1:end,:);
 Y      = VAR.vars(VAR.p+1:end,:);
 VAR.k  = 1;
 VAR.m  = VAR.proxies(VAR.p+1:end,:);
 [VAR.T,VAR.n] = size(Y);

% Run VAR
%%%%%%%%%%%%
% VAR.bet=[X ones(length(X),1)]\Y; 
VAR.bet=[X VAR.DET(VAR.p+1:end,:)]\Y; % **
VAR.res = Y-[X VAR.DET(VAR.p+1:end,:)]*VAR.bet;
%VAR.bet=[X VAR.DET(VAR.p+1:end,:)]\Y; 
%VAR.res = Y-[X VAR.DET(VAR.p+1:end,:)]*VAR.bet;
VAR.Sigma = (VAR.res'*VAR.res)/(VAR.T-VAR.n*VAR.p-1);
      
% Identification
%%%%%%%%%%%%%%%%%
Phib = [ones(length(VAR.m),1) VAR.m]\VAR.res;
Phib = Phib(2:end,:);
Phib11  = Phib(1:VAR.k,1:VAR.k);
Phib21  = Phib(1:VAR.k,VAR.k+1:VAR.n);
b21ib11 = (Phib11\Phib21)';
Sig11   = VAR.Sigma(1:VAR.k,1:VAR.k);
Sig21   = VAR.Sigma(VAR.k+1:VAR.n,1:VAR.k);
Sig22   = VAR.Sigma(VAR.k+1:VAR.n,VAR.k+1:VAR.n);
ZZp     = b21ib11*Sig11*b21ib11'-(Sig21*b21ib11'+b21ib11*Sig21')+Sig22;
b12b12p = (Sig21- b21ib11*Sig11)'*(ZZp\(Sig21- b21ib11*Sig11));
b11b11p = Sig11-b12b12p;
b11 = sqrt(b11b11p);
VAR.b1 = [b11; b21ib11*b11];

%Reliability
%  Sigmm = VAR.m'*VAR.m/VAR.T;
ED    = eye(VAR.k)*sum(sum(VAR.m,2)~=0)/VAR.T;
mu1   = VAR.m'*VAR.res(:,1:VAR.k)/VAR.T;
 % PhiPhip = mu1*inv(b11b11p)*mu1';
 % VAR.RM    = inv(Sigmm)*PhiPhip*inv(ED)
Bi = [1/b11+(Sig21-Sig11*b21ib11)'*inv(ZZp)/b11*b21ib11 -(Sig21-Sig11*b21ib11)'*inv(ZZp)/b11];
VAR.et = (Bi*VAR.res')';

PHI = mu1/b11;
GAM = inv(ED)*PHI;
E  = GAM*VAR.et(sum(VAR.m,2)~=0);
V  = VAR.m(sum(VAR.m,2)~=0)-E;
VAR.RM = inv(E'*E+V'*V)*E'*E;


% Impulse Responses
%%%%%%%%%%%%%%%%%%%%
irs(VAR.p+1,:) = VAR.b1(:,1)/VAR.b1(1,1);
 for jj=2:VAR.irhor
 lvars = (irs(VAR.p+jj-1:-1:jj,:))';
 irs(VAR.p+jj,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:);     
 end
VAR.irs = irs(VAR.p+1:end,:); 



