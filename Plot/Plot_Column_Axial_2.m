%%
% Column/Element Group 1
% Plot Enveloped Axial Diagram
% Created by Chakron Dechkrut
%%

% change directory
cd OUTPUT

clear all
fclose('all')

% filename
inputf     = 'drain.inp';
resulf     = 'BE01BR01.out';

%% General
% get coordinate

cd ..
opdrain    = fopen(inputf);
toggle     = true;
keyword    = '*NODECOORDS';
keyword2   = '!END';
cinfo      = 4; % 2 for bendind, 3 for shear, 4 for axial
SRSScinfo  = 5; % 8 for bending, 5 for axial


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


%% Plot Bending Momoent in Column

% get column generation

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

ncol = length(colgen);

%%
% open file & input

cd OUTPUT
opf         = fopen(resulf);
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
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    colp{i}(1,1)  = str2double(extract(2));
    colp{i}(1,2)  = str2double(extract(4))*10^-2;
    colp{i}(1,3)  = str2double(extract(6));
    colp{i}(1,4)  = str2double(extract(8));
    
    % Negative Bending Moment Node 1 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    colp{i}(2,1)  = colp{i}(1,1);
    colp{i}(2,2)  = str2double(extract(2))*10^-2;
    colp{i}(2,3)  = str2double(extract(4));
    colp{i}(2,4)  = str2double(extract(6));
    
    
    % Positive Bending Moment Node 2 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    colp{i}(3,1)  = str2double(extract(1));
    colp{i}(3,2)  = str2double(extract(3))*10^-2;
    colp{i}(3,3)  = str2double(extract(5));
    colp{i}(3,4)  = str2double(extract(7));

    % Negative Bending Moment Node 2 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    colp{i}(4,1)  = colp{i}(3,1);
    colp{i}(4,2)  = str2double(extract(2))*10^-2;
    colp{i}(4,3)  = str2double(extract(4));
    colp{i}(4,4)  = str2double(extract(6));
    
end

fclose('all');

%%

% plot column

figure(1)
title('GRAV Axial Diagram (kN)');
sc      = 500; % scaling of value

for i=1:ncol
    
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

% Plot Line&Text

for i=1:ncol
   
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
%     [r3,c3]       = find(colp{i}(:,1) == corcol1 );
%     [r4,c4]       = find(colp{i}(:,1) == corcol2 );    

    [r3]          = max( abs(colp{i}(1:2,cinfo)) );
    [r4]          = max( abs(colp{i}(3:4,cinfo)) );
    
    
    % plot axial force
    
    plot( [coord(r1,2), coord(r1,2)+(r3/sc), coord(r2,2)+(r4/sc), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3), coord(r2,3),coord(r2,3)], 'k' );
    
    
    text( coord(r1,2)+(r3/sc)... 
        , coord(r1,3)...
        , {num2str(round(r3))} );
    
end

%% 
% Plot GRAV+SRSS
% open file & input

opf         = fopen(resulf);
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
    
    aline          = fgetl(opf);
    extract        = regexp(aline,exp,'match');
    McolSRSS(i,1) = str2double(extract(1));
    McolSRSS(i,2) = str2double(extract(2));
    McolSRSS(i,3) = str2double(extract(3));
    McolSRSS(i,4) = str2double(extract(4));
    McolSRSS(i,5) = str2double(extract(5));
    McolSRSS(i,6) = str2double(extract(6))*10^-2;
    McolSRSS(i,7) = str2double(extract(7))*10^-2;
    
    % Find max moment for each beam element
    
    McolSRSS(i,8) = max( McolSRSS(i,6:7) );
    
    
    
end

fclose('all')

% plot column

figure(2)
title('GRAV+SRSS Axial Diagram (kN)');

for i=1:ncol
    
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

% Plot Line&Text

sc  = 500; % scaling of value

for i=1:ncol
   
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    [r3]          = max( abs(colp{i}(1:2,cinfo)) );
    [r4]          = max( abs(colp{i}(3:4,cinfo)) );    

    % plot axial
    plot( [coord(r1,2), coord(r1,2)+(r3/sc)+(McolSRSS(i,SRSScinfo)/sc), coord(r2,2)+(r4/sc)+(McolSRSS(i,SRSScinfo)/sc), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3), coord(r2,3),coord(r2,3)], 'k' );
    
    
    text( coord(r1,2)+(r3/sc)+(McolSRSS(i,SRSScinfo)/sc)... 
        , coord(r1,3) ...
        , {num2str(round(r3+McolSRSS(i,SRSScinfo)))} );
 
end

%% plot column GRAV-SRSS

figure(3)
title('GRAV-SRSS Axial Diagram (kN)');

for i=1:ncol
    
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

% Plot Line&Text

sc  = 500; % scaling of value

for i=1:ncol
   
    corcol1       = colgen(i,2);
    corcol2       = colgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corcol1 );
    [r2,c2]       = find(coord(:,1) == corcol2 );
    
    [r3]          = max( abs(colp{i}(1:2,cinfo)) );
    [r4]          = max( abs(colp{i}(3:4,cinfo)) );    

    % plot axial
    plot( [coord(r1,2), coord(r1,2)+(r3/sc)-(McolSRSS(i,SRSScinfo)/sc), coord(r2,2)+(r4/sc)-(McolSRSS(i,SRSScinfo)/sc), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3), coord(r2,3),coord(r2,3)], 'k' );
    
    
    text( coord(r1,2)+(r3/sc)-(McolSRSS(i,SRSScinfo)/sc)... 
        , coord(r1,3) ...
        , {num2str(round(r3-McolSRSS(i,SRSScinfo)))} );
 
end
cd ..

