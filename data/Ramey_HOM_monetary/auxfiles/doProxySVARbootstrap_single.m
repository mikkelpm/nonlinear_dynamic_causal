function VARbs = doProxySVARbootstrap_single(VAR,nboot,clevel,DATASET)

% Wild Bootstrap
  jj=1;
    res = detrend(VAR.res,'constant');
     while jj<nboot+1
       rr = 1-2*(rand(VAR.T,1)>0.5);
       
       resb = (res.*(rr*ones(1,VAR.n)))';
       
       varsb = zeros(VAR.p+VAR.T,VAR.n);
       varsb(1:VAR.p,:)=VAR.vars(1:VAR.p,:);
        for j=VAR.p+1:VAR.p+VAR.T
        lvars = (varsb(j-1:-1:j-VAR.p,:))';
  %       varsb(j,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:)+VAR.bet(VAR.p*VAR.n+1:end,:)+resb(:,j-VAR.p)';
        varsb(j,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:)+ VAR.DET(j,:)*VAR.bet(VAR.p*VAR.n+1:end,:)+resb(:,j-VAR.p)'; %**    
        end
              
        VARBS = VAR;
        VARBS.vars = varsb;        
        VARBS.proxies = [VAR.proxies(1:VAR.p,:); VAR.m.*(rr*ones(1,VAR.k))];
        VARBS = doProxySVAR_single(VARBS,DATASET);
        
        for j=1:VAR.k;
        irs = VARBS.irs(:,:,j);
        VARbs.irs(:,jj,j) = irs(:);
        end
        bsRM(:,jj) = VARBS.RM ;
                 
      jj=jj+1;   

     end  
    
 for j=1:VAR.k  
 VARbs.irsH(:,:,j)=reshape(quantile(VARbs.irs(:,:,j)',(1-clevel/100)/2),VAR.irhor,size(VARBS.irs,2));
 VARbs.irsL(:,:,j)=reshape(quantile(VARbs.irs(:,:,j)',1-(1-clevel/100)/2),VAR.irhor,size(VARBS.irs,2));
 end
   
VARbs.RMci=[quantile(bsRM',(1-clevel/100)/2), quantile(bsRM',1-(1-clevel/100)/2)];



