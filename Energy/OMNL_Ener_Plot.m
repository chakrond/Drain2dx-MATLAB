clc
fclose('all');

% load file
load Legend.mat
load nSectionInfo.mat
load ExtrSecProp.mat
load EQInfo.mat

% read record filename
% create record filename
Filerec       = dir('*.dat');
for i=1:length(Filerec)
    Recname{i} = Filerec(i).name;
end
EQname  = {'1994 Northridge' '1989 Loma Prieta' '1995 Kobe' '1979 Imperial Valley'};


% create folder name
Folder      = dir('OMR*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end

id=0;
for z=1:length(Foldername)
    
    load(['Ener_' Foldername{z} '.mat'])
    
%     for j=1:length(Recname)
%         
%         if isempty(Ener{j}),id=id+1;idz(id,:) = z;idj(id,:) = j;idname{id,:} = Foldername{z};continue,end
%         
%         % model per record
%         
%         idB = str2double(Foldername{z}(5:6));
%         if idB > 7,continue,end
%         
%         idD = str2double(Foldername{z}(8:9));
%         
%         
%         MWc{j}(idB,idD)   = Ener{j}(end,12) - Ener{j}(1,12);
%         MWb{j}(idB,idD)   = Ener{j}(end,13) - Ener{j}(1,13);
%         MWd{j}(idB,idD)   = Ener{j}(end,14) - Ener{j}(1,14);
%         MTotW{j}(idB,idD) = Ener{j}(end,5)  - Ener{j}(1,5) ;
        
        % all model/record
        Wc(z,1)   = Ener{1}(end,12) - Ener{1}(1,12); % element group 1
        Wb(z,1)   = Ener{1}(end,13) - Ener{1}(1,13); % element group 2
        Wd(z,1)   = Ener{1}(end,14) - Ener{1}(1,14); % element group 3
        TotW(z,1) = Ener{1}(end,5)  - Ener{1}(1,5) ; % total ground motion energy
        
%     end
    
    % clear file before next loop
    clear Ener

end


%% Energy Ratio

RatWcd   = Wc./Wd;
% RatWcd   = RatWcd.*(RatWcd>0);

RatWbd   = Wb./Wd;
% RatWbd   = RatWbd.*(RatWcd>0);

RatWdT   = Wd./TotW;
% RatWdT   = RatWdT.*(RatWcd>0);


%% plot

f = figure;
hold on
x0=1;
y0=1;
width=25;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])
legend('Location','best')

combRat = [(Wd./TotW) (Wc./TotW) [seqnum{:,4}]'];
combRat = sortrows(combRat);
plot(combRat(:,1),combRat(:,2),'linew',2,'Displayname','Column VS Diagonal Energy Ratio')

combRat = [(Wd./TotW) (Wb./TotW) [seqnum{:,4}]'];
combRat = sortrows(combRat);
plot(combRat(:,1),combRat(:,2),'linew',2,'Displayname','Beam VS Diagonal Energy Ratio')

yyaxis right
ylabel('Rrup (km)')
% p1 = plot(combRat(:,1),combRat(:,3),'Color',[0.5 0.5 0.5],'linew',1,'Displayname','Rupture VS Diagonal Energy Ratio');
p1 = plot(combRat(:,1),combRat(:,3),'linew',1,'Displayname','Rupture VS Diagonal Energy Ratio');
p1.Color(4) = 0.5;

yyaxis left
legend
grid on
xlabel('Energy Ratio [Diagonal (Wd/Wt)]'), ylabel('Energy Ratio [Column (Wc/Wt)], [Beam (Wb/Wt)]')
title(['Energy Dissipation of Simulation No.B07D07 under ' EQname{4} ' Earthquake ' num2str(length(Recname)) ' Records'])

exportgraphics(f,['Energy Dissipation ' EQname{4} '.png'],'Resolution',1200)
close all

%% save file
save(['ComRat' EQname{4} '.mat'],'Wd','Wc','Wb','TotW')
    