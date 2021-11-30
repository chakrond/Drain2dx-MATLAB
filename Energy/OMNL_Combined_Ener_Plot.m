clc
fclose('all');

% % load file
% load Legend.mat
% load nSectionInfo.mat
% load ExtrSecProp.mat

% read record filename
% create record filename
EQname  = {'1994 Northridge' '1989 Loma Prieta' '1995 Kobe' '1979 Imperial Valley'};


% create folder name
Folder      = dir('ONEMODEL*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end


%% Energy Dissipation of Simulation by column

marker  = [{'-g'} {'-b'} {'-r'} {'-y'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--mo'} {'--ms'} {'--md'} {'--m^'} ];


for z=1:length(Foldername)

    cd(Foldername{z})
    dirfile = dir('ComRat*');
    dirname = dirfile.name;
    load(dirname)
    
    countRec = length(dir('*.dat'));
    
    f = figure(1);
    hold on
    x0=1;
    y0=1;
    width=20;
    height=0.5*width;
    set(gcf,'units','centimeters','position',[x0,y0,width,height])
    legend('Location','best')
    
    combRat = [(Wd./TotW) (Wc./TotW)];
    combRat = sortrows(combRat);
    plot(combRat(:,1),combRat(:,2),marker{z},'linew',1,'Displayname',[EQname{z} ' - ' num2str(countRec) ' Records'])
    
    clear Wb Wc Wd TotW countRec
    cd ..


end

legend
grid on
xlabel('Energy Ratio [Diagonal (Wd/Wt)]'), ylabel('Energy Ratio [Column (Wc/Wt)]')
titl = title('Energy Dissipation Behaviour of Column VS Diagonal of Simulations No.B07D07');

exportgraphics(f,'Energy Dissipation Behaviour of Column.png','Resolution',1200)
exp         = '[^ \f\n\r\t\v,;:]*.';
extract     = regexp(titl.String,exp,'match');
exportgraphics(f,[strjoin(extract) '.png'],'Resolution',1200)

close all

%% Energy Dissipation of Simulation by beam

marker  = [{'-g'} {'-b'} {'-r'} {'-y'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--mo'} {'--ms'} {'--md'} {'--m^'} ];


for z=1:length(Foldername)

    cd(Foldername{z})
    dirfile = dir('ComRat*');
    dirname = dirfile.name;
    load(dirname)
    
    countRec = length(dir('*.dat'));
    
    f = figure(1);
    hold on
    x0=1;
    y0=1;
    width=20;
    height=0.5*width;
    set(gcf,'units','centimeters','position',[x0,y0,width,height])
    legend('Location','best')
    
    combRat = [(Wd./TotW) (Wb./TotW)];
    combRat = sortrows(combRat);
    plot(combRat(:,1),combRat(:,2),marker{z},'linew',1,'Displayname',[EQname{z} ' - ' num2str(countRec) ' Records'])
    
    clear Wb Wc Wd TotW countRec
    cd ..


end

legend
grid on
xlabel('Energy Ratio [Diagonal (Wd/Wt)]'), ylabel('Energy Ratio [Beam (Wb/Wt)]')
titl = title('Energy Dissipation Behaviour of Beam VS Diagonal of Simulations No.B07D07');

exportgraphics(f,[get(get(gca,'title'),'String') '.png'],'Resolution',1200)
close all

%% Diagonal energy ratio and rupture distance

marker  = [{'-g'} {'-b'} {'-r'} {'-y'} ...
           {'--bo'} {'--bs'} {'--bd'} {'--b^'} ...
           {'--ro'} {'--rs'} {'--rd'} {'--r^'} ...
           {'--mo'} {'--ms'} {'--md'} {'--m^'} ];


for z=1:length(Foldername)

    cd(Foldername{z})
    dirfile = dir('ComRat*');
    dirname = dirfile.name;
    load(dirname)
    MATname1 = whos('-file',dirname);
    
    load('EQInfo.mat')
    MATname2 = whos('-file','EQInfo.mat');
    
    countRec = length(dir('*.dat'));
    
    f = figure(1);
    hold on
    x0=1;
    y0=1;
    width=20;
    height=0.5*width;
    set(gcf,'units','centimeters','position',[x0,y0,width,height])
    
    
    combRat = [(Wd./TotW) [seqnum{:,4}]'];
    combRat = sortrows(combRat);
    plot(combRat(:,1),combRat(:,2),marker{z},'linew',1,'Displayname',[EQname{z} ' - ' num2str(countRec) ' Records'])
    
    clear(MATname1.name)
    clear(MATname2.name)
    
    cd ..


end

legend('Location','best')
grid on
xlabel('Energy Ratio [Diagonal (Wd/Wt)]'), ylabel('Rrup (km)')
titl = title('Energy Dissipation Behaviour of Diagonal VS Distance to Rupture of Simulations No.B07D07');

exportgraphics(f,[get(get(gca,'title'),'String') '.png'],'Resolution',1200)
close all

