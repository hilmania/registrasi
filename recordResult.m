function recordResult(station, name, result)

fileName=sprintf('rec_%s_%s',station,date);
fileName(fileName=='-')=[];

if ~exist([fileName '.mat'],'file')
    eval(sprintf('%s = [{''%s''} {''%s''}];',fileName,name,result));
    eval(sprintf('save %s.mat %s;',fileName,fileName))
else
    eval(sprintf('load %s.mat;', fileName))
    eval(sprintf('%s = [%s; [{''%s''} {''%s''}]];',fileName, fileName, name,result))
    eval(sprintf('save %s.mat %s;',fileName,fileName))
end