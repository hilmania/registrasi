clc
clear all
close all

id_user = '110890000104';
nilai = 16;
station = 'npull_up';
namaTestor = 'paijo';
[namaFile, flag] = GarjasSaveOffline(id_user, nilai, station, namaTestor);
container = NormalizeData(namaFile);
GarjasReportOffline(namaFile, container)

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
% filename = 'CobaReport.xlsx';
% filecopy = ['copy_' filename];
% copyfile(filename, filecopy);
% 
% xlswrite(filecopy, container);
% nFile = xlsread(filecopy);
% 
% nRow = size(nFile,1);
% nCol = size(nFile,2);
% endIndex = getChara(nCol);
% xlRange = ['A1:' endIndex num2str(nRow+1)];
% xlsborder(filecopy,'Sheet1',xlRange,'Box',1,2,1,'InsideHorizontal',1,2,1,'InsideVertical',1,2,1)
% 
% fullfile = [pwd '\' filecopy];
% 
% hExcel = actxserver('Excel.Application');
% hWorkbook = hExcel.workbooks.Open(fullfile);
% hWorksheet = hWorkbook.Sheets.Item(1);
% 
% fileOutput = [pwd '\Report.pdf'];
% hWorksheet.ExportAsFixedFormat('xlTypePDF', fileOutput);
% open(fileOutput);
