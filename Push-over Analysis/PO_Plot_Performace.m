%%
clear all
fclose('all');

% input filename
inputf      = 'drain.inp';

% change directory
cd OUTPUT

% create result filename
File        = dir('*.OUT');
for i=1:length(File)
    Filename{i} = File(i).name;
end

cd ..
%% Load data
load Minfo.mat
load gendis.mat
load elemB.mat
load elemBRA.mat
load elemC.mat
load EC8Sp.mat
load DemandSP.mat
load SelectedSim.mat
load nSectionInfo.mat
load SecProp.mat

cd ..
cd Spectrum
load SectCap.mat
cd .., cd Pushover

%% Plot EC8 Design Spectrum

f = figure;
hold on
x0=1;
y0=1;
width=23;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])

plot(EC8Tp,EC8Sa,'linew',2)

grid

xlabel('Tp (s)'), ylabel('Sa (g)')
title('EC8 - Elastic Spectrum')
legend('Soil Type A, Damping 5%')

exportgraphics(f,'EC8 Elastic Spectrum.png','Resolution',1200)
close all



%% System pushover curve

stp     = gendis{1}(:,2);
appV    = sum(POload); % kN
stpV    = stp.*appV; % kN
phi1top = -1;

for j=1:length(File) 
    roofGD{j}      = abs(gendis{j}(:,3)); % m
    EFFM1(j)       = MEFFMM{j}(1)*tmass; % kg
    PPF1(j)        = MPPF{j}(1);
    CSa{j}         = ((stpV*10^3)./EFFM1(j))/9.81; % (N/kg)/g  to (%g)
    CSd{j}         = roofGD{j}./(PPF1(j)*phi1top);
end

%%

for j=1:length(File)
    figure
    hold on
    grid on
    plot(CSd{j},CSa{j})
    plot(EC8Sd,EC8Sa)
    % plot(Pd{j},Pa{j})
    set(gca,'Xlim',[0 0.2])
    xlabel('Sd (m)'), ylabel('Sa (g)')
    title('Capacity Spectrum')
    
    % Bilinear Conversion
    
    % Create line & plot line for first yielding (T0)
    finess     = 1000;
    yfy        = linspace(CSa{j}(1),max(get(gca,'Ylim')),finess);
    mfy        = abs((CSa{j}(2)-CSa{j}(1))/(CSd{j}(2)-CSd{j}(1)));
    xfy        = ( (yfy-CSa{j}(1))./mfy )+CSd{j}(1);
    [~,FYidx]  = min( abs( xfy - max(get(gca,'Xlim' ))) );
    xfy        = xfy(1:FYidx);
    yfy        = yfy(1:FYidx);
    T0         = (2*pi)/sqrt(mfy);
    hold on
    plot(xfy,yfy,'--k')
    
    %
    scl = 1;
    for k=1:9999
        % Initial Point
        Sdif          = 0.066;
        Sdi{j}(k)     = scl*Sdif;
        % Find the nearest point
        [~,idSa]      = min(abs(CSd{j}-Sdi{j}(k)));
        Sai{j}(k)     = CSa{j}(idSa);
        plot(CSd{j}(idSa),Sai{j}(k),'ro')
        % yield point
        [~,idT0]      = min(abs(yfy-Sai{j}(k)));
        Sdyi{j}(k)    = xfy(idT0);
        % Sdyi{j}(k)    = 0.0476;
        plot(Sdyi{j}(k),Sai{j}(k),'bo')
        
        % Plot Bilinear Capcity Curve
        finess         = 1000;
        BCy{j}         = linspace(CSa{j}(1),Sai{j}(k),finess);
        BCm{j}         = abs((CSa{j}(2)-CSa{j}(1))/(CSd{j}(2)-CSd{j}(1)));
        BCx{j}         = ( (BCy{j} -CSa{j}(1))./BCm{j}  )+CSd{j}(1);
        BCxnew{j}      = linspace(BCx{j}(end),max(get(gca,'Xlim')),finess);
        BCynew{j}      = repmat(BCy{j}(end),1,finess);
        for i=1:finess-1
            BCx{j}(finess+i) = BCxnew{j}(1+i);
            BCy{j}(finess+i) = BCynew{j}(1+i);
        end
        plot(BCx{j},BCy{j},'k')
        
        % equivalent viscous damping(Deq) Calculation
        u{j}(k)      = Sdi{j}(k)/Sdyi{j}(k);
        Deq{j}(k)    = (2/pi)*( (u{j}(k)-1)/u{j}(k) );
        if Deq{j}(k)<0.16,SBk = 1;end
        if Deq{j}(k)>= 0.16 &&  Deq{j}(k)< 0.45,SBk = min(( ( (1-0.77)/(0.16-0.45) )*(Deq{j}(k)-0.16) )+1,0.77);end
        if Deq{j}(k)>=0.45,SBk = 0.77;end
        modDeq{j} = min(0.05+(SBk*Deq{j}(k)),0.5);
        
        % Deq Demand Spectrum
        
        Deqn{j}=sqrt(10/(5+(modDeq{j}*100)));
        
        T=0;
        for i=1:ns
            if T<=Tb
                DeqSa{j}(i)=ag*S*(1 + ( (T/Tb)*((Deqn{j}*2.5)-1) ) );
            end
            if (T<=Tc)&(T>Tb)
                DeqSa{j}(i)=ag*S*Deqn{j}*2.5;
                ymx=DeqSa{j}(i)+0.1;
            end
            if (T<=Td)&(T>Tc)
                DeqSa{j}(i)=ag*S*Deqn{j}*2.5*(Tc/T);
                if DeqSa{j}(i)<=beta*ag
                    DeqSa{j}(i)=beta*ag;
                end
            end
            if T>Td
                DeqSa{j}(i)=ag*S*Deqn{j}*2.5*(Tc*Td/T^2);
                if DeqSa{j}(i)<=beta*ag
                    DeqSa{j}(i)=beta*ag;
                end
            end
            DeqTp{j}(i)=T; T=T+dT;
        end
        
        DeqSd{j} = (DeqSa{j}*9.81)./(2*pi./DeqTp{j}).^2;
        plot(DeqSd{j},DeqSa{j})
        
        % Find Intersection Point
        
        idSdj          = InterX([DeqSd{j}; DeqSa{j}],[CSd{j}'; CSa{j}']);
        Sdj{j}(k)      = idSdj(1);
        Saj{j}(k)      = idSdj(2);
        plot(Sdj{j}(k),Saj{j}(k),'ko')
        err{j}(k)      = 100*(Sdj{j}(k)-Sdi{j}(k))/Sdj{j}(k); % Error in Percent(%)
        
        if abs(err{j}(k)) <= 0.1,break,end % Error less than 0.1%
        if err{j}(k) < -0.1,scl = scl*0.95;end
        if err{j}(k) >  0.1,scl = scl*1.05;end
    end
