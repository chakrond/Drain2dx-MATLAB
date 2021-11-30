clc
fclose('all');

% load file
load NL_ElemGen.mat

% input filename
inputf      = 'drain.inp';

% read record filename
% create record filename
Filerec       = dir('*.dat');
for i=1:length(Filerec)
    Recname{i} = Filerec(i).name;
end
EQname  = {'FF-1994 Northridge' 'FF-1989 Loma Prieta' 'NF-1995 Kobe' 'NF-1979 Imperial Valley'};


% create folder name
Folder      = dir('RX*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end

fig=0;
for z=1:length(Foldername)
    
    load(['elemC'   Foldername{z} '.mat'])
    load(['elemB'   Foldername{z} '.mat'])
    load(['elemBRA' Foldername{z} '.mat'])
    
for j=1:length(Recname)
    fig = fig+1;
    
%% Find Plastic Hinge Formation in beam

for i=1:nbeam
    
[rPB{j}{i}{1}(:,1)] = find(elemB{j}{i}{1}(:,4)==1);
[rPB{j}{i}{2}(:,1)] = find(elemB{j}{i}{2}(:,4)==1);

end

for i=1:nbeam
    
    % Find time for plastic hinge & moment
    
    if ~isempty(rPB{j}{i}{1})
        
        for q=1:length(rPB{j}{i}{1})
            PHinfoB{j}{i}{1}(q,1) = elemB{j}{i}{1}(rPB{j}{i}{1}(q),3);
            PHinfoB{j}{i}{1}(q,2) = elemB{j}{i}{1}(rPB{j}{i}{1}(q),2);
            PHinfoB{j}{i}{1}(q,3) = elemB{j}{i}{1}(rPB{j}{i}{1}(q),5);
            PHinfoB{j}{i}{1}(q,4) = elemB{j}{i}{1}(rPB{j}{i}{1}(q),6);
            PHinfoB{j}{i}{1}(q,5) = elemB{j}{i}{1}(rPB{j}{i}{1}(q),8);
        end
        
    elseif isempty(rPB{j}{i}{1})
        
        PHinfoB{j}{i}{1} = [];
        
    end
    
    if ~isempty(rPB{j}{i}{2})
        
        for q=1:length(rPB{j}{i}{2})
            PHinfoB{j}{i}{2}(q,1) = elemB{j}{i}{2}(rPB{j}{i}{2}(q),3);
            PHinfoB{j}{i}{2}(q,2) = elemB{j}{i}{2}(rPB{j}{i}{2}(q),2);
            PHinfoB{j}{i}{2}(q,3) = elemB{j}{i}{2}(rPB{j}{i}{2}(q),5);
            PHinfoB{j}{i}{2}(q,4) = elemB{j}{i}{2}(rPB{j}{i}{2}(q),6);
            PHinfoB{j}{i}{2}(q,5) = elemB{j}{i}{2}(rPB{j}{i}{2}(q),8);
        end
        
    elseif isempty(rPB{j}{i}{2})
        
            PHinfoB{j}{i}{2} = [];
        
    end
end   

%% Find Plastic Hinge Formation in column

for i=1:ncol
    
[rPC{j}{i}{1}(:,1)] = find(elemC{j}{i}{1}(:,4)==1);
[rPC{j}{i}{2}(:,1)] = find(elemC{j}{i}{2}(:,4)==1);

end

for i=1:ncol
    
    % Find time for plastic hinge & moment
    
    if ~isempty(rPC{j}{i}{1})
        
        for q=1:length(rPC{j}{i}{1})
            PHinfoC{j}{i}{1}(q,1) = elemC{j}{i}{1}(rPC{j}{i}{1}(q),3);
            PHinfoC{j}{i}{1}(q,2) = elemC{j}{i}{1}(rPC{j}{i}{1}(q),2);
            PHinfoC{j}{i}{1}(q,3) = elemC{j}{i}{1}(rPC{j}{i}{1}(q),5);
            PHinfoC{j}{i}{1}(q,4) = elemC{j}{i}{1}(rPC{j}{i}{1}(q),6);
            PHinfoC{j}{i}{1}(q,5) = elemC{j}{i}{1}(rPC{j}{i}{1}(q),8);
        end
        
    elseif isempty(rPC{j}{i}{1})
        
        PHinfoC{j}{i}{1} = [];
        
    end
    
    if ~isempty(rPC{j}{i}{2})
        
        for q=1:length(rPC{j}{i}{2})
            PHinfoC{j}{i}{2}(q,1) = elemC{j}{i}{2}(rPC{j}{i}{2}(q),3);
            PHinfoC{j}{i}{2}(q,2) = elemC{j}{i}{2}(rPC{j}{i}{2}(q),2);
            PHinfoC{j}{i}{2}(q,3) = elemC{j}{i}{2}(rPC{j}{i}{2}(q),5);
            PHinfoC{j}{i}{2}(q,4) = elemC{j}{i}{2}(rPC{j}{i}{2}(q),6);
            PHinfoC{j}{i}{2}(q,5) = elemC{j}{i}{2}(rPC{j}{i}{2}(q),8);
        end
        
    elseif isempty(rPC{j}{i}{2})
        
            PHinfoC{j}{i}{2} = [];
        
    end
end

%% Find Plastic Hinge Formation in brace

for i=1:nbra
    
[rPBRA{j}{i}{1}(:,1)] = find(elemBRA{j}{i}{1}(:,4)==1);
[rPBRA{j}{i}{2}(:,1)] = find(elemBRA{j}{i}{2}(:,4)==1);

end

for i=1:nbra
    
    % Find time for plastic hinge & moment
    
    if ~isempty(rPBRA{j}{i}{1})
        
        for q=1:length(rPBRA{j}{i}{1})
            PHinfoBRA{j}{i}{1}(q,1) = elemBRA{j}{i}{1}(rPBRA{j}{i}{1}(q),3);
            PHinfoBRA{j}{i}{1}(q,2) = elemBRA{j}{i}{1}(rPBRA{j}{i}{1}(q),2);
            PHinfoBRA{j}{i}{1}(q,3) = elemBRA{j}{i}{1}(rPBRA{j}{i}{1}(q),5);
            PHinfoBRA{j}{i}{1}(q,4) = elemBRA{j}{i}{1}(rPBRA{j}{i}{1}(q),6);
            PHinfoBRA{j}{i}{1}(q,5) = elemBRA{j}{i}{1}(rPBRA{j}{i}{1}(q),8);
        end
        
    elseif isempty(rPBRA{j}{i}{1})
        
        PHinfoBRA{j}{i}{1} = [];
        
    end
    
    if ~isempty(rPBRA{j}{i}{2})
        
        for q=1:length(rPBRA{j}{i}{2})
            PHinfoBRA{j}{i}{2}(q,1) = elemBRA{j}{i}{2}(rPBRA{j}{i}{2}(q),3);
            PHinfoBRA{j}{i}{2}(q,2) = elemBRA{j}{i}{2}(rPBRA{j}{i}{2}(q),2);
            PHinfoBRA{j}{i}{2}(q,3) = elemBRA{j}{i}{2}(rPBRA{j}{i}{2}(q),5);
            PHinfoBRA{j}{i}{2}(q,4) = elemBRA{j}{i}{2}(rPBRA{j}{i}{2}(q),6);
            PHinfoBRA{j}{i}{2}(q,5) = elemBRA{j}{i}{2}(rPBRA{j}{i}{2}(q),8);
        end
        
    elseif isempty(rPBRA{j}{i}{2})
        
            PHinfoBRA{j}{i}{2} = [];
        
    end
end


%% Plot Plastic Hinge by time step

tstep = 45;

% Scale for beam and column

scB   = 1;
scC   = 0.5;
scBRAx = 4;
scBRAy = scBRAx*tand(18.43);


for k=1:length(tstep)
    
    figure
%     title([ 'Plastic Hinge Formation After ' num2str(tstep(k)) ' s' ' Simulation No.' Foldername{z}(3:end) ]);
    set(gca,'XTick',[], 'YTick', [])
    set(gca,'Xlim',[-0.5 28.5]);
    xlabel([EQname{j}])
    
    % Plot beam and column
    
    % plot beam
    
    for i=1:nbeam
        
        beamgen1       = beamgen(i,2);
        beamgen2       = beamgen(i,3);
        
        [r1,c1]        = find(coord(:,1) == beamgen1 );
        [r2,c2]        = find(coord(:,1) == beamgen2 );
        
        hold on
        
        plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
        
    end
    
    % plot column
    
    for i=1:ncol
        
        corcol1       = colgen(i,2);
        corcol2       = colgen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corcol1 );
        [r2,c2]       = find(coord(:,1) == corcol2 );
        
        hold on
        
        plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
        
    end
    
    % plot brace
    
    for i=1:nbra
        
        corbra1       = bragen(i,2);
        corbra2       = bragen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corbra1 );
        [r2,c2]       = find(coord(:,1) == corbra2 );
        
        hold on
        
        plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
        
    end
    
    
    % plot plastic hinge in beam
    
    
    for i=1:nbeam
        
        beamgen1       = beamgen(i,2);
        beamgen2       = beamgen(i,3);
        
        [r1,c1]        = find(coord(:,1) == beamgen1 );
        [r2,c2]        = find(coord(:,1) == beamgen2 );
        
        hold on
        
        if ~isempty(PHinfoB{j}{i}{1}) && min(PHinfoB{j}{i}{1}(:,2))<=tstep(k)
            
            plot(coord(r1,2)+scB,coord(r1,3),'ko','MarkerSize',7,'MarkerFaceColor','r');
        end
        
        
        if ~isempty(PHinfoB{j}{i}{2}) && min(PHinfoB{j}{i}{2}(:,2))<=tstep(k)
            
            plot(coord(r2,2)-scB,coord(r2,3),'ko','MarkerSize',7,'MarkerFaceColor','r');
        end
        
    end
    
    % plot plastic hinge in column
    
    
    for i=1:ncol
        
        corcol1       = colgen(i,2);
        corcol2       = colgen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corcol1 );
        [r2,c2]       = find(coord(:,1) == corcol2 );
        
        hold on
        
        if ~isempty(PHinfoC{j}{i}{1}) && min(PHinfoC{j}{i}{1}(:,2))<=tstep(k)
            
            plot(coord(r1,2),coord(r1,3)+scC,'ko','MarkerSize',7,'MarkerFaceColor','b');
        end
        
        
        if ~isempty(PHinfoC{j}{i}{2}) && min(PHinfoC{j}{i}{2}(:,2))<=tstep(k)
            
            plot(coord(r2,2),coord(r2,3)-scC,'ko','MarkerSize',7,'MarkerFaceColor','b');
        end
        
    end
    
    
    % plot plastic hinge in brace
    
    
    for i=1:nbra
        
        corbra1       = bragen(i,2);
        corbra2       = bragen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corbra1 );
        [r2,c2]       = find(coord(:,1) == corbra2 );
        
        hold on
        
        
        if ~isempty(PHinfoBRA{j}{i}{1}) && min(PHinfoBRA{j}{i}{1}(:,2))<=tstep(k) && logical(mod(i,2))==true
            
            plot(coord(r1,2)+scBRAx,coord(r1,3)+scBRAy,'ko','MarkerSize',7,'MarkerFaceColor','g');
        end
        
        if ~isempty(PHinfoBRA{j}{i}{1}) && min(PHinfoBRA{j}{i}{1}(:,2))<=tstep(k) && logical(mod(i,2))==false
            
            plot(coord(r1,2)-scBRAx,coord(r1,3)+scBRAy,'ko','MarkerSize',7,'MarkerFaceColor','g');
        end
        
        
        
        
%         if ~isempty(PHinfoBRA{j}{i}{2}) && min(PHinfoBRA{j}{i}{2}(:,2))<=tstep(k)
%             
%             plot(coord(r2,2)-scBRAx,coord(r2,3)-scBRAy,'ko','MarkerSize',7,'MarkerFaceColor','g');
%         end
        
    end
    
    % save figure
    exportgraphics(figure(fig),[ Foldername{z}(3:end) ' Figure ' num2str(fig)  '.png'],'Resolution',1200)

end
end
clear rPB, clear PHinfoB
clear rPC, clear PHinfoC
clear rPBRA, clear PHinfoBRA


end


