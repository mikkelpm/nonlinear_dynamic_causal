function VAR = doProxySVAR(VAR,DATASET)
 
 X      = lagmatrix(VAR.vars,1:VAR.p);
 X      = X(VAR.p+1:end,:);
 Y      = VAR.vars(VAR.p+1:end,:);
 VAR.k  = size(VAR.proxies,2);
 VAR.m = VAR.proxies(VAR.p+1:end,:);
 [VAR.T,VAR.n] = size(Y);

% Run VAR
%%%%%%%%%%%%
VAR.bet=[X ones(length(X),1)]\Y; 
VAR.res = Y-[X ones(length(X),1)]*VAR.bet;
VAR.bet=[X ones(length(VAR.m),1)]\Y; 
VAR.res = Y-[X ones(length(X),1)]*VAR.bet;

VAR.Sigma = (VAR.res'*VAR.res)/(VAR.T-VAR.n*VAR.p-1);
      
% Identification (See also appendix in the paper)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
b22b22p = Sig22+b21ib11*(b12b12p-Sig11)*b21ib11';
b12ib22   = ((Sig21- b21ib11*Sig11)'+b12b12p*b21ib11')/(b22b22p');
b11iSig = eye(VAR.k)/(eye(VAR.k)-b12ib22*b21ib11);
b21iSig = b21ib11*b11iSig;

SigmaTSigmaTp =b11iSig\b11b11p/b11iSig';

% Reliability
Sigmm   = VAR.m'*VAR.m/VAR.T;
ED      = eye(VAR.k)*sum(sum(VAR.m,2)~=0)/VAR.T;
mu1     = VAR.m'*VAR.res(:,1:VAR.k)/VAR.T;
PhiPhip = mu1*inv(b11b11p)*mu1';
VAR.RM  = inv(Sigmm)*PhiPhip*inv(ED);
VAR.RMeigs = sort(eig(VAR.RM));

% Impulse Responses
%%%%%%%%%%%%%%%%%%%%%%
for i=1:VAR.k   
    
 if VAR.ord(1)==1;
 s1 = sqrt(SigmaTSigmaTp(1,1));
 a  = SigmaTSigmaTp(2,1)/s1;
 s2 = sqrt(SigmaTSigmaTp(2,2)-a^2);
 SigmaT = [s1 0 ; a s2];
 elseif VAR.ord(1)==2;
 s2 = sqrt(SigmaTSigmaTp(2,2));
 b  = SigmaTSigmaTp(1,2)/s2;
 s1 = sqrt(SigmaTSigmaTp(1,1)-b^2);
 SigmaT = [s1 b; 0 s2];
 end
 
 VAR.b1(:,:,i) = [b11iSig;b21iSig]*SigmaT;

 irs = [];
 irs(VAR.p+1,:) = -VAR.b1(:,i,i)/VAR.b1(i,i,i);
 for tt=2:VAR.irhor
 lvars = (irs(VAR.p+tt-1:-1:tt,:))';
 irs(VAR.p+tt,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:);     
 end

         VAR.irs(1:VAR.irhor,1:VAR.n,i) = irs(VAR.p+1:end,:); 
    
         % Variable Transformations:
            if sum(cell2mat(values(DATASET.MAP,VAR.select_vars))'==8)>0
                or.taxb_PI =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==8),1);
                or.taxr_PI =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==6),1);
             VAR.irs(:,cell2mat(values(VAR.MAP,{'PITREV'})),i)=[VAR.irs(:,or.taxr_PI,i)/0.1667+VAR.irs(:,or.taxb_PI,i)] ;    
            end

            if sum(cell2mat(values(DATASET.MAP,VAR.select_vars))'==9)>0
                or.taxb_CI =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==9),1);
                or.taxr_CI =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==7),1);
             VAR.irs(:,cell2mat(values(VAR.MAP,{'CITREV'})),i)=[VAR.irs(:,or.taxr_CI,i)/0.2996+VAR.irs(:,or.taxb_CI,i)] ;    
            end

            if sum(cell2mat(values(DATASET.MAP,VAR.select_vars))'==14)>0
                or.plevel =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==14),1);
             VAR.irs(:,cell2mat(values(VAR.MAP,{'INFL'})),i)=4*(VAR.irs(:,or.plevel,i)-[0;VAR.irs(1:end-1,or.plevel,i)]) ;    
            end

            if sum(cell2mat(values(DATASET.MAP,VAR.select_vars))'==16)>0
                or.EMP =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==16),1);
                or.LF  =  find((cell2mat(values(DATASET.MAP,VAR.select_vars))'==18),1);
             VAR.irs(:,cell2mat(values(VAR.MAP,{'UNR'})),i)=(1- 0.9475)*(exp(- 0.9475/(1- 0.9475)*(VAR.irs(:,or.EMP,i)-VAR.irs(:,or.LF,i))/100)-1)*100 ;    
            end
        
end



