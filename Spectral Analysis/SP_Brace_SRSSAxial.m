
clc
fclose('all')

% input filename
inputf      = 'drain.inp';

% change directory
cd OUTPUT

% create result filename
File        = dir('*.OUT');
for i=1:length(File)
    Filename{i} = File(i).name;
end

%% get brace generation

cd ..
opdrain     = fopen(inputf);
keyword     = '! ELEMENT GENERATION: BRACES';
keyword2    = '!END';
toggle      = true;

while toggle
    
    % get a line of data
    aline   = fgetl(opdrain);
    
    if length(aline)>=length(char(keyword))
        if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
            toggle    = false;
        end
    end
end

exp      = '[^ \f\n\r\t\v,;:]*';
bragen   = [];
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
    
    if str2double(aline(1:5)) > 0
        i             = size(bragen,1)+1;
        extract       = regexp(aline,exp,'match');
        bragen(i,1)   = str2double(extract(1));
        bragen(i,2)   = str2double(extract(2));
        bragen(i,3)   = str2double(extract(3));
    end
end

fclose('all')

nbra = size(bragen,1);

%% extract brace axial force

cd OUTPUT
for j=1:length(Filename)
    
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
    
    toggle      = true;
    keyword2    = ' RESULTS FOR ELEMENT GROUP   3';
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                for i=1:4
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    exp    = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:nbra
        
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        NbraSRSS{j}(i,1) = str2double(extract(1));
        NbraSRSS{j}(i,2) = str2double(extract(2));
        NbraSRSS{j}(i,3) = str2double(extract(3));
        
    end 
    fclose('all')   
end

% save file
cd ..
save('NbraSRSS.mat','NbraSRSS')
