function container = NormalizeData(namaFile)

fileID = fopen(namaFile);
C = textscan(fileID,'%s %s %s');
fclose(fileID);

nRow = size(C{1,1}, 1);
nCol = size(C, 2);
container = cell(nRow, nCol+1);

for i=1:nCol+1
    for j=1:nRow
        if i==1 && j==1
            container{j,i} = 'Nomor';
        else
            if i==1
                container{j,i} = j-1;
            else
                container{j,i} = C{1,i-1}{j};
            end
        end
    end
end