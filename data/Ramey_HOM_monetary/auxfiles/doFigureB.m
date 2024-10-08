function f = doFigureB(VAR1,VAR1bs,VAR2,VAR2bs,FIG,plotdisplay,DATASET,shock);

display1= cell2mat(values(VAR1.MAP,plotdisplay));
display2= cell2mat(values(VAR2.MAP,plotdisplay));
for nvar = 1:length(display1)
                  
        f=figure;    
        box on
            
            if shock==2
            plot(VAR1.irs(:,display1(nvar),shock),'LineWidth',2,'Color', [0 0 0.5]);
            hold on
            plot(VAR1bs.irsH(:,display1(nvar),shock,1),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','--');
            hold on
            plot(VAR1bs.irsL(:,display1(nvar),shock,1),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','--');
            hold on
            plot(VAR1bs.irsH(:,display1(nvar),shock,2),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','-.');
            hold on
            plot(VAR1bs.irsL(:,display1(nvar),shock,2),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','-.');
            hold on
            elseif shock==1
            plot(VAR2.irs(:,display2(nvar),shock),'LineWidth',2,'Color', [0 0 0.5]);
            hold on
            plot(VAR2bs.irsH(:,display2(nvar),shock,1),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','--');
            hold on
            plot(VAR2bs.irsL(:,display2(nvar),shock,1),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','--');
            hold on
            plot(VAR2bs.irsH(:,display2(nvar),shock,2),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','-.');
            hold on
            plot(VAR2bs.irsL(:,display2(nvar),shock,2),'LineWidth',1,'Color', [0 0 0.5],'LineStyle','-.');
            end
            axis([0 20 FIG.axes(1,cell2mat(values(VAR1.MAP,{plotdisplay{nvar}}))) FIG.axes(2,cell2mat(values(VAR1.MAP,{plotdisplay{nvar}})))]);
            hline(0,'k-')
            ti=title( DATASET.FIGLABELS{cell2mat(values(DATASET.MAP,{plotdisplay{nvar}}))});
            xl=xlabel('quarters');
 
            
            if DATASET.UNIT(cell2mat(values(DATASET.MAP,{plotdisplay{nvar}})))==1
            yl=ylabel('percent');
            else 
            yl=ylabel('percentage points'); 
            end
               
            set([xl,yl], 'FontName', 'AvantGarde','FontSize',14);
            set([ti], 'FontName', 'AvantGarde','FontSize',16);
       
       
   
end