end

%%

x0=1;
y0=1;
width=23;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
exportgraphics(gcf,'Performance Beam Exp.png','Resolution',1200)
close all

%% Inelastic Spectrum

for j=1:length(u)
    
        for i=1:length(EC8Sa)
            
            if EC8Tp(i) == 0
                RF{j}(i) = 1;
            end
            
            if EC8Tp(i) > 0 && EC8Tp(i)<= Tb
                RF{j}(i) = ( ( u{j}(end) - 1 )*( EC8Tp(i)/Tb ) ) + 1 ;
            end
            
            if EC8Tp(i) > Tb
                RF{j}(i) = u{j}(end) ;
            end
        end 
        
        RdsSa{j}  = EC8Sa./RF{j};
end



%% Find Performance Point

for j=1:length(File)

f(j) = figure;
hold on
grid on
x0=1;
y0=1;
width=23;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(EC8Sd,EC8Sa)
plot(EC8Sd,RdsSa{j},'linew',2)

% Plot Final Bilinear Capcity Curve
finess         = 1000;
BCy{j}         = linspace(CSa{j}(1),Sai{j}(end),finess);
BCm{j}         = abs((CSa{j}(2)-CSa{j}(1))/(CSd{j}(2)-CSd{j}(1)));
BCx{j}         = ( (BCy{j} -CSa{j}(1))./BCm{j}  )+CSd{j}(1);
BCxnew{j}      = linspace(BCx{j}(end),max(get(gca,'Xlim')),finess);
BCynew{j}      = repmat(BCy{j}(end),1,finess);
for i=1:finess-1
    BCx{j}(finess+i) = BCxnew{j}(1+i);
    BCy{j}(finess+i) = BCynew{j}(1+i);
end

EPFP{j}   = InterX([EC8Sd; EC8Sa],[BCx{j}; BCy{j}]);
InEPFP{j} = InterX([EC8Sd; RdsSa{j}],[BCx{j}; BCy{j}]);



plot(BCx{j},BCy{j},'k')

