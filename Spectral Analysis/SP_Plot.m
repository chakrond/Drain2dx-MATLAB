load MaxMbeam.mat
load MSRSSBaseV.mat
load NbraSRSS.mat
load ExtrSecProp.mat
load nSectionInfo.mat
load SecProp.mat
load MaxFCol.mat
load genDisp.mat

%% Input**
floorH  = 4;     % m 
lenb    = 12;    % beam length (m)
lenbr   = 12.65; % brace length (m)


%% Legend Generation
for i=1:16
    LegD{i} = ['D' num2str(i,'%02d')];
end
for i=1:10
    LegB{i} = ['B' num2str(i,'%02d')];
end

save('Legend.mat','LegD','LegB')

%% Yield Calculation
Fy      = 325; % Mpa
yB      = Fy*10^-1.*Wpb*10^-2; % kN-m
yBR     = Fy*10^-1.*Abr; % kN
GRAV    = 800; % Constant Gravity Load (kN-m)

save('SectCap.mat','Fy','yB','yBR','GRAV')

% Utility Calculation
for k=1:10
    i=0;
    for j=(k*nPFC)-(nPFC-1):k*nPFC
        i            = i+1;
        UtliB{k}(i)  = (abs(MaxMbeam{j}(3))+GRAV)./abs(yB(k));
    end
    
    i=0;
    for j=(k*nPFC)-(nPFC-1):k*nPFC
        i               = i+1;
        UtilBR{k}{i}    = NbraSRSS{j}(:,3)./yBR(i); 
    end
    
end

% Brace Efficiency Calculation

for k=1:10
   
    i=0;
    for j=(k*nPFC)-(nPFC-1):k*nPFC
        i               = i+1;
        EffBR{k}{i}     = NbraSRSS{j}(:,3)./MSRSSBaseV(j); 
    end
end

%% Plot Utility Beam VS Brace

h3 = figure;

marker  = [{'o'} {'s'} {'v'} {'d'} {'h'}...
           {'>'} {'d'} {'^'} {'x'} {'<'}];

