run OMNL_EQREC_Formatting.m

clear all
fclose('all');

% select simulation
Bid = 7;
Did = 7;
save('SelectedSim.mat','Bid','Did');

% read record filename
% create record filename
Filerec       = dir('*.dat');
for i=1:length(Filerec)
    Recname{i} = Filerec(i).name;
end
load EQInfo.mat


% filename
inputf  = 'drain.inp';

% open file & text scan
load SecProp.mat
nUB         = nnz(~isnan(str2double(UB{:,end}))); % number of info
nPFC        = nnz(~isnan(str2double(PFC{:,end})));
[idUB,~]    = find(~isnan(str2double(UB{:,end}))); % find first line of info
[idPFC,~]   = find(~isnan(str2double(PFC{:,end}))); 
rUB         = idUB(idUB==56)-1;  % from row 56 section ?? 
rPFC        = idPFC(1)-1; % pior to table first line info from row 10 (section 1)
fid         = fopen(inputf);
C           = textscan(fid,'%s','delimiter','\n','whitespace','');
% backup file
time        = char(datetime('now'));
copyfile('drain.inp',['BACKUP_INPUT_' time(1:14) time(16:17) time(19:20)])
movefile BACKUP_INPUT* _BACKUP_INPUT

save ('nSectionInfo.mat','nPFC','nUB','rUB','rPFC');

% Steel Tensile Str (Fy)
Fy          = 325; % Mpa

for s=1:length(Bid)
% change EQ record
for q=1:length(Recname)
for k=Bid(s) %:nUB

    
    % dynamic UB
        
        keyword = {'! BEAM DYM PR 1'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end

        % Section Properties Extract
        hb(k)          = str2double(UB{:,5}(rUB+k));
        Ib(k)          = str2double(UB{:,18}(rUB+k));
        Wpb(k)         = str2double(UB{:,24}(rUB+k));
        
        % Section Properties For Input
        BS              = sprintf('%5d',1);
        E               = sprintf('%10.1f',21000);
        k2              = sprintf('%10.2f',0.05);
        Ab              = sprintf('%10.1f',str2double(UB{:,end}(rUB+k)));
        I               = sprintf('%10.1f',str2double(UB{:,18}(rUB+k)));
        kii             = sprintf('%5d',4);
        kjj             = sprintf('%5d',4);
        kij             = sprintf('%5d',2);
        As              = sprintf('%10.2f',str2double(UB{:,5}(rUB+k))*str2double(UB{:,7}(rUB+k))*10^-2);
        mu              = sprintf('%5.2f',0.30);
        osh             = sprintf('%5.2f',0.01);
        beinp           = {[BS E k2 Ab I kii kjj kij As mu osh]};
        C{1}(idinp)     = beinp;
    
    
        keyword = {'! BEAM DYM PR 2'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end
        
        iY              = sprintf('%5d',1);
        typ             = sprintf('%5d',1);
        Myp             = sprintf('%10.1f',str2double(UB{:,24}(rUB+k))*10^-6*Fy*10^3*100); % kN-cm
        Myn             = sprintf('%10.1f',str2double(Myp));
        beinp           = {[iY typ Myp Myn]};
        C{1}(idinp)     = beinp;        
           
        
    % inner loop
        
    for j=Did(s)
        
        % dynamic filename
        keyword = {'! OUTPUT NAME:'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end
        
        % j=1;
        resuid          = [num2str(q,'OMR%03d') num2str(k,'%01d') num2str(j,'%01d')];
        fidinp          = {['  ' resuid '         0 1 0 1']};
        C{1}(idinp)     = fidinp;
        
        % dynamic PFC
        
        keyword = {'! BRACE DYM PR 1'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end
        
        % Section Properties Extract
        Abr(j)          = str2double(PFC{:,end}(rPFC+j));
        
        % Section Properties For Input
        BS              = sprintf('%5d',1);
        E               = sprintf('%10d',21000);
        k2              = sprintf('%10.2f',0.05);
        Ab              = sprintf('%10.1f',str2double(PFC{:,end}(rPFC+j)));
        Syt             = sprintf('%10.1f',Fy*10^-1); % Mpa to kN/cm^2
        Syc             = sprintf('%10.1f',Fy*10^-1); % Mpa to kN/cm^2
        osh             = sprintf('%10.2f',0.01);
        bc              = num2str(1); % buckling code
        brinp           = {[BS E k2 Ab Syt Syc '    ' bc osh]};
        C{1}(idinp)     = brinp;
        

        % dynamic record file
        
        keyword = {'! ACCREC DYM PR 1'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end        
        
        % ACCREC input
        Acname          = ' ACCR';
        Recfile         = sprintf('%+15s',Recname{q});
        DataF           = sprintf('%+20s','(F10.0)');
        Rectit          = sprintf('%+40s',Recname{q}(1:end-4));
        brinp           = {[Acname Recfile DataF Rectit]};
        C{1}(idinp)     = brinp;
        
        
        keyword = {'! ACCREC DYM PR 2'};
        sformat = 2;
        
        for i=1:999999
            
            if  length(C{1}{i})>=length(char(keyword)) && strcmpi(C{1}{i}(1:length(char(keyword))),keyword)
                id = i;
                idinp = id+sformat;
                break
            end
        end
        
        % ACCREC file info
        NVAL            = sprintf('%5d',npts{q});
        NVLIN           = sprintf('%5d',1);
        KODE            = num2str(0);
        PRTC            = num2str(1);
        TSCALE          = sprintf('%10.5f',1);
        ASCALE          = sprintf('%10.5f',1);
        DTIN            = sprintf('%10.5f',DT{q});
        TSTART          = sprintf('%10.5f',0);
        brinp           = {[NVAL NVLIN '    ' KODE '    ' PRTC TSCALE ASCALE DTIN TSTART]};
        C{1}(idinp)     = brinp;        
        

        % save input & run
        
        % print new file
        fop     = fopen(inputf,'w'); % Open the file
        for h=1:numel(C{1,1})
            fprintf(fop,'%s\r\n',C{1,1}{h,1});
        end
        
        fclose(fop);
        system('D2Das.exe');
        
        % move files
        fname = ['OMR' resuid(4:6)];
        mkdir(fname)
        movefile([resuid '*'],fname)
        movefile('enr.out',fname)
        
    end
end
end
end

save ('ExtrSecProp.mat','hb','Ib','Wpb','Abr')



%% Run Extraction Files
run OMNL_Extract_Energy.m




