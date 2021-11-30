%%
fclose('all')

% input filename
inputf      = 'drain.inp';

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


    % input**
    k       =  1; % element group

%% Extract Nodal Result

for j=1:length(Filename)
for i=1:ncol
        
        % Input**
        
        fclose('all');
        opf         = fopen(Filename{j});
        keytext     = [' HISTORY FOR ELEMENT' sprintf('%4d',i)   ' OF' ' ELEMENT' ' GROUP' sprintf('%4d',k)];
        keytext2    = [' HISTORY FOR ELEMENT' sprintf('%4d',i+1) ' OF' ' ELEMENT' ' GROUP' sprintf('%4d',k)];
        keytext3    = [' HISTORY FOR ELEMENT' sprintf('%4d',1)   ' OF' ' ELEMENT' ' GROUP' sprintf('%4d',k+1)];
        
        toggle      = true;
        
        % keyword  = finding
        % keyword2 = break
        
        keyword     = keytext;
        keyword2    = keytext2;
        
        if i==ncol
            keyword2 = keytext3;
        end

        
        while toggle
            
            % get a line of data
            aline   = fgetl(opf);
            
            if length(aline)>=length(char(keyword))
                if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                    for q=1:2
                        aline   = fgetl(opf);
                    end
                    exp         = '[^ \f\n\r\t\v,;:]*';
                    extract     = regexp(aline,exp,'match');
                    % Node 1
                    elemC{j}{i}{1}(1,3)  = str2double(extract(end-1));
                    % Node 2
                    elemC{j}{i}{2}(1,3)  = str2double(extract(end));
                    for q=1:4
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
            nstep = size(elemC{j}{i-1}{1},1);
        end
        
        for p=1:nstep
            
            aline            = fgetl(opf);
            
            if length(aline)>=length(char(keyword2))
                if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                    break
                end
                
                if length(aline)>0
                    % Node 1
                    extract              = regexp(aline,exp,'match');
                    elemC{j}{i}{1}(p,1)  = str2double(extract(1));
                    elemC{j}{i}{1}(p,2)  = str2double(extract(2));
                    elemC{j}{i}{1}(p,3)  = elemC{j}{i}{1}(1,3);
                    elemC{j}{i}{1}(p,4)  = str2double(extract(4));
                    elemC{j}{i}{1}(p,5)  = str2double(extract(5))*10^-2;
                    elemC{j}{i}{1}(p,6)  = str2double(extract(6));
                    elemC{j}{i}{1}(p,7)  = str2double(extract(7));
                    elemC{j}{i}{1}(p,8)  = str2double(extract(8));
                    elemC{j}{i}{1}(p,9)  = str2double(extract(9));
                    elemC{j}{i}{1}(p,10) = str2double(extract(10));
                    
                end
            end 
            
            aline            = fgetl(opf);
            
            if length(aline)>=length(char(keyword2))
                if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                    break
                end
                
                % Node 2
                extract              = regexp(aline,exp,'match');
                elemC{j}{i}{2}(p,1)  = elemC{j}{i}{1}(p,1);
                elemC{j}{i}{2}(p,2)  = elemC{j}{i}{1}(p,2);
                elemC{j}{i}{2}(p,3)  = elemC{j}{i}{2}(1,3);
                elemC{j}{i}{2}(p,4)  = str2double(extract(2));
                elemC{j}{i}{2}(p,5)  = str2double(extract(3))*10^-2;
                elemC{j}{i}{2}(p,6)  = str2double(extract(4));
                elemC{j}{i}{2}(p,7)  = str2double(extract(5));
                elemC{j}{i}{2}(p,8)  = str2double(extract(6));
                elemC{j}{i}{2}(p,9)  = str2double(extract(7));
                elemC{j}{i}{2}(p,10) = str2double(extract(8));
                
            end 
        end
end
end

cd ..
save(['elemC' Foldername{z} '.mat'],'elemC')
clear elemC

end
fclose('all');
