clc
fclose('all');

% load file
load NL_ElemGen.mat
ElmGvar = who('-file','NL_ElemGen.mat');

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


%%

fig=0;
for z=1:length(Foldername)
    
    load(['elemC'   Foldername{z} '.mat'])
    load(['elemB'   Foldername{z} '.mat'])
    load(['elemBRA' Foldername{z} '.mat'])
    load(['nodalr'  Foldername{z} '.mat'])
    
for j=1:length(Recname)
    fig = fig+1;
    
    % beam
    nTPlBMi = zeros(nbeam,1);
    nTPHBMi = zeros(nbeam,1);
    nTPlBMj = zeros(nbeam,1);
    nTPHBMj = zeros(nbeam,1);
    nMaxTPHBMi = zeros(nbeam,1);
    nMaxTPHBMj = zeros(nbeam,1);

    

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

tstep = 0:0.1:45;

% Scale for beam and column

scB   = 1;
scC   = 0.5;
scBRAx = 4;
scBRAy = scBRAx*tand(18.43);
scDis = 2;
scT   = 0.5;
scPH  = 1.5;
scTM  = 2.2*0.5;
    
h = figure(fig);

% plot beam

for i=1:nbeam
    
    beamgen1       = beamgen(i,2);
    beamgen2       = beamgen(i,3);
    
    [r1,c1]        = find(coord(:,1) == beamgen1 );
    [r2,c2]        = find(coord(:,1) == beamgen2 );
    
    hold on
    
    pB(i) = plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
     
end

% plot column

for i=1:ncol
    
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    hold on
    
    pC(i) = plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end



% plot brace

for i=1:nbra
    
    corbra1       = bragen(i,2);
    corbra2       = bragen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corbra1 );
    [r2,c2]       = find(coord(:,1) == corbra2 );
    
    hold on
    
    pBRA(i) = plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end


%%

% initila plastic hinge mark
PlBMi    = plot(0,0,'wo','MarkerSize',1);
PlBMj    = plot(0,0,'wo','MarkerSize',1);
PlCMi    = plot(0,0,'wo','MarkerSize',1);
PlCMj    = plot(0,0,'wo','MarkerSize',1);
PlBRAMi  = plot(0,0,'wo','MarkerSize',1);
TPlBMi   = plot(0,0,'wo','MarkerSize',1);

% axis tight manual % this ensures that getframe() returns a consistent size
set(gca,'Xlim',[-1 29])
set(gca,'Ylim',[ 0 25])
x0=1;
y0=1;
width=25;
height=0.5*width;
set(gcf,'units','centimeters','position',[x0,y0,width,height])



