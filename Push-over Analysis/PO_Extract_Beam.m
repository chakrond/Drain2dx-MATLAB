
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

%% get step and load scale factor
cd ..
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

%% Extract Nodal Result

cd OUTPUT
% 1 element group 2 segment 2

for j=1:length(File)
    nele =1; % only one element
    for i=1:nele
        
        % Input**
        
        fclose('all');
        opf         = fopen(Filename{j});
        keyword     = {' HISTORY FOR ELEMENT   3 OF ELEMENT GROUP   2, ANALYSIS SEGMENT   2'};
        toggle      = true;
        
        % keyword  = finding
        % keyword2 = break
        % type END at the end of result file
        
        while toggle
            
            % get a line of data
            aline   = fgetl(opf);
            
            if length(aline)>=length(char(keyword))
                if length(aline)>0 && strcmpi(aline(1:length(char(keyword))),keyword)
                    for k=1:2
                        aline   = fgetl(opf);
                    end
                    exp         = '[^ \f\n\r\t\v,;:]*';
                    extract     = regexp(aline,exp,'match');
                    % Node 1
                    elemB{j}{i}{1}(1,3)  = str2double(extract(8));
                    % Node 2
                    elemB{j}{i}{2}(1,3)  = str2double(extract(9));
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
        
        for p=1:nstp
            
            aline            = fgetl(opf);
            
            
            if length(aline)>0
                % Node 1
                extract              = regexp(aline,exp,'match');
                elemB{j}{i}{1}(p,1)  = str2double(extract(1));
                elemB{j}{i}{1}(p,2)  = str2double(extract(2))*scalef;
                elemB{j}{i}{1}(p,3)  = elemB{j}{i}{1}(1,3);
                elemB{j}{i}{1}(p,4)  = str2double(extract(4));
                elemB{j}{i}{1}(p,5)  = str2double(extract(5))*10^-2; % kN-cm to kN-m
                elemB{j}{i}{1}(p,6)  = str2double(extract(6));
                elemB{j}{i}{1}(p,7)  = str2double(extract(7));
                elemB{j}{i}{1}(p,8)  = str2double(extract(8));
                elemB{j}{i}{1}(p,9)  = str2double(extract(9));
                elemB{j}{i}{1}(p,10) = str2double(extract(10));
                
            end
            
            
            
            aline            = fgetl(opf);
            
            % Node 2
            extract              = regexp(aline,exp,'match');
            elemB{j}{i}{2}(p,1)  = elemB{j}{i}{1}(p,1);
            elemB{j}{i}{2}(p,2)  = elemB{j}{i}{1}(p,2);
            elemB{j}{i}{2}(p,3)  = elemB{j}{i}{2}(1,3);
            elemB{j}{i}{2}(p,4)  = str2double(extract(2));
            elemB{j}{i}{2}(p,5)  = str2double(extract(3))*10^-2; % kN-cm to kN-m
            elemB{j}{i}{2}(p,6)  = str2double(extract(4));
            elemB{j}{i}{2}(p,7)  = str2double(extract(5));
            elemB{j}{i}{2}(p,8)  = str2double(extract(6));
            elemB{j}{i}{2}(p,9)  = str2double(extract(7));
            elemB{j}{i}{2}(p,10) = str2double(extract(8));
            
        end
    end
    fclose('all');
end
cd ..

save('elemB.mat','elemB')