% length   = 16;
% color1   = [1 0 0];
% color2   = [0 1 0];       
% colors_p = [linspace(color1(1),color2(1),length)',...
%             linspace(color1(2),color2(2),length)',...
%             linspace(color1(3),color2(3),length)']; 
%      
        
        
% marker  = [{'o'} {'+'} {'*'} {'.'} {'x'}...
%            {'s'} {'d'} {'^'} {'h'} {'v'}];

% color   = [{'#FF0000'} {'#00FF00'} {'#0000FF'} {'#00FFFF'}...
%            {'#FF00FF'} {'#FFFF00'} {'#000000'} {'#00FFFF'}...
%            {'#0072BD'} {'#D95319'} {'#EDB120'} {'#7E2F8E'}...
%            {'#77AC30'} {'#4DBEEE'} {'#A2142F'} {'#7E2F8E'}];


mksize = linspace(20,1,16);
i=0;
q=0;
for k=1:10

%     for j=1:nPFC
%         hold on
%         plot(UtilBR{k}{j}(2),UtliB{k}(j),marker{k},'MarkerEdgeColor',color{j})
%     end
    x1lab{k}    = ['B' num2str(k,'%02d')  ];

    for j=1:nPFC
        q = q+1;
        x1(k,j) = UtilBR{k}{j}(2);
        y1(k,j) = UtliB{k}(j);
        
        xq1(q)  = UtilBR{k}{j}(2);
        yq1(q)  = UtliB{k}(j);
        
        y1lab{j}    = ['D' num2str(j,'%02d')  ];
        
        
        hold on
        pp(q) = plot(UtilBR{k}{j}(2),UtliB{k}(j),'Marker',marker{k},...
        'MarkerSize',mksize(j),'Color','k');
        
        if UtliB{k}(j)<=1 && UtilBR{k}{j}(2)<= 1
           i = i+1;
           EffUtilB(i) = UtliB{k}(j);
        end
  
        
    end
      
    % legend name
%     if length(char(UB{rUB+k,1}))>1
%         g = k;
%     end
%     legdname{k} = [ char(UB{rUB+g,1}) ' ' char(UB{rUB+k,2}) ];
    
end

% cb = colorbar;
% cb.Label.String = 'Diagonal Section';
% colorbar('Ticks',[-5,-2,1,4,7],...
%          'TickLabels',{'Cold','Cool','Neutral','Warm','Hot'})
% colormap(colors_p)

% set(gca,'Ylim',[0 2])
% set(gca,'Xlim',[0 1])
plot(get(gca,'Xlim'),[1 1],'--r');
xlabel('Diagonal Utility'), ylabel('Beam Utility')
title('Critical Component of Beam and Diagonal Utility')
grid
% legend([pp(1),pp(1*16+1),pp(2*16+1),pp(3*16+1),pp(4*16+1),pp(5*16+1),pp(6*16+1),pp(7*16+1),pp(8*16+1),pp(9*16+1)],...
%        LegB{1},LegB{2},LegB{3},LegB{4},LegB{5},LegB{6},LegB{7},LegB{8},LegB{9},LegB{10})

% exportgraphics(h3,'Critical Component Utility.png','Resolution',1200)  

%% Heatmap


% plot beam utility heatmap
figure
h1 = heatmap(y1lab,x1lab,round(y1,2));
h1.Title = 'Beam Utility Heatmap';
h1.XLabel = 'Diagonal Section No.';
h1.YLabel = 'Beam Section No.';
exportgraphics(h1,'beam utility heatmap.png','Resolution',1200)

% plot brace utility heatmap
figure
h2 = heatmap(y1lab,x1lab,round(x1,2));
h2.Title = 'Diagonal Utility Heatmap';
h2.XLabel = 'Diagonal Section No.';
h2.YLabel = 'Beam Section No.';
exportgraphics(h2,'Diagonal utility heatmap.png','Resolution',1200)



%% Find effective model index
BEffModel = sort(EffUtilB,'descend');

i=0;
for k=1:10
    for j=1:nPFC
        if UtliB{k}(j) <= 1.02 && UtliB{k}(j) >= BEffModel(5) && UtilBR{k}{j}(2)<= 1
            i      = i+1;
            Mid(i,1) = k;
            Mid(i,2) = j;
            Mid(i,3) = UtliB{k}(j);
            Mid(i,4) = UtilBR{k}{j}(2);
        end
    end
end

Mid = sortrows(Mid,3,'descend');
save ('EffModSim.mat','Mid')        



%% Plot Brace Efficiency and Floor


marker  = [{'--ko'} {'--ks'} {'--kd'} {'--k^'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--go'} {'--gs'} {'--gd'} {'--g^'} ];

for k=[1 10] %:10
    figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1 && UtilBR{k}{j}(2)<= 1
            x2{k}{j} = EffBR{k}{j};
            hold on
            plot(x2{k}{j},1:size(NbraSRSS{1},1),marker{j})
 
%         end
    end 
    
    title(['Diagonal Efficiency - Simulation No.' LegB{k} 'DXX'])
    set(gca,'YTick',[1 2 3 4 5 6])
    set(gca,'Xlim',[0 1])
    xlabel('Efficiency - Axial in Diagonal (Nd) / Total Base Shear (V)'), ylabel('Floor')
    legend(LegD)
    grid
    
end

exportgraphics(figure(1),'Diagonal EfficiencyB1.png','Resolution',1200)
exportgraphics(figure(10),'Diagonal EfficiencyB10.png','Resolution',1200)


%% Plot Brace Average Efficiency for each beam

marker  = [{'--ko'} {'--ks'} ...
           {'--bo'} {'--bs'} ...
           {'--ro'} {'--rs'} ...
           {'--go'} {'--gs'} ...
           {'--mo'} {'--ms'} ];

f = figure;
f.WindowState = 'maximized';
       
       
i=0;
for k=1:10
    
    hold on
    x3(:,k) = mean([EffBR{k}{:}],2);
    plot(x3(:,k),1:size(NbraSRSS{1},1),marker{k},'MarkerFaceColor','auto')
    
    
end

% mx3     = mean(x3,2);
% plot(mx3,1:size(NbraSRSS{1},1),'rs-')
% 
% upb3    = max(x3,[],2);
% plot(upb3,1:size(NbraSRSS{1},1),'gs--')
% 
% lowb3   = min(x3,[],2);
% plot(lowb3,1:size(NbraSRSS{1},1),'bs--')

title('Effect of Beam Size and Diagonal Efficiency')
legend(LegB)
set(gca,'YTick',[1 2 3 4 5 6])
set(gca,'Xlim',[0 1])
xlabel('Efficiency - Axial in Diagonal (Nd) / Total Base Shear (V)'), ylabel('Floor')
grid
exportgraphics(f,'Effect of Beam Size and Diagonal Efficiency.png','Resolution',1200)




%% Plot Brace Utility and Floor 


marker  = [{'--ko'} {'--ks'} {'--kd'} {'--k^'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--go'} {'--gs'} {'--gd'} {'--g^'} ];

for k=[1 10] %:10
  figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1 && UtilBR{k}{j}(2)<= 1
            x4{k}{j} = UtilBR{k}{j};
            hold on
            plot(x4{k}{j},1:size(NbraSRSS{1},1),marker{j})

%         end
    end 
    

    title(['Diagonal Utility - Simulation No.' LegB{k} 'DXX'])
    set(gca,'YTick',[1 2 3 4 5 6])
    set(gca,'Xlim',[0 1])
    xlabel('Diagonal Utility'), ylabel('Floor')
    legend(LegD)
    grid
    
end

legend(LegD)

exportgraphics(figure(1),'Diagonal UtilityB1.png','Resolution',1200)
exportgraphics(figure(10),'Diagonal UtilityB10.png','Resolution',1200)

%% Plot Brace Average Utility for each beam

marker  = [{'--ko'} {'--ks'} ...
           {'--bo'} {'--bs'} ...
           {'--ro'} {'--rs'} ...
           {'--go'} {'--gs'} ...
           {'--mo'} {'--ms'} ];

f = figure;       
       
i=0;
for k=1:10
    
    hold on
    x13(:,k) = mean([UtilBR{k}{:}],2);
    plot(x13(:,k),1:size(NbraSRSS{1},1),marker{k},'MarkerFaceColor','auto')
    
    
end

% mx3     = mean(x3,2);
% plot(mx3,1:size(NbraSRSS{1},1),'rs-')
% 
% upb3    = max(x3,[],2);
% plot(upb3,1:size(NbraSRSS{1},1),'gs--')
% 
% lowb3   = min(x3,[],2);
% plot(lowb3,1:size(NbraSRSS{1},1),'bs--')

title('Effect of Beam Size and Diagonal Utility')
legend(LegB)
set(gca,'YTick',[1 2 3 4 5 6])
set(gca,'Xlim',[0 1])
xlabel('Diagonal Utility'), ylabel('Floor')
grid

% set(gca, 'FontName', 'Arial')
% set(gca,'fontsize', 11);

set(gcf,'WindowState','maximized')
exportgraphics(f,'Effect of Beam Size and Diagonal Utility.png','Resolution',1200)

close all


%% Plot Beam depth vs Brace Area by Utility <= 1

% figure
% for k=1:10
% %   figure(k)
%     for j=1:nPFC
%         if round(UtliB{k}(j),1) == 0.1  && round(UtilBR{k}{j}(2),1) == 1
%                 x5(k,j) = Abr(j);
%                 y5(k,j) = hb(k);
%                 hold on
%                 plot(x5(k,j),y5(k,j),'k.','Markersize',12)
%                 xlabel('Brace Area (mm^2)'), ylabel('Beam Depth (mm)')
%         end
%     end 
% end


%% Plot Brace (A/L) VS Utility

i=0;
for k=1:10
%   figure(k)
    for j=1:16
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i = i+1;
                xi6(i)   = Abr(j)./(lenbr*100);
                yi6(i)   = UtilBR{k}{j}(2);
                x6(k,j)  = Abr(j)./(lenbr*100);
                y6(k,j)  = UtilBR{k}{j}(2);
%         end
    end 
end

f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi6,yi6,'.','Color',[0.5 0.5 0.5],'Displayname','Data')


mxy6 = [mean(x6,1)',mean(y6,1)'];
mxy6 = sortrows(mxy6,1);
plot(mxy6(:,1),mxy6(:,2),'r-','linew',2,'Displayname','Average')

upbxy6 = [max(x6,[],1)',max(y6,[],1)'];
upbxy6 = sortrows(upbxy6,1);
plot(upbxy6(:,1),upbxy6(:,2),'g--','Displayname','Upperbound')

lwbxy6 = [min(x6,[],1)',min(y6,[],1)'];
lwbxy6 = sortrows(lwbxy6,1);
plot(lwbxy6(:,1),lwbxy6(:,2),'b--','Displayname','Lowerbound')

xlabel('Diagonal [Area over Length - (Ad/Ld)] - (cm)'), ylabel('Utility')
title('Relationship of Diagonal (Ad/Ld) and Critical Diagonal Utility of All Simulations')
grid

exportgraphics(f,'Relationship of Diagonal Ad-Ld Utility.png','Resolution',1200)
close all

%% Plot Diagonal (A/L) VS Diagonal Efficiency

i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i=i+1;
                xi8(i)   = Abr(j)./(lenbr*100);
                yi8(i)   = EffBR{k}{j}(2);

                x8(k,j)  = Abr(j)./(lenbr*100);
                y8(k,j)  = EffBR{k}{j}(2);
%         end
    end 
end


f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi8,yi8,'.','Color',[0.5 0.5 0.5],'Displayname','Data')

mxy8 = [mean(x8,1)',mean(y8,1)'];
mxy8 = sortrows(mxy8,1);
plot(mxy8(:,1),mxy8(:,2),'r-','linew',2,'Displayname','Average')

upbxy8 = [max(x8,[],1)',max(y8,[],1)'];
upbxy8 = sortrows(upbxy8,1);
plot(upbxy8(:,1),upbxy8(:,2),'g--','Displayname','Upperbound')

lwbxy8 = [min(x8,[],1)',min(y8,[],1)'];
lwbxy8 = sortrows(lwbxy8,1);
plot(lwbxy8(:,1),lwbxy8(:,2),'b--','Displayname','Lowerbound')

grid
xlabel('Diagonal [Area over Length - (Ad/Ld)] - (cm)'), ylabel('Efficiency - Axial in Diagonal (Nd) / Total Base Shear (V)')
title('Relationship of Diagonal (Ad/Ld) and Critical Diagonal Efficiency of All Simulations')

exportgraphics(f,'Relationship of Diagonal Ad-Ld Efficiency.png','Resolution',1200)
close all

%% Diagonal Utility VS Efficiency


f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(mxy8(:,1),mxy8(:,2),'b-','linew',1,'Displayname','Efficiency')
plot(mxy6(:,1),mxy6(:,2),'r-','linew',1,'Displayname','Utility')

Blpoint = InterX([mxy6(:,1)'; mxy6(:,2)'],[mxy8(:,1)';  mxy8(:,2)']);
plot(Blpoint(1),Blpoint(2),'ro','linew',1,'Displayname','Balanced Point')


grid
xlabel('Diagonal [Area over Length - (Ad/Ld)] - (cm)'), ylabel('Utility - Efficiency')
title('Utility - Efficiency VS Diagonal (Ad/Ld) of All Simulations')

exportgraphics(f,'Relationship of Utility - Efficiency.png','Resolution',1200)
close all




%% Story Drift Ratio of 2nd floor VS (Ad/Ld)

i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i = i+1;
                xi11(i) = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH; 
                yi11(i) = Abr(j)./(lenbr*100);
                
                x11(k,j)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                y11(k,j)  = Abr(j)./(lenbr*100);
%         end
    end 
end


f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi11,yi11,'.','Color',[0.5 0.5 0.5],'Displayname','Data')


mxy11 = [mean(x11,1)',mean(y11,1)'];
mxy11 = sortrows(mxy11,1);
plot(mxy11(:,1),mxy11(:,2),'r-','linew',2,'Displayname','Average')

upbxy11 = [max(x11,[],1)',max(y11,[],1)'];
upbxy11 = sortrows(upbxy11,1);
plot(upbxy11(:,1),upbxy11(:,2),'g--','Displayname','Upperbound')

lwbxy11 = [min(x11,[],1)',min(y11,[],1)'];
lwbxy11 = sortrows(lwbxy11,1);
plot(lwbxy11(:,1),lwbxy11(:,2),'b--','Displayname','Lowerbound')

grid
title('Relationship of Diagonal (Ad/Ld) VS Critical Story Drif Ratio')
xlabel('Critical Story Drif Ratio (2nd Floor)'), ylabel('Diagonal [Area over Length - (Ad/Ld)] - (cm)')

exportgraphics(f,'Relationship of Diagonal Story Drif Ratio.png','Resolution',1200)
close all

%% Story Drift Ratio of 2nd floor VS Diagonal Efficiency


i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i = i+1;
                xi12(i)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                yi12(i)  = EffBR{k}{j}(2);                
                
                
                x12(k,j)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                y12(k,j)  = EffBR{k}{j}(2);
%         end
    end 
end

f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi12,yi12,'.','Color',[0.5 0.5 0.5],'Displayname','Data')


mxy12 = [mean(x12,1)',mean(y12,1)'];
mxy12 = sortrows(mxy12,1);
plot(mxy12(:,1),mxy12(:,2),'r-','linew',2,'Displayname','Average')

upbxy12 = [max(x12,[],1)',max(y12,[],1)'];
upbxy12 = sortrows(upbxy12,1);
plot(upbxy12(:,1),upbxy12(:,2),'g--','Displayname','Upperbound')

lwbxy12 = [min(x12,[],1)',min(y12,[],1)'];
lwbxy12 = sortrows(lwbxy12,1);
plot(lwbxy12(:,1),lwbxy12(:,2),'b--','Displayname','Lowerbound')

grid
xlabel('Critical Story Drif Ratio (2nd Floor)'), ylabel('Efficiency - Axial in Diagonal (Nd) / Total Base Shear (V)')
title('Relationship of Critical Diagonal Efficiency VS Critical Story Drif Ratio')

exportgraphics(f,'Relationship of Diagonal Efficiency Story Drif Ratio.png','Resolution',1200)
close all

%% Story Drift Ratio of 2nd floor VS Diagonal Utility


i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i = i+1;
                xi14(i)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                yi14(i)  = UtilBR{k}{j}(2);                
                
                
                x14(k,j)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                y14(k,j)  = UtilBR{k}{j}(2);
%         end
    end 
end

f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')


plot(xi14,yi14,'.','Color',[0.5 0.5 0.5],'Displayname','Data')


mxy14 = [mean(x14,1)',mean(y14,1)'];
mxy14 = sortrows(mxy14,1);
plot(mxy14(:,1),mxy14(:,2),'r-','linew',2,'Displayname','Average')

upbxy14 = [max(x14,[],1)',max(y14,[],1)'];
upbxy14 = sortrows(upbxy14,1);
plot(upbxy14(:,1),upbxy14(:,2),'g--','Displayname','Upperbound')

lwbxy14 = [min(x14,[],1)',min(y14,[],1)'];
lwbxy14 = sortrows(lwbxy14,1);
plot(lwbxy14(:,1),lwbxy14(:,2),'b--','Displayname','Lowerbound')

grid
xlabel('Critical Story Drif Ratio (2nd Floor)'), ylabel('Critical Diagonal Utility (2nd Floor)')
title('Relationship of Diagonal Utility VS Critical Story Drif Ratio')


% set(gcf,'WindowState','maximized')
exportgraphics(f,'Relationship of Diagonal Utility Story Drif Ratio.png','Resolution',1200)
close all

%% Diagonal Utility - Efficiency VS Critical Story Drif Ratio

f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(mxy12(:,1),mxy12(:,2),'b-','linew',1,'Displayname','Efficiency')
plot(mxy14(:,1),mxy14(:,2),'r-','linew',1,'Displayname','Utility')

Blpoint = InterX([mxy14(:,1)'; mxy14(:,2)'],[mxy12(:,1)';  mxy12(:,2)']);
plot(Blpoint(1),Blpoint(2),'ro','linew',1,'Displayname','Balanced Point')


legend
grid
xlabel('Critical Story Drif Ratio (2nd Floor)'), ylabel('Utility - Efficiency')
title('Utility - Efficiency VS Critical Story Drif Ratio (2nd Floor)')

exportgraphics(f,'Utility - Efficiency VS Critical Story Drif Ratio.png','Resolution',1200)
close all

%% Plot Beam (I/L) VS Utility

i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i=i+1;
                xi7(i) = Ib(k)./(lenb*100);
                yi7(i) = UtliB{k}(j);
                
                x7(k,j)  = Ib(k)./(lenb*100);
                y7(k,j)  = UtliB{k}(j);

%         end
    end 
end

for k=1:size(x7,1)
    
    if mean(x7(k,:)) ~= 0 || mean(y7(k,:)) ~= 0
    mxy7(k,1)   = mean( nonzeros(x7(k,:)) );
    mxy7(k,2)   = mean( nonzeros(y7(k,:)) );
    end
    
    if mean(x7(k,:)) ~= 0 || mean(y7(k,:)) ~= 0
    upbxy7(k,1) = max( nonzeros(x7(k,:)) );
    upbxy7(k,2) = max( nonzeros(y7(k,:)) );
    end
    
    if mean(x7(k,:)) ~= 0 || mean(y7(k,:)) ~= 0
    lwbxy7(k,1) = min( nonzeros(x7(k,:)) );
    lwbxy7(k,2) = min( nonzeros(y7(k,:)) );    
    end
    
end

f = figure;
hold on
x0=1;
y0=1;
width=20;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi7,yi7,'.','Color',[0.5 0.5 0.5],'Displayname','Data')


mxy7 = sortrows(mxy7,1);
plot(mxy7(:,1),mxy7(:,2),'r-','linew',2,'Displayname','Average')

upbxy7 = sortrows(upbxy7,1);
plot(upbxy7(:,1),upbxy7(:,2),'g--','Displayname','Upperbound')

lwbxy7 = sortrows(lwbxy7,1);
plot(lwbxy7(:,1),lwbxy7(:,2),'b--','Displayname','Lowerbound')


legend
grid
title('Relationship of Beam (Ib/Lb) and Utility of All Simulations')
xlabel('Beam [Second Moment of Area over Length - (Ib/Lb)] - (cm^3)'), ylabel('Utility')

exportgraphics(f,'Relationship of Beam Ib-Lb Utility.png','Resolution',1200)
close all

%% Plot (Ad/Ld) / (Ib/Lb) VS Diagonal Efficiency


i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i=i+1;
                xi9(i)  = (Abr(j)./(lenbr*100)) ./ (Ib(k)./(lenb*100));
                yi9(i)  = EffBR{k}{j}(2);
       

                x9(k,j)  = (Abr(j)./(lenbr*100)) ./ (Ib(k)./(lenb*100));
                y9(k,j)  = EffBR{k}{j}(2);
%         end
    end 
end

f = figure;
hold on
x0=1;
y0=1;
width=21;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi9,yi9,'.','Color',[0.5 0.5 0.5],'Displayname','Data')

