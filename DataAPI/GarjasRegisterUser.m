% Function for create data participant
% Input @params id_user, nama_user, tinggi, berat, tgl_lahir,
% jenis_kelamin, usia
% Output @params flag, response

function [flag, response] = GarjasRegisterUser(id_user, nama_user, tinggi, berat, tgl_lahir, jenis_kelamin, usia)
try
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    
    params = {'id_user',id_user, 'nama_user', nama_user, 'tinggi', tinggi, 'berat', berat, 'tgl_lahir', tgl_lahir, 'jenis_kelamin', ...
        jenis_kelamin, 'usia', usia};
    [queryString,header] = http_paramsToString(params,1);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_master_user'];
    response = urlread2(apiUrl,'POST',queryString,header);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end