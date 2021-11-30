%%
% Beam/Element Group 2
% Plot Bending Diagram
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

%%
% get beam generation

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

nbeam = length(beamgen);

%% plot beam

for i=1:nbeam
    
    beamgen1       = beamgen(i,2);
    beamgen2       = beamgen(i,3);
    
    [r1,c1]        = find(coord(:,1) == beamgen1 );
    [r2,c2]        = find(coord(:,1) == beamgen2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

fclose('all')

%%
% Get beam load

opdrain     = fopen(inputf);
keyword     = '! LOAD SETS';
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

exp       = '[^ \f\n\r\t\v,;:]*';
beamload  = [];
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
            i              = size(beamload,1)+1;
            extract        = regexp(aline,exp,'match');
            beamload(i,1)  = str2double(extract(1));
            beamload(i,2)  = str2double(extract(2));
            beamload(i,3)  = str2double(extract(3));
            beamload(i,4)  = str2double(extract(4));
            beamload(i,5)  = str2double(extract(5));
            beamload(i,6)  = str2double(extract(6))*10^-2;
            beamload(i,7)  = str2double(extract(7));
            beamload(i,8)  = str2double(extract(8));
            beamload(i,9)  = str2double(extract(9))*10^-2;
    end 
end

fclose('all')

% Moment mid-span of each beam

beammid(:,1)        = beamload(:,1);
beammid(:,2)        = beamload(:,6)*(12/10);

%%

% Get beam load assignment
opdrain     = fopen(inputf);
keyword     = '! LOAD ELEMENT & LOAD SET SCALE FACTORS';
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

exp       = '[^ \f\n\r\t\v,;:]*';
beamasgm  = [];
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
        i              = size(beamasgm,1)+1;
        extract        = regexp(aline,exp,'match');
        beamasgm(i,1)  = str2double(extract(1));
        beamasgm(i,2)  = str2double(extract(2));
        beamasgm(i,3)  = str2double(extract(3));
        beamasgm(i,4)  = str2double(extract(4));
        beamasgm(i,5)  = str2double(extract(5));
    end
end

for i=1:nbeam
    
[r,c]           = find(beamasgm(i,4) == beammid(:,1));
beamasgm(i,6)   = beammid(r,2);

end

fclose('all')

%%

% open file & input

cd OUTPUT
opf         = fopen(resulf);
keyword     = ' ENVELOPES FOR ELEMENT GROUP   2';
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

% Get positive & negative moment

for i=1:nbeam
    
    % Positive Bending Moment Node 1 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    beap{i}(1,1)  = str2double(extract(2));
    beap{i}(1,2)  = str2double(extract(4))*10^-2;
    beap{i}(1,3)  = str2double(extract(6));
    beap{i}(1,4)  = str2double(extract(8));
    
    % Negative Bending Moment Node 1 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    beap{i}(2,1)  = beap{i}(1,1);
    beap{i}(2,2)  = str2double(extract(2))*10^-2;
    beap{i}(2,3)  = str2double(extract(4));
    beap{i}(2,4)  = str2double(extract(6));
    
    
    % Positive Bending Moment Node 2 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    beap{i}(3,1)  = str2double(extract(1));
    beap{i}(3,2)  = str2double(extract(3))*10^-2;
    beap{i}(3,3)  = str2double(extract(5));
    beap{i}(3,4)  = str2double(extract(7));

    % Negative Bending Moment Node 2 (kN-m)
    aline         = fgetl(opf);
    extract       = regexp(aline,exp,'match');
    beap{i}(4,1)  = beap{i}(3,1);
    beap{i}(4,2)  = str2double(extract(2))*10^-2;
    beap{i}(4,3)  = str2double(extract(4));
    beap{i}(4,4)  = str2double(extract(6));

end

fclose('all')

% Plot GRAV

figure(1)
title('GRAV Bending Diagram (kN-m)');
sc  = 200; % scaling of value

for i=1:nbeam
   
    corbea1       = beamgen(i,2);
    corbea2       = beamgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corbea1 );
    [r2,c2]       = find(coord(:,1) == corbea2 );
    
    [r3]          = max( abs(beap{i}(1:2,2)) );
    [r4]          = max( abs(beap{i}(3:4,2)) );    

    % plot bending moment
    plot( [coord(r1,2), coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3)+(r3/sc),coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc),coord(r2,3)], 'k' );
    
    
    
    text( [coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2)]... 
        , [coord(r1,3)+(r3/sc), coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)]...
        , {num2str(round(-r3)), num2str(round(-beamasgm(i,6))), num2str(round(-r4))} );
 
end

%% 
% Plot Enveloped GRAV+SRSS
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
    
    aline          = fgetl(opf);
    extract        = regexp(aline,exp,'match');
    MbeamSRSS(i,1) = str2double(extract(1));
    MbeamSRSS(i,2) = str2double(extract(2));
    MbeamSRSS(i,3) = str2double(extract(3));
    MbeamSRSS(i,4) = str2double(extract(4));
    MbeamSRSS(i,5) = str2double(extract(5));
    MbeamSRSS(i,6) = str2double(extract(6))*10^-2;
    MbeamSRSS(i,7) = str2double(extract(7))*10^-2;
    
    % Find max moment for each beam element
    
    MbeamSRSS(i,8) = max( MbeamSRSS(i,6:7) );
    
