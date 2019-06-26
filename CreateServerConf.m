function CreateServerConf(ipAddr)

namaFile = 'C:\GConfig\server.txt';

if exist(namaFile, 'file') == 2
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    if isempty(serverCon{1})
        delete('C:\GConfig\server.txt')
        fid=fopen(namaFile, 'w');
        fprintf(fid, ipAddr);
        fclose(fid);
    else
        host = serverCon{1}{1};
        numPoint=numel(find(host=='.'));
        if numPoint~=3
            delete('C:\GConfig\server.txt')
            fid=fopen(namaFile, 'w');
            fprintf(fid, ipAddr);
            fclose(fid);
        end
    end
else
    fid=fopen(namaFile, 'w');
    fprintf(fid, ipAddr);
    fclose(fid);
end
fclose('all');