plot(EPFP{j}(1),EPFP{j}(2),'ko','MarkerFaceColor','b','MarkerSize',6,'linew',1)
text(EPFP{j}(1),EPFP{j}(2),'PP,Elastic','HorizontalAlignment','Right')

plot(InEPFP{j}(1),InEPFP{j}(2),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1)
text(InEPFP{j}(1),InEPFP{j}(2),'PP,Inelastic')


legend('EC8 - Elastic Spectrum','EC8 - Inelastic Spectrum','Capacity Spectrum'...
      ,'Performance Point (E)','Performance Point (InE)')


set(gca,'Xlim',[0 0.2])
xlabel('Sd (m)'), ylabel('Sa (g)')
title(['Structure Performance - Simulation No.' Filename{j}(1:end-4) ', Ductility Capacity = ' num2str(round(u{j}(end),2))])


end


% exportgraphics(f(1),'Structure PerformanceB06D16.png','Resolution',1200)
% exportgraphics(f(2),'Structure PerformanceB07D01.png','Resolution',1200)
% exportgraphics(f(3),'Structure PerformanceB07D07.png','Resolution',1200)
% close all

%% Beam Blackbone Curve


for j=1:length(File)

% Nomalized Beam Data

BDeM{j}     = abs(elemB{j}{1}{1}(:,5));
BDeV{j}     = elemB{j}{1}{1}(:,6);


BFyM(j)     = yB(Bid(j));
BRoM(j)     = max(abs(BDeM{j}));

BNmlC{j}    = abs(BDeM{j}./BFyM(j));
BGRoC{j}    = abs(gendis{j}(:,4));

condi       = BGRoC{j}>0.0003;
BGRoC{j}    = BGRoC{j}(condi);
BNmlC{j}    = BNmlC{j}(condi);

BYCode{j}   = elemB{j}{1}{1}(:,4);
BYCode{j}   = BYCode{j}(condi);
Yidx        = find(BYCode{j}==1);

% Section Properties
hB(j)       = str2double(UB{:,5}(rUB+Bid(j))); % mm
bfB(j)      = str2double(UB{:,6}(rUB+Bid(j))); % mm
twB(j)      = str2double(UB{:,7}(rUB+Bid(j))); % mm
tfB(j)      = str2double(UB{:,8}(rUB+Bid(j))); % mm

 

% FEMA 356, Table 5-6, P 5-40
conA = bfB(j)/(2*tfB(j)) <= 52/sqrt(Fy) && hB(j)/twB(j) >= 640/sqrt(Fy);
YieldRot(j) = (str2double(UB{:,24}(rUB+Bid(j)))*10^3*Fy*12*10^3)/(6*str2double(UB{:,18}(rUB+Bid(j)))*10^4*210*10^3);

if conA == true
    IO(j) = 1*YieldRot(j);
    LS(j) = 6*YieldRot(j);
    CP(j) = 8*YieldRot(j);
end
if conA == false
    IO(j) = 0.25*YieldRot(j);
    LS(j) = 2*YieldRot(j);
    CP(j) = 3*YieldRot(j);
end

f = figure(1);
subplot(310+j);
hold on
x0=1;
y0=1;
width=25;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(BGRoC{j},BNmlC{j})
% set(gca,'Ylim',[0 1.1])
set(gca,'Xlim',[0 0.05])
set(gca,'Ylim',get(gca,'Ylim'))
hold on
% plot([0 GRoC{j}(Yidx(1)) GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+b],[0 1 1 c c],'linew',2)

plot([IO(j) IO(j)],get(gca,'Ylim'),'--g')
text(IO(j),0.95*max(get(gca,'Ylim')),'IO')

plot([LS(j) LS(j)],get(gca,'Ylim'),'--m')
text(LS(j),0.95*max(get(gca,'Ylim')),'LS')

plot([CP(j) CP(j)],get(gca,'Ylim'),'--r')
text(CP(j),0.95*max(get(gca,'Ylim')),'CP')

plot(BGRoC{j}(Yidx(1)),BNmlC{j}(Yidx(1)),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1)

xlabel('Rotation (rad)'), ylabel('Normalized Moment')
title(['Critical Beam Performance - Simulation No.' Filename{j}(1:end-4)])
grid
legend off
if j==1, legend('Element Response','Immediate Occupancy','Life Safety','Collapse Prevention','Performance Point'),end;

end

% exportgraphics(f,'Critical Beam Performance.png','Resolution',1200)
% close all

%% Diagonal Blackbone Curve

for j=1:length(File)

    
% Nomalized Diagonal Data

