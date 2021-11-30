
clear all
fclose('all')

% filename
inputf  = 'drain.inp';

% open file & text scan
load SecProp.mat
nUB         = nnz(~isnan(str2double(UB{:,end}))); % number of info
nPFC        = nnz(~isnan(str2double(PFC{:,end})));
[idUB,~]    = find(~isnan(str2double(UB{:,end}))); % find first line of info
[idPFC,~]   = find(~isnan(str2double(PFC{:,end}))); 
rUB         = idUB(idUB==56)-1;  % from row 56, section ?? 
rPFC        = idPFC(1)-1; % pior to table first line info from row 10 (section 1)
fid         = fopen(inputf);
C           = textscan(fid,'%s','delimiter','\n','whitespace','');
% backup file
time        = char(datetime('now'));
copyfile('drain.inp',['BACKUP_INPUT_' time(1:14) time(16:17) time(19:20)])
movefile BACKUP_INPUT* BACKUP_INPUT

save ('nSectionInfo.mat','nPFC','nUB','rUB','rPFC');

for k=1:10
    
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
        BS              = num2str(1,'%05d');
        E               = num2str(21000,'%010d');
        k2              = num2str(0.05,'%010.2f');
        Ab              = num2str(str2double(UB{:,end}(rUB+k)),'%010.1f');
        I               = num2str(str2double(UB{:,18}(rUB+k)),'%010d');
        kii             = num2str(4,'%05d');
        kjj             = num2str(4,'%05d');
        kij             = num2str(2,'%05d');
        As              = num2str(str2double(UB{:,5}(rUB+k))*str2double(UB{:,7}(rUB+k))*10^-2,'%010.2f');
        mu              = num2str(0.30,'%05.2f');
        osh             = num2str(0.01,'%05.2f');
        beinp           = {[BS E k2 Ab I kii kjj kij As mu osh]};
        C{1}(idinp)     = beinp;
    
    
    for j=1:nPFC
        
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
        
        
        resuid          = [num2str(k,'BM%02d') num2str(j,'D%03d')];
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
        BS              = num2str(1,'%05d');
        E               = num2str(21000,'%010d');
        k2              = num2str(0.05,'%010.2f');
        Ab              = num2str(str2double(PFC{:,end}(rPFC+j)),'%010.1f');
        Syt             = num2str(999999,'%010d');
        Syc             = num2str(999999,'%010d');
        osh             = num2str(0.01,'%010.2f');
        brinp           = {[BS E k2 Ab Syt Syc '    0' osh]};
        C{1}(idinp)     = brinp;
        
        % save input & run
        
        % print new file
        fop     = fopen(inputf,'w'); % Open the file
        for h=1:numel(C{1,1})
            fprintf(fop,'%s\r\n',C{1,1}{h,1});
        end
        fclose(fop);
        system('D2Das.exe');
        
    end
end

movefile BM* OUTPUT
save ('ExtrSecProp.mat','hb','Ib','Wpb','Abr')

%% Run Extraction Files
run SP_Beam_SRSSBending.m
run SP_Brace_SRSSAxial.m
run SP_Modal_BShear.m
run SP_Column_SRSSAxialBending.m



