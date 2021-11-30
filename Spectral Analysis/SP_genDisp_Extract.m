
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

%% Count gendisp
cd ..

fid         = fopen(inputf);
C           = textscan(fid,'%s','delimiter','\n','whitespace','');
keyw        = '*GENDISP';

d=0;
for i=1:length(C{1})
    
    if length(C{1}{i})<0 || length(C{1}{i})<length(keyw)
        continue
    end
    if C{1}{i}(1:8) == keyw
        d         = d+1;
        idxC(d)   = i;
    end
end

ngendis     = length(idxC);

%% get genDisp
cd OUTPUT
for j=1:length(Filename)
    
    % GRAV genDisp
    opf         = fopen(Filename{j});
    keyword     = ' ENVELOPES FOR GENERALIZED DISPLACEMENTS';
    keyword2    = '!END';
    toggle      = true;
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                for k=1:4
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
    
    for p=1:ngendis
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                break
            end
            
            if length(aline)>0
                
                extract         = regexp(aline,exp,'match');
                gendisGRAV{j}(p,1)  = str2double(extract(2))*10^-2;
                
            end
        end
    end
    fclose('all');
    
    
    % SRSS genDisp
    opf         = fopen(Filename{j});
    keyword     = ' RESPONSE SPECTRUM ANALYSIS - S.R.S.S. RESPONSE';
    toggle      = true;
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                toggle    = false;
            end
        end
        
    end    
    

    keyword     = ' GENERALIZED DISPLACEMENTS';
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
    
    for p=1:ngendis
        
        aline            = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                break
            end
            
            if length(aline)>0
                
                extract         = regexp(aline,exp,'match');
                gendisSRSS{j}(p,1)  = str2double(extract(2))*10^-2;
                
            end
        end
    end
    fclose('all');    
end

cd ..
% save file
save ('genDisp.mat','gendisGRAV','gendisSRSS')


