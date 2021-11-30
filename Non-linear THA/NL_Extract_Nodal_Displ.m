
clc
fclose('all')

% load file
load NL_ElemGen.mat

% create folder name
Folder      = dir('RX*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end


for z=1:length(Foldername)
    
    cd(Foldername{z})
    
    File        = dir('*.OUT');
    for i=1:length(File)
        Filename{i} = File(i).name;
    end

%% Extract Nodal Result

for j=1:length(Filename)
for i=1:size(coord,1)
    
        % Input**

        fclose('all');
        opf         = fopen(Filename{j});
        keytext     = [' DISPLACEMENT HISTORY OF NODE' sprintf('%11d',coord(i))   ', ANALYSIS SEGMENT   2'];
        keytext2    = [' DISPLACEMENT HISTORY OF NODE' sprintf('%11d',coord(i+1)) ', ANALYSIS SEGMENT   2'];
        keytext3    = [' HISTORY FOR ELEMENT' sprintf('%4d',1)   ' OF' ' ELEMENT' ' GROUP' sprintf('%4d',1)];

        toggle      = true;
        
        % keyword  = finding
        % keyword2 = break
        % type END at the end of result file
        
        keyword     = keytext;
        keyword2    = keytext2;
        
        if i==size(coord,1)
            keyword2 = keytext3;
        end
        

    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                for k=1:3
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    % Extract the data
    % expression matches any character except a whitespace, comma, period, semicolon, or colon
    exp         = '[^ \f\n\r\t\v,;:]*';
    toggle      = true;
    
    
    if i==1
        nstep = 999999;
    end
    if i>1
        nstep = size(nodalr{j}{i-1},1);
    end
    
    for p=1:nstep
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                break
            end
        end
            
            if length(aline)>0
                % Node
                extract            = regexp(aline,exp,'match');
                nodalr{j}{i}(p,1)  = coord(i);
                nodalr{j}{i}(p,2)  = str2double(extract(2));
                nodalr{j}{i}(p,3)  = str2double(extract(3))*10^-2;  %% cm to m
                nodalr{j}{i}(p,4)  = str2double(extract(4))*10^-2;  %% cm to m
                nodalr{j}{i}(p,5)  = str2double(extract(5));
                
            end
    end
    end
end

cd ..
save(['nodalr' Foldername{z} '.mat'],'nodalr')
clear nodalr

end
fclose('all');
