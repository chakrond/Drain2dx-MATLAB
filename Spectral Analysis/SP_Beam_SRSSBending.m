
clc
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

%% get beam generation

cd ..
opdrain     = fopen(inputf);
keyword     = '! ELEMENT GENERATION: BEAMS';
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
beamgen  = [];
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
            i               = size(beamgen,1)+1;
            extract         = regexp(aline,exp,'match');
            beamgen(i,1)   = str2double(extract(1));
            beamgen(i,2)   = str2double(extract(2));
            beamgen(i,3)   = str2double(extract(3));
    end 
end

fclose('all')

nbeam = size(beamgen,1);

%% extract beam bending

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
    keyword    = ' RESULTS FOR ELEMENT GROUP   2';
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                for i=1:5
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
        
    end
    
    exp    = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:nbeam
        
        aline             = fgetl(opf);
        extract           = regexp(aline,exp,'match');
        MbeamSRSS{j}(i,1) = str2double(extract(1));
        MbeamSRSS{j}(i,2) = str2double(extract(2));
        MbeamSRSS{j}(i,3) = str2double(extract(3));
        MbeamSRSS{j}(i,4) = str2double(extract(4));
        MbeamSRSS{j}(i,5) = str2double(extract(5));
        MbeamSRSS{j}(i,6) = str2double(extract(6))*10^-2;
        MbeamSRSS{j}(i,7) = str2double(extract(7))*10^-2;
        
        % Find max moment for each beam element
        
        MaxMbeam{j}(i,1) = max( MbeamSRSS{j}(i,6:7) );
        
    end
    fclose('all')
end

% save file
cd ..
save('MaxMbeam.mat','MaxMbeam')
