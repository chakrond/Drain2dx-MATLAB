%% General
% get coordinate

% input filename
inputf      = 'drain.inp';

opdrain    = fopen(inputf);
toggle     = true;
keyword    = '*NODECOORDS';
keyword2   = '!END';

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

exp    = '[^ \f\n\r\t\v,;:]*';
coord  = [];
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

    if strcmpi(aline(1),'C') == true
            i             = size(coord,1)+1;
            extract       = regexp(aline,exp,'match');
            coord(i,1)    = str2double(extract(2));
            coord(i,2)    = str2double(extract(3))*10^-2;
            coord(i,3)    = str2double(extract(4))*10^-2;
    end 
end

% logic1  = coord(coord(:,1)~=0,:);

fclose('all')

%% Get beam generation

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

%% Get column generation

opdrain     = fopen(inputf);
keyword     = '! ELEMENT GENERATION: COLUMNS';
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

%% save file
save('NL_ElemGen.mat')