for k=1:length(tstep)
    
    % delete plastic hinge mark
    
    for i=1:length(PlBMi)
        
        delete(PlBMi(i))
        
    end
    
    for i=1:length(PlBMj)
        
        delete(PlBMj(i))
        
    end
    
    for i=1:length(PlCMi)
        
        delete(PlCMi(i))
        
    end
    
    for i=1:length(PlCMj)
        
        delete(PlCMj(i))
        
    end
    
    for i=1:length(PlBRAMi)
        
        delete(PlBRAMi(i))
        
    end    
    

    % Start
    title(['Simulation No. ' Foldername{z}(3:end) ' Plastic Hinge Formation After ' num2str(tstep(k)) ' s']);
    xlabel([EQname{j}])
    set(gca,'XTick',[], 'YTick', [])

    % update beam coordinate
    for i=1:nbeam
    
    beamgen1       = beamgen(i,2);
    beamgen2       = beamgen(i,3);
    
    [r1,c1]        = find(coord(:,1) == beamgen1 );
    [r2,c2]        = find(coord(:,1) == beamgen2 );
    
    % Include Displacement
    [rDisi] = find(round(nodalr{j}{r1}(:,2),1)==tstep(k));
    [rDisj] = find(round(nodalr{j}{r2}(:,2),1)==tstep(k));
     
    
    if ~isempty(rDisi) && ~isempty(rDisj)
        
    set(pB(i),'XData',[coord(r1,2)+scDis*nodalr{j}{r1}(rDisi(end),3),coord(r2,2)+scDis*nodalr{j}{r2}(rDisj(end),3)])
    set(pB(i),'YData',[coord(r1,3)+scDis*nodalr{j}{r1}(rDisi(end),4),coord(r2,3)+scDis*nodalr{j}{r2}(rDisj(end),4)])
    
    end    
    end
    
    
    % update column coordinate
    for i=1:ncol
    
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    % Include Displacement
    [rDisi] = find(round(nodalr{j}{r1}(:,2),1)==tstep(k));
    [rDisj] = find(round(nodalr{j}{r2}(:,2),1)==tstep(k));
     
    
    if ~isempty(rDisi) && ~isempty(rDisj)
        
    set(pC(i),'XData',[coord(r1,2)+scDis*nodalr{j}{r1}(rDisi(end),3),coord(r2,2)+scDis*nodalr{j}{r2}(rDisj(end),3)])
    set(pC(i),'YData',[coord(r1,3)+scDis*nodalr{j}{r1}(rDisi(end),4),coord(r2,3)+scDis*nodalr{j}{r2}(rDisj(end),4)])
    
    end    
    end


    % update brace coordinate
    for i=1:nbra
    
    corbra1       = bragen(i,2);
    corbra2       = bragen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corbra1 );
    [r2,c2]       = find(coord(:,1) == corbra2 );
    
    % Include Displacement
    [rDisi] = find(round(nodalr{j}{r1}(:,2),1)==tstep(k));
    [rDisj] = find(round(nodalr{j}{r2}(:,2),1)==tstep(k));
     
    
    if ~isempty(rDisi) && ~isempty(rDisj)
        
    set(pBRA(i),'XData',[coord(r1,2)+scDis*nodalr{j}{r1}(rDisi(end),3),coord(r2,2)+scDis*nodalr{j}{r2}(rDisj(end),3)])
    set(pBRA(i),'YData',[coord(r1,3)+scDis*nodalr{j}{r1}(rDisi(end),4),coord(r2,3)+scDis*nodalr{j}{r2}(rDisj(end),4)])
    
    end    
    end
    

    % plot plastic hinge in beam
    
    
    for i=1:nbeam
        
        beamgen1       = beamgen(i,2);
        beamgen2       = beamgen(i,3);
        
        [r1,c1]        = find(coord(:,1) == beamgen1 );
        [r2,c2]        = find(coord(:,1) == beamgen2 );
        
        hold on
        
        
        % find time for plastic hinge
        rPHBi = [];
        rPHBj = [];
        
        if ~isempty(PHinfoB{j}{i}{1})
        [rPHBi] = find(round(PHinfoB{j}{i}{1}(:,2),1)==tstep(k));
        end
        if isempty(rPHBi),PHBki(i,k)=0;end
        
        
        if ~isempty(PHinfoB{j}{i}{2})
        [rPHBj] = find(round(PHinfoB{j}{i}{2}(:,2),1)==tstep(k));
        end
        if isempty(rPHBj),PHBkj(i,k)=0;end
        
        
        if ~isempty(PHinfoB{j}{i}{1}) && ~isempty(rPHBi)
            
            plot(coord(r1,2)+scB,coord(r1,3),'ko','MarkerSize',7,'MarkerFaceColor','r');
            
            nTPHBMi(i)= nTPHBMi(i)+1;
            if nTPHBMi(i) > 1 && nTPHBMi(i)>nTPHBMi(i)-1,delete(TPHBMi(i));end
            idPHBki   = PHinfoB{j}{i}{1}(round(PHinfoB{j}{i}{1}(:,2),1)==tstep(k),5);
            TPHBMi(i) = text(coord(r1,2)+scB,coord(r1,3)+scT,num2str(idPHBki(end)),'FontSize',7);
            
            nMaxTPHBMi(i)= nMaxTPHBMi(i)+1;
            PHBki(i,k)= idPHBki(end);
            [~,idxM]  = max(abs(PHBki(i,:)));
            if nMaxTPHBMi(i) == 1,MaxTPHBMi(i) = text(coord(r1,2)+scB,coord(r1,3)+scTM,num2str(PHBki(i,idxM)),'FontSize',7,'Color','r');end
            if nMaxTPHBMi(i) > 1,set(MaxTPHBMi(i),'String',PHBki(i,idxM));end          
            

            PlBMi(i)  = plot(coord(r1,2)+scB,coord(r1,3),'ro','MarkerSize',15);
            
            nTPlBMi(i)= nTPlBMi(i)+1;
            if nTPlBMi(i) > 1 && nTPlBMi(i)>nTPlBMi(i)-1,delete(TPlBMi(i));end
            TPlBMi(i) = text(coord(r1,2)+scB+scT,coord(r1,3),num2str(nTPlBMi(i)),'FontSize',10);
  
        end
              
       
        if ~isempty(PHinfoB{j}{i}{2}) && ~isempty(rPHBj)
            
            plot(coord(r2,2)-scB,coord(r2,3),'ko','MarkerSize',7,'MarkerFaceColor','r');
            
            nTPHBMj(i)= nTPHBMj(i)+1;
            if nTPHBMj(i) > 1 && nTPHBMj(i)>nTPHBMj(i)-1,delete(TPHBMj(i));end
            idPHBkj   = PHinfoB{j}{i}{2}(round(PHinfoB{j}{i}{2}(:,2),1)==tstep(k),5);
            TPHBMj(i) = text(coord(r2,2)-scB,coord(r2,3)+scT,num2str(idPHBkj(end)),'FontSize',7);
            PlBMj(i) = plot(coord(r2,2)-scB,coord(r2,3),'ro','MarkerSize',15);

            nMaxTPHBMj(i)= nMaxTPHBMj(i)+1;
            PHBkj(i,k)= idPHBkj(end);
            [~,idxM]  = max(abs(PHBkj(i,:)));
            if nMaxTPHBMj(i) == 1,MaxTPHBMj(i) = text(coord(r2,2)-scB,coord(r2,3)+scTM,num2str(PHBkj(i,idxM)),'FontSize',7,'Color','r');end
            if nMaxTPHBMj(i) > 1,set(MaxTPHBMj(i),'String',PHBkj(i,idxM));end          
            
            nTPlBMj(i)= nTPlBMj(i)+1;
            if nTPlBMj(i) > 1 && nTPlBMj(i)>nTPlBMj(i)-1,delete(TPlBMj(i));end
            TPlBMj(i) = text(coord(r2,2)-scB-scT,coord(r2,3),num2str(nTPlBMj(i)),'FontSize',10);

        end
 
    end

%     plot plastic hinge in column
    
    
    for i=1:ncol
        
        corcol1       = colgen(i,2);
        corcol2       = colgen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corcol1 );
        [r2,c2]       = find(coord(:,1) == corcol2 );
        
        hold on
        
        % find time for plastic hinge
        
        if ~isempty(PHinfoC{j}{i}{1})
        [rPHCi] = find(round(PHinfoC{j}{i}{1}(:,2),1)==tstep(k));
        end
        
        if ~isempty(PHinfoC{j}{i}{2})
        [rPHCj] = find(round(PHinfoC{j}{i}{2}(:,2),1)==tstep(k));
        end
         
        
        if ~isempty(PHinfoC{j}{i}{1}) && ~isempty(rPHCi)
            
            plot(coord(r1,2),coord(r1,3)+scC,'ko','MarkerSize',7,'MarkerFaceColor','b');
            PlCMi(i) = plot(coord(r1,2),coord(r1,3)+scC,'ro','MarkerSize',15);

        end
        
        
        if ~isempty(PHinfoC{j}{i}{2}) && ~isempty(rPHCj)
            
            plot(coord(r2,2),coord(r2,3)-scC,'ko','MarkerSize',7,'MarkerFaceColor','b');
            PlCMj(i) = plot(coord(r2,2),coord(r2,3)-scC,'ro','MarkerSize',15);
        end
        
    end    
    
    

    %     plot plastic hinge in brace
    
    
    for i=1:nbra
        
        corbra1       = bragen(i,2);
        corbra2       = bragen(i,3);
        
        [r1,c1]       = find(coord(:,1) == corbra1 );
        [r2,c2]       = find(coord(:,1) == corbra2 );
        
        hold on
        
        
        % find time for plastic hinge
        
        if ~isempty(PHinfoBRA{j}{i}{1})
            [rPHBRAi] = find(round(PHinfoBRA{j}{i}{1}(:,2),1)==tstep(k));
        end
        
        
        if ~isempty(PHinfoBRA{j}{i}{1}) && ~isempty(rPHBRAi) && logical(mod(i,2))==true
            
            plot(coord(r1,2)+scBRAx,coord(r1,3)+scBRAy,'ko','MarkerSize',7,'MarkerFaceColor','g');
            PlBRAMi(i) = plot(coord(r1,2)+scBRAx,coord(r1,3)+scBRAy,'ro','MarkerSize',15);
            
        end
        
        if ~isempty(PHinfoBRA{j}{i}{1}) && ~isempty(rPHBRAi) && logical(mod(i,2))==false
            
            plot(coord(r1,2)-scBRAx,coord(r1,3)+scBRAy,'ko','MarkerSize',7,'MarkerFaceColor','g');
            PlBRAMi(i) = plot(coord(r1,2)-scBRAx,coord(r1,3)+scBRAy,'ro','MarkerSize',15);
            
        end
        
        
    end


 
    pause(0.5)
    
    % Capture the plot as an image
    
    filename = [Foldername{z}(3:end) ' ' EQname{j} '.gif'];
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if k == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    
end

close all
clearvars('-except','z','ElmGvar',ElmGvar{:},'Foldername','EQname','Recname','fig','elemC','elemB','elemBRA','nodalr')


end

clear elemC elemB elemBRA nodalr

end