end

fclose('all')

%% plot beam (Enveloped)

% figure(2)
% title('Enveloped Bending Diagram (kN-m)');
% 
% for i=1:nbeam
%     
%     beamgen1       = beamgen(i,2);
%     beamgen2       = beamgen(i,3);
%     
%     [r1,c1]        = find(coord(:,1) == beamgen1 );
%     [r2,c2]        = find(coord(:,1) == beamgen2 );
%     
%     hold on
%     % plot column
%     plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
%     
% end
% 
% % Plot Line&Text
% 
% sc  = 200; % scaling of value
% 
% for i=1:nbeam
%    
%     corbea1       = beamgen(i,2);
%     corbea2       = beamgen(i,3);
%     
%     [r1,c1]       = find(coord(:,1) == corbea1 );
%     [r2,c2]       = find(coord(:,1) == corbea2 );
%     
%     [r3]          = max( abs(beap{i}(1:2,2)) );
%     [r4]          = max( abs(beap{i}(3:4,2)) );    
% 
%     % plot bending moment
%     plot( [coord(r1,2), coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2), coord(r2,2)]...
%         , [coord(r1,3), coord(r1,3)+(r3/sc)+(MbeamSRSS(i,8)/sc),coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)+(MbeamSRSS(i,8)/sc),coord(r2,3)], 'k' );
%     
%     
%     text( [coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2)]... 
%         , [coord(r1,3)+(r3/sc)+(MbeamSRSS(i,8)/sc), coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)+(MbeamSRSS(i,8)/sc)]...
%         , {num2str(round(-(r3+MbeamSRSS(i,8)))), num2str(round(-(beamasgm(i,6)))), num2str(round(-(r4+MbeamSRSS(i,8))))} );
%  
% end

%% plot beam GRAV+SRSS

figure(3)
title('GRAV+SRSS Bending Diagram (kN-m)');

for i=1:nbeam
    
    beamgen1       = beamgen(i,2);
    beamgen2       = beamgen(i,3);
    
    [r1,c1]        = find(coord(:,1) == beamgen1 );
    [r2,c2]        = find(coord(:,1) == beamgen2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

% Plot Line&Text

sc  = 200; % scaling of value

for i=1:nbeam
   
    corbea1       = beamgen(i,2);
    corbea2       = beamgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corbea1 );
    [r2,c2]       = find(coord(:,1) == corbea2 );
    
    [r3]          = max( abs(beap{i}(1:2,2)) );
    [r4]          = max( abs(beap{i}(3:4,2)) );    

    % plot bending moment
    plot( [coord(r1,2), coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3)+(r3/sc)+(MbeamSRSS(i,6)/sc),coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)-(MbeamSRSS(i,7)/sc),coord(r2,3)], 'k' );
    
    
    text( [coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2)]... 
        , [coord(r1,3)+(r3/sc)+(MbeamSRSS(i,6)/sc), coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)-(MbeamSRSS(i,7)/sc)]...
        , {num2str(round(-(r3+MbeamSRSS(i,6)))), num2str(round(-(beamasgm(i,6)))), num2str(round(-(r4-MbeamSRSS(i,7))))} );
 
end

%% plot beam GRAV-SRSS

figure(4)
title('GRAV-SRSS Bending Diagram (kN-m)');

for i=1:nbeam
    
    beamgen1       = beamgen(i,2);
    beamgen2       = beamgen(i,3);
    
    [r1,c1]        = find(coord(:,1) == beamgen1 );
    [r2,c2]        = find(coord(:,1) == beamgen2 );
    
    hold on
    % plot column
    plot([coord(r1,2),coord(r2,2)],[coord(r1,3),coord(r2,3)],'-k.','MarkerSize',10);
    
end

% Plot Line&Text

sc  = 200; % scaling of value

for i=1:nbeam
   
    corbea1       = beamgen(i,2);
    corbea2       = beamgen(i,3);
    
    [r1,c1]       = find(coord(:,1) == corbea1 );
    [r2,c2]       = find(coord(:,1) == corbea2 );
    
    [r3]          = max( abs(beap{i}(1:2,2)) );
    [r4]          = max( abs(beap{i}(3:4,2)) );    

    % plot bending moment
    plot( [coord(r1,2), coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2), coord(r2,2)]...
        , [coord(r1,3), coord(r1,3)+(r3/sc)-(MbeamSRSS(i,7)/sc),coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)+(MbeamSRSS(i,6)/sc),coord(r2,3)], 'k' );
    
    
    text( [coord(r1,2), coord(r1,2)+(abs(coord(r2,2)-coord(r1,2))*0.5), coord(r2,2)]... 
        , [coord(r1,3)+(r3/sc)-(MbeamSRSS(i,7)/sc), coord(r1,3)+(beamasgm(i,6)/sc), coord(r2,3)+(r4/sc)+(MbeamSRSS(i,6)/sc)]...
        , {num2str(round(-(r3-MbeamSRSS(i,7)))), num2str(round(-(beamasgm(i,6)))), num2str(round(-(r4+MbeamSRSS(i,6))))} );
 
end
cd ..
