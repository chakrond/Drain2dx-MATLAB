% change directory
cd EQREC

% inputs an acceleration 
clc, clear
File  = dir('*.AT2');
File2 = dir('*.csv');
Recinfo  = xlsread(File2.name);

for i=1:length(File)
Filename{i} = File(i).name;
end
 
for j=1:length(Filename)
    
FileID = fopen(Filename{j});
exp1    = '[^ \f\n\r\t\v,;:]*';

    for i=1:4
        aline1   = fgetl(FileID);
    end

extract1         = regexp(aline1,exp1,'match');
DT{j}            = str2double(extract1(4));   
accel{j}         = fscanf(FileID, '%f',[1,inf]);
accel{j}         = round(accel{j},5);
time{j}          = linspace(0,DT{j}*length(accel{j}),length(accel{j}));
npts{j}          = length(accel{j});


fclose('all'); 

exp2          = '\d*';
seqfile       = Filename{j}(1:7);
extract2      = regexp(seqfile,exp2,'match');
seqnum{j,1}   = str2double(extract2);

% extract info
seqnum{j,2}   = Recinfo(Recinfo(:,3)==seqnum{j,1},3);
seqnum{j,3}   = Recinfo(Recinfo(:,3)==seqnum{j,1},15);
seqnum{j,4}   = Recinfo(Recinfo(:,3)==seqnum{j,1},16);
seqnum{j,5}   = Recinfo(Recinfo(:,3)==seqnum{j,1},17);


% save file
olddir = cd;
cd ..

writematrix(accel{j}',[Filename{j}(1:7) Filename{j}(end-6:end-4) '.dat'])
save('EQInfo.mat','DT','npts','seqnum')
cd(olddir)

end







cd ..
