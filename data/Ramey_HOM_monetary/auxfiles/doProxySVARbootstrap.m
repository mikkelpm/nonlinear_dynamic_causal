function VARbs = doProxySVARbootstrap(VAR,nboot,clevel,DATASET)

% Wild Bootstrap
  jj=1; % jj indexes bootstrap draw
  
  res = detrend(VAR.res,'constant');
     while jj<nboot+1
       rr = (1-2*(rand(VAR.T,1)>0.5));
       resb = (res.*(rr*ones(1,VAR.n)))';
       
       varsb = zeros(VAR.p+VAR.T,VAR.n);
       varsb(1:VAR.p,:)=VAR.vars(1:VAR.p,:);
       
        for tt=VAR.p+1:VAR.p+VAR.T
        lvars = (varsb(tt-1:-1:tt-VAR.p,:))';
        varsb(tt,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:)+VAR.bet(VAR.p*VAR.n+1:end,:)+resb(:,tt-VAR.p)';     
        end
              
        VARBS = VAR;
        VARBS.vars = varsb;        
        VARBS.proxies = [VAR.proxies(1:VAR.p,:); VAR.m.*(rr*ones(1,VAR.k))];
        VARBS = doProxySVAR(VARBS,DATASET);
        
        for i=1:VAR.k % i indexes Tax Type    
        irs = VARBS.irs(:,:,i);
        IRS(:,jj,i) = irs(:);
        end
        EIGS(jj,:) = VARBS.RMeigs';
      jj=jj+1;   
     end
     
 for jj = 1:length(clevel)
 for i=1:VAR.k % i indexes Tax Type    
 VARbs.irsH(:,:,i,jj)=reshape(quantile(IRS(:,:,i)',(1-clevel(jj)/100)/2),VAR.irhor, size(VARBS.irs,2));
 VARbs.irsL(:,:,i,jj)=reshape(quantile(IRS(:,:,i)',1-(1-clevel(jj)/100)/2),VAR.irhor, size(VARBS.irs,2));
 end
 end
 
 VARbs.RMeigci   = [quantile(EIGS,(1-clevel/100)/2)' quantile(EIGS,1-(1-clevel/100)/2)'];
  




