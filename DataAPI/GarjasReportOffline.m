function GarjasReportOffline(fileName, data)

% data = {'Time', 'Temperature'; 12,98; 13,99; 14,97};
template = 'TemplateReport.xlsx';
filecopy = ['copy_' fileName];
copyfile(template, filecopy);

xlswrite(filecopy, data);
nFile = xlsread(filecopy);

nRow = size(nFile,1);
nCol = size(nFile,2);
endIndex = getChara(nCol);
xlRange = ['A1:' endIndex num2str(nRow+1)];
xlsborder(filecopy,'Sheet1',xlRange,'Box',1,2,1,'InsideHorizontal',1,2,1,'InsideVertical',1,2,1)

fullfile = [pwd '\' filecopy];

hExcel = actxserver('Excel.Application');
hWorkbook = hExcel.workbooks.Open(fullfile);
hWorksheet = hWorkbook.Sheets.Item(1);

tgl = date;
fileOutput = [pwd '\' tgl '_Report.pdf'];
hWorksheet.ExportAsFixedFormat('xlTypePDF', fileOutput);
open(fileOutput);