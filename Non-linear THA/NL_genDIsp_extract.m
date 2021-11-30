%%
fclose('all')

% input filename
inputf      = 'drain.inp';

% create folder name
Folder      = dir('RX*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end


%% get genDisp
for z=1:length(Foldername)
    
    cd(Foldername{z})
    
    File        = dir('*.OUT');
    for i=1:length(File)
        Filename{i} = File(i).name;
    end

for j=1:length(Filename)
    
    opf         = fopen(Filename{j});
    keyword     = ' HISTORY FOR GENERALIZED DISPLACEMENTS, ANALYSIS SEGMENT   2';
    keyword2    = ' HISTORY FOR GENERALIZED DISPLACEMENTS, ANALYSIS SEGMENT   2';
    keyword3    = 'END';
    toggle      = true;
    
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
    
  
    % gendisp section 1
    
    for p=1:999999
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                break
            end
            
            if length(aline)>0
                
                extract         = regexp(aline,exp,'match');
                gendis{j}(p,1)  = str2double(extract(1)); % step
                gendis{j}(p,2)  = str2double(extract(2)); % time
                gendis{j}(p,3)  = str2double(extract(3))*10^-2; % 1st drift cm to m
                gendis{j}(p,4)  = str2double(extract(4))*10^-2; % 2nd drift cm to m
                gendis{j}(p,5)  = str2double(extract(5))*10^-2; % 3rd drift cm to m
                gendis{j}(p,6)  = str2double(extract(6))*10^-2; % 4th drift cm to m
                gendis{j}(p,7)  = str2double(extract(7))*10^-2; % 5th drift cm to m
                gendis{j}(p,8)  = str2double(extract(8))*10^-2; % 6th drift cm to m
                
                % max column is 6 gendisp
                
            end 
        end
    end
    
    % gendisp section 2
    
    for k=1:3
        aline   = fgetl(opf);
    end
    
    for p=1:999999
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword3))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword3))),keyword3)
                break
            end
            
            if length(aline)>0
                
                extract         = regexp(aline,exp,'match');
                gendis{j}(p,9)  = str2double(extract(3)); % node 2030 rotation
                
            end 
        end
    end
    
     fclose('all');
    
end

cd ..
save(['genDisp' Foldername{z} '.mat'],'gendis')
clear gendis

end
