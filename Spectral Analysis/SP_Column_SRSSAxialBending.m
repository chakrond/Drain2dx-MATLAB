
clear all
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

% Input**
fheight     = 4; % floor height 4 m.

%% get column generation

cd ..
opdrain     = fopen(inputf);
keyword     = '! ELEMENT GENERATION: COLUMNS';
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
colgen   = [];
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
            i             = size(colgen,1)+1;
            extract       = regexp(aline,exp,'match');
            colgen(i,1)   = str2double(extract(1));
            colgen(i,2)   = str2double(extract(2));
            colgen(i,3)   = str2double(extract(3));
    end
end

fclose('all')
ncol    = size(colgen,1);


%% extract column bending

cd OUTPUT
g=0;
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
    keyword2    = ' RESULTS FOR ELEMENT GROUP   1';
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                for i=1:5
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    exp    = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:ncol
        
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        McolSRSS{j}(i,1) = str2double(extract(1));
        McolSRSS{j}(i,2) = str2double(extract(2));
        McolSRSS{j}(i,3) = str2double(extract(3));
        McolSRSS{j}(i,4) = str2double(extract(4));
        McolSRSS{j}(i,5) = str2double(extract(5));
        McolSRSS{j}(i,6) = str2double(extract(6))*10^-2;
        McolSRSS{j}(i,7) = str2double(extract(7))*10^-2;
        
        % Find max moment for each beam element 
        McolSRSS{j}(i,8) = max( McolSRSS{j}(i,6:7) );
        
%         % Find Column Base Shear
%         BVcolSRSS{j}(i,1) = (McolSRSS{j}(i,6) + McolSRSS{j}(i,7))/fheight;
        
    end
    
    fclose('all')
    
    
    
    % open file & input
    
    
    opf         = fopen(Filename{j});
    keyword     = ' ENVELOPES FOR ELEMENT GROUP   1';
    toggle      = true;
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                for i=1:6
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    % expression matches any character except a whitespace, comma, period, semicolon, or colon
    exp     = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:ncol
        
        % Positive Bending Moment Node 1 (kN-m)
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        colp{j}{i}(1,1)  = str2double(extract(2));
        colp{j}{i}(1,2)  = str2double(extract(4))*10^-2;
        colp{j}{i}(1,3)  = str2double(extract(6));
        colp{j}{i}(1,4)  = str2double(extract(8));
        
        % Negative Bending Moment Node 1 (kN-m)
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        colp{j}{i}(2,1)  = colp{j}{i}(1,1);
        colp{j}{i}(2,2)  = str2double(extract(2))*10^-2;
        colp{j}{i}(2,3)  = str2double(extract(4));
        colp{j}{i}(2,4)  = str2double(extract(6));
        
        
        % Positive Bending Moment Node 2 (kN-m)
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        colp{j}{i}(3,1)  = str2double(extract(1));
        colp{j}{i}(3,2)  = str2double(extract(3))*10^-2;
        colp{j}{i}(3,3)  = str2double(extract(5));
        colp{j}{i}(3,4)  = str2double(extract(7));
        
        % Negative Bending Moment Node 2 (kN-m)
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        colp{j}{i}(4,1)  = colp{j}{i}(3,1);
        colp{j}{i}(4,2)  = str2double(extract(2))*10^-2;
        colp{j}{i}(4,3)  = str2double(extract(4));
        colp{j}{i}(4,4)  = str2double(extract(6));
                
    end
    
    % For Column element No.4 (critical)
    g               = g+1;
    MaxMCol(g)      = max( colp{j}{3}(:,2) )+McolSRSS{j}(3,8);
    MaxNCol(g)      = max( colp{j}{3}(:,4) )+McolSRSS{j}(3,5);
     
    fclose('all');
end

cd ..
save('MaxFCol.mat','MaxMCol','MaxNCol')


