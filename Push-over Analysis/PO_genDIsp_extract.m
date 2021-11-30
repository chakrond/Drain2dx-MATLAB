
clear all
fclose('all');

% input filename
inputf      = 'drain.inp';

% change directory
cd OUTPUT

% create result filename
File        = dir('*.OUT');
for i=1:length(File)
    Filename{i} = File(i).name;
end
    

%% Get Pushover input

cd ..

% get pushover load
opdrain    = fopen(inputf);
toggle     = true;
keyword    = '! PUSHOVER LOAD';
keyword2   = '!END';

while toggle
    
    % get a line of data
    aline   = fgetl(opdrain);
    
    
    if length(aline)>=length(char(keyword))
        if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
       toggle    = false;   
        end
    end
end

exp    = '[^ \f\n\r\t\v,;:]*';
POload = [];
for j=1:9999
    
    aline         = fgetl(opdrain);
    
    if length(aline)>=length(char(keyword2))
        if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
        break   
        end
    end
    
    if strcmpi(aline(1),'!') == true
        continue
    end

    if strcmpi(aline(1),'S') == true
            i              = size(POload,1)+1;
            extract        = regexp(aline,exp,'match');
            POload(i,1)    = str2double(extract(2));
    end 
end

fclose('all')


% get step and load scale factor
opdrain     = fopen(inputf);
keyword     = '*STAT';
keyword2    = '!END';
toggle      = true;

while toggle
    
    % get a line of data
    aline   = fgetl(opdrain);
    
%     if strcmpi(aline(1),'!') == true
%         continue
%     end
    
    if length(aline)>=length(char(keyword))
        if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
       toggle    = false;   
        end
    end
end

exp      = '[^ \f\n\r\t\v,;:]*';
scalef   = [];
tstp     = [];

for j=1:9999
    
    aline         = fgetl(opdrain);
    
    if length(aline)>=length(char(keyword2))
        if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
        break   
        end
    end
    
    if strcmpi(aline(1),'!') == true
        continue
    end

    if strcmpi(aline(1),'N') == true
%             i              = size(scalef,1)+1;
            extract        = regexp(aline,exp,'match');
            scalef         = str2double(extract(3));  
    end 
    
    if strcmpi(aline(1),'L') == true
%             i              = size(tstp,1)+1;
            extract        = regexp(aline,exp,'match');
            tstp           = str2double(extract(2)); 
            nstp           = 1/tstp;

    end 
    
    
end

fclose('all')


%% get genDisp

cd OUTPUT

for j=1:length(Filename)
    
    opf         = fopen(Filename{j});
    keyword     = ' HISTORY FOR GENERALIZED DISPLACEMENTS, ANALYSIS SEGMENT   2';
    keyword2    = '!END';
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
    
    for p=1:nstp
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                break
            end
            
            if length(aline)>0
                
                extract         = regexp(aline,exp,'match');
                gendis{j}(p,1)  = str2double(extract(1));
                gendis{j}(p,2)  = str2double(extract(2))*scalef;
                gendis{j}(p,3)  = str2double(extract(3))*10^-2; % roof displacement cm to m
                gendis{j}(p,4)  = str2double(extract(4)); % Node 2030 rotation
%                 gendis{j}(p,5)  = str2double(extract(5)); % node 2040 rotation
                
            end
        end
    end
    fclose('all');
end


% save file
cd ..
save('gendis.mat','gendis','tstp','nstp','scalef','POload')