DeN{j}     = abs(elemBRA{j}{1}{1}(:,5));
DeD{j}     = elemBRA{j}{1}{1}(:,6);


FyN(j)     = yBR(Did(j));

BNmlC{j}    = abs(DeN{j}./FyN(j));

% condi      = GRoC{j}>0.0003;
% GRoC{j}    = GRoC{j}(condi);
% NmlC{j}    = NmlC{j}(condi);

BYCode{j}   = elemBRA{j}{1}{1}(:,4);
% YCode{j}   = YCode{j}(condi);
Yidx       = find(BYCode{j}==1);


% FEMA 356, Table 5-7, P 5-44

    IO(j) = 0.25*DeD{j}(Yidx(1));
    LS(j) = 11*DeD{j}(Yidx(1));
    CP(j) = 13*DeD{j}(Yidx(1));

f = figure(1); 
subplot(310+j);
hold on
x0=1;
y0=1;
width=25;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(DeD{j},BNmlC{j})
% set(gca,'Ylim',[0 1.1])
set(gca,'Xlim',[0 1.5*CP(j)])
set(gca,'Ylim',get(gca,'Ylim'))
hold on
% plot([0 GRoC{j}(Yidx(1)) GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+b],[0 1 1 c c],'linew',2)

plot([IO(j) IO(j)],get(gca,'Ylim'),'--g')
text(IO(j),0.95*max(get(gca,'Ylim')),'IO')

plot([LS(j) LS(j)],get(gca,'Ylim'),'--m')
text(LS(j),0.95*max(get(gca,'Ylim')),'LS')

plot([CP(j) CP(j)],get(gca,'Ylim'),'--r')
text(CP(j),0.95*max(get(gca,'Ylim')),'CP')

plot(DeD{j}(Yidx(1)),BNmlC{j}(Yidx(1)),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1)

xlabel('Displacement (m)'), ylabel('Normalized Axial (kN)')
title(['Critical Diagonal Performance - Simulation No.' Filename{j}(1:end-4)])
legend off
if j==1,legend('Element Response','Immediate Occupancy','Life Safety','Collapse Prevention','Performance Point'),end;
grid
end

exportgraphics(figure(1),'Critical Diagonal Performance.png','Resolution',1200)
close all

%% Column Blackbone Curve
% 
% for j=1:length(File)
% 
% % Nomalized Beam Data
% 
% CDeM{j}     = abs(elemC{j}{1}{1}(:,5));
% CDeN{j}     = elemC{j}{1}{1}(:,7);
% CYCode{j}   = elemC{j}{1}{1}(:,4);
% CPRot{j}    = elemC{j}{1}{1}(:,8);
% 
% Yidx        = find(CYCode{j}==1);
% 
% CFyM(j)     = CDeM{j}(Yidx(1));
% CNmlC{j}    = abs(CDeM{j}./CFyM(j));
% 
% 
% 
% % FEMA 356, Table 5-6, P 5-40
% 
%     IO(j) = 0.25*CPRot{j}(Yidx(1));
%     LS(j) = 0.5*CPRot{j}(Yidx(1));
%     CP(j) = 0.8*CPRot{j}(Yidx(1));
% 
% 
% 
% figure
% plot( CPRot{j}(Yidx(1)),CNmlC{j}(Yidx(1)),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1)
% % set(gca,'Ylim',[0 1.1])
% set(gca,'Xlim',[0 1.5*CP(j)])
% set(gca,'Ylim',get(gca,'Ylim'))
% hold on
% % plot([0 GRoC{j}(Yidx(1)) GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+a GRoC{j}(Yidx(1))+b],[0 1 1 c c],'linew',2)
% 
% plot([IO(j) IO(j)],get(gca,'Ylim'),'--g')
% text(IO(j),0.95*max(get(gca,'Ylim')),'IO')
% 
% plot([LS(j) LS(j)],get(gca,'Ylim'),'--m')
% text(LS(j),0.95*max(get(gca,'Ylim')),'LS')
% 
% plot([CP(j) CP(j)],get(gca,'Ylim'),'--r')
% text(CP(j),0.95*max(get(gca,'Ylim')),'CP')
% 
% % plot(GRoC{j}(Yidx(1)),CNmlC{j}(Yidx(1)),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1)
% 
% xlabel('Rotational (rad)'), ylabel('Normalized Moment')
% title(['Critical Beam Performance - Simulation No.' Filename{j}(1:end-4)])
% legend('Performance Point','Immediate Occupancy','Life Safety','Collapse Prevention')
% grid
% end
% 



