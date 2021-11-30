
%% 

% input filename
inputf      = 'drain.inp';

% change directory
cd OUTPUT

% create result filename
File        = dir('*.OUT');
for i=1:length(File)
    Filename{i} = File(i).name;
end


%% extract modal info

for j=1:length(Filename)
    
    % extract nodal mass
    
    cd ..
    opdrain    = fopen(inputf);
    toggle     = true;
    keyword    = '! NODAL MASS';
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
    Nmass  = [];
    
    for i=1:9999
        
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
            k             = size(Nmass,1)+1;
            extract       = regexp(aline,exp,'match');
            Nmass(k,1)    = str2double(extract(3));
            Nmass(k,2)    = str2double(extract(4));
            Nmass(k,3)    = str2double(extract(5));
            Nmass(k,4)    = str2double(extract(6));
            Nmass(k,5)    = (((Nmass(k,3)-Nmass(k,2))/Nmass(k,4))+1)*Nmass(k,1)*981*(10^3)*(1/9.81); % kg
            % Total mass
            tmass         = sum(Nmass(:,5));
            
        end
    end
    
    fclose('all')
    
      
    % get period
    cd OUTPUT
    opf         = fopen(Filename{j});
    toggle      = true;
    keyword2    = ' MODE SHAPES AND PERIODS';
    
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
    aline            = fgetl(opf);
    extract          = regexp(aline,exp,'match');
    % only 5 modes
    MPeriod{j}(1) = str2double(extract(2));
    MPeriod{j}(2) = str2double(extract(3));
    MPeriod{j}(3) = str2double(extract(4));
    MPeriod{j}(4) = str2double(extract(5));
    MPeriod{j}(5) = str2double(extract(6));
    
    fclose('all')
    
    
    % get effective modal mass
    
    opf         = fopen(Filename{j});
    toggle      = true;
    keyword2    = ' EFFECTIVE MODAL MASS AS A FRACTION OF TOTAL MASS';
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                for i=1:3
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    exp    = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:5  % only 5 modes (one per line)
        
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        MEFFMM{j}(i,1)   = str2double(extract(2));  
        
    end
    
    fclose('all')
    

    % get participation factor
    
    opf         = fopen(Filename{j});
    toggle      = true;
    keyword2    = ' PARTICIPATION FACTORS FOR MASS NORMALIZED MODE SHAPE';
    
    while toggle
        
        % get a line of data
        aline   = fgetl(opf);
        
        if length(aline)>=length(char(keyword2))
            if length(aline)>0 && strcmpi(aline(1:length(char(keyword2))),keyword2)
                for i=1:3
                    aline   = fgetl(opf);
                end
                toggle    = false;
            end
        end
    end
    
    exp    = '[^ \f\n\r\t\v,;:]*';
    
    for i=1:5  % only 5 modes (one per line)
        
        aline            = fgetl(opf);
        extract          = regexp(aline,exp,'match');
        MPPF{j}(i,1)     = str2double(extract(2));  
        
    end
    
    fclose('all')
    
 
end

% save file
cd ..
save('Minfo.mat','tmass','MEFFMM','MPPF','MPeriod')