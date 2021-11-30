%% 
clc
fclose('all');

% load file
load NL_ElemGen.mat

%% Plot Nodal Elastic Response (Momoent vs Rotation)

% create folder name
Folder      = dir('RX*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end

% Input**
EQname  = {'FF-1994 Northridge' 'FF-1989 Loma Prieta' 'NF-1995 Kobe' 'NF-1979 Imperial Valley'};

% selected node
SelecN     = 2030;
% find beam
[rSelecB]  = find(beamgen(:,2)==SelecN(1));

% Plot local ductility

marker  = [{'-g'} {'-b'} {'-r'} {'-y'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--mo'} {'--ms'} {'--md'} {'--m^'} ];

for z=1:length(Foldername)
    

    f(z) = figure;
    hold on
    x0=1;
    y0=1;
    width=20;
    height=width;
    set(gcf,'units','centimeters','position',[x0,y0,width,height])
%     legend('Location','best')
    load(['elemB'   Foldername{z} '.mat'])
    load(['genDisp' Foldername{z} '.mat'])
    
    for j=1:length(gendis)
        for i=1
            
            
            plE    = plot(gendis{j}(:,9),elemB{j}{rSelecB}{i}(:,5),marker{j});
            
        end
        
    end
    
    set(gca,'Xlim',[-0.05 0.05])
    set(gca,'Ylim',[-1200 1200])
    plot3(get(gca,'xlim'),[0 0],[-1 -1],'k')
    plot3([0 0],get(gca,'ylim'),[-1 -1],'k')
    legend(EQname)
    title([ 'Hysteresis Loop of Critical Beam' ' Simulation No.' Foldername{z}(3:end) ]);
    xlabel('Rotation'), ylabel('Moment(kN-m)')
    grid
    
%     set(gcf,'WindowState','maximized')
    

    % clear via
    clear gendis, clear elemB
    
end

%%
for z=1:length(Foldername)
    exportgraphics(f(z),[Foldername{z}(3:end) ' Hysteresis Loop2' '.png'],'Resolution',1200)
end

close all
