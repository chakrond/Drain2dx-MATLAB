%% 
clc
fclose('all');

% load file
load NL_ElemGen.mat

%% Plot Env Drift Ratio

% create folder name
Folder      = dir('RX*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end

% Input**
floorH  = 4; % m
EQname  = {'FF-1994 Northridge' 'FF-1989 Loma Prieta' 'NF-1995 Kobe' 'NF-1979 Imperial Valley'};


% Plot envelop drift raio

marker  = [{'-go'} {'-bs'} {'-r^'} {'-md'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--mo'} {'--ms'} {'--md'} {'--m^'} ];

for z=1:length(Foldername)
    
    f(z) = figure;
    hold on
    x0=1;
    y0=1;
    width=16;
    height=width;
    set(gcf,'units','centimeters','position',[x0,y0,width,height])
    legend('Location','best')
    load(['elemB'   Foldername{z} '.mat'])
    load(['genDisp' Foldername{z} '.mat'])
    load(['genDisp' Foldername{z} '.mat'])
    
    for j=1:length(gendis)
            
            hold on
            y1  = 1:6;
            x1  = max(gendis{j}(:,3:8),[],1)./floorH;
            plot(x1,y1,marker{j});
              
    end
    
    set(gca,'YTick',[1 2 3 4 5 6])
    set(gca,'Xlim',[0 0.05])
    legend(EQname)
    title([ 'Enveloped Drfit Ratio' ' Simulation No.' Foldername{z}(3:end) ]);
    xlabel('Drift Ratio'), ylabel('Floor')
    grid
    
    % clear via
    clear gendis
end

%% save file
for z=1:length(Foldername)
    exportgraphics(f(z),[Foldername{z}(3:end) ' Enveloped Drfit Ratio' '.png'],'Resolution',1200)
end

close all