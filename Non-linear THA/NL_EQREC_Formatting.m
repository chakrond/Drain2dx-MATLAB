% change directory
cd EQREC

% inputs an acceleration 
clc, clear
File = dir('*.AT2');


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

% save file
olddir = cd;
cd ..

writematrix(accel{j}',[Filename{j}(1:10) '.dat'])
save('EQInfo.mat','DT','npts')
cd(olddir)

end
cd ..