mxy9 = [mean(x9,1)',mean(y9,1)'];
mxy9 = sortrows(mxy9,1);
plot(mxy9(:,1),mxy9(:,2),'r-','linew',2,'Displayname','Average')

% upbxy9 = [max(x9,[],1)',max(y9,[],1)'];
% upbxy9 = sortrows(upbxy9,1);
% plot(upbxy9(:,1),upbxy9(:,2),'g--')
% 
% lwbxy9 = [min(x9,[],1)',min(y9,[],1)'];
% lwbxy9 = sortrows(lwbxy9,1);
% plot(lwbxy9(:,1),lwbxy9(:,2),'g--')

grid
xlabel('[Diagonal - Beam] Ratio [ (Ad/Ld) / (Ib/Lb) ] - (1/cm^2)'), ylabel('Efficiency - Axial in Diagonal (Nb) / Total Base Shear (V)')
title('Relationship of [ Diagonal (Ad/Ld) - Beam (Ib/Lb) ] Ratio VS Critical Diagonal Efficiency')


exportgraphics(f,'Relationship of Beam Ib-Lb Utility.png','Resolution',1200)
close all

%% Story Drift Ratio of 2nd floor VS (Ad/Ld) / (Ib/Lb)

i=0;
for k=1:10
%   figure(k)
    for j=1:nPFC
%         if UtliB{k}(j)<= 1  && UtilBR{k}{j}(2)<= 1
                i = i+1;
                xi10(i)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                yi10(i)  = (Abr(j)./(lenbr*100)) ./ (Ib(k)./(lenb*100));

                x10(k,j)  = abs( gendisGRAV{i}(2) + gendisSRSS{i}(2) )/floorH;
                y10(k,j)  = (Abr(j)./(lenbr*100)) ./ (Ib(k)./(lenb*100));
                 
                
               
%         end
    end 
end

f = figure;
hold on
x0=1;
y0=1;
width=23;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

plot(xi10,yi10,'.','Color',[0.5 0.5 0.5],'Displayname','Data')

mxy10 = [mean(x10,1)',mean(y10,1)'];
mxy10 = sortrows(mxy10,1);
plot(mxy10(:,1),mxy10(:,2),'r-','linew',2,'Displayname','Average')

upbxy10 = [max(x10,[],1)',max(y10,[],1)'];
upbxy10 = sortrows(upbxy10,1);
plot(upbxy10(:,1),upbxy10(:,2),'g--','Displayname','Upperbound')

lwbxy10 = [min(x10,[],1)',min(y10,[],1)'];
lwbxy10 = sortrows(lwbxy10,1);
plot(lwbxy10(:,1),lwbxy10(:,2),'b--','Displayname','Lowerbound')

legend
grid
xlabel('Critical Story Drif Ratio (2nd Floor)'), ylabel('[Diagonal - Beam] Ratio [ (Ad/Ld) / (Ib/Lb) ] - (1/cm^2)')
title('Relationship of [Diagonal (Ad/Ld) - Beam (Ib/Lb)] Ratio VS Critical Story Drif Ratio')

exportgraphics(f,'Relationship of Beam Ib-Lb Utility.png','Resolution',1200)
close all



%% Plot Column No.3 Interaction Diagram

% column yield info
My = 2039; % kg-m to kN-m
rM = 1;
Mb = My*rM;

Pyc = 11651; % kg-m to kN-m
Pyt = 11651;
rPc = 0;
Pb  = rPc*Pyc;

% plot interaction diagram
xint = [  0 Mb My ];
yint = [Pyc Pb  0 ];

f = figure;
hold on
x0=1;
y0=1;
width=23;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

intd = plot(xint,yint,'linew',2,'Displayname','Interaction Curve');
% plot3([0 0],get(gca,'ylim'),[-1 -1],'k')
% plot3(get(gca,'xlim'),[0 0],[-1 -1],'k')

% plot data in interaction diagram

DeM = MaxMCol;
DeA = MaxNCol;

h(1) = plot(DeM,DeA,'.','Displayname','Corresponding Design Moment-Axial');

% nominal capacity

[~,idMaxMCol] = max(DeM);
interC = InterX([xint; yint],[get(gca,'xlim'); [DeA(idMaxMCol) DeA(idMaxMCol)]]);
h(2) = plot(interC(1),interC(2),'ko','MarkerFaceColor','r','MarkerSize',6,'linew',1,'Displayname','Approx. Nominal Capacity Point');
h(3) = plot([0 interC(1) interC(1) interC(1)],[DeA(idMaxMCol) interC(2) interC(2) 0],':k');
text(interC(1),interC(2),{['M = ' num2str(DeM(idMaxMCol),'%.1f') ' kN-m'],['N = ' num2str(DeA(idMaxMCol),'%.1f') ' kN']})


xlabel('Moment (kN-m)'), ylabel('Axial (kN)')
title('EC8 - Interaction Diagram of Typical Critical Column and Design Action for 160 Simulations')
grid on
legend([intd h(1),h(2)])

exportgraphics(f,[get(get(gca,'title'),'String') '.png'],'Resolution',1200)
close all




