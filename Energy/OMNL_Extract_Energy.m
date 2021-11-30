%%
fclose('all')

% load file

% create folder name
Folder      = dir('OMR*');
for i=1:length(Folder)
    Foldername{i} = Folder(i).name;
end


for z=1:length(Foldername)
    
    cd(Foldername{z})
    
    File        = dir('*.SLO');
    for i=1:length(File)
        Filename{i} = File(i).name;
    end


%% Extract Energy Result

for j=1:length(Filename)

% openfile & readfile
FileID      = fopen(Filename{j});
Rener       = textscan(FileID,'%s','delimiter','\n','whitespace','');

exp         = '[^ \f\n\r\t\v,;:]*';
extract     = regexp(Rener{1}(25:end),exp,'match');

Ener{j} = cellfun(@str2double,extract,'UniformOutput',false);
Ener{j} = cell2mat(Ener{j});


fclose('all');

end

cd ..
save(['Ener_' Foldername{z} '.mat'],'Ener')
clear Ener extract

end
fclose('all');
