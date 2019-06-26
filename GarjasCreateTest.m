% Function to create a master test
% Input @param tgl, tempat, nama_kegiatan
% Output @param flag, response

function [flag, response] = GarjasCreateTest(tgl, tempat, nama_kegiatan)
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    
    params = {'tanggal',tgl, 'tempat', tempat, 'nama_kegiatan',nama_kegiatan};
    [queryString,header] = http_paramsToString(params,1);
    apiUrl = [server 'apigarjas/api.php/disjas_master_test'];
    response = urlread2(apiUrl,'POST',queryString,header);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end