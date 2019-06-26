% function to get nama from barcode/id_user provided
% @param id_user (barcode)

function [flag, nama] = GarjasGetNama(id_user)
try
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_master_user/'];
    readUrl = [apiUrl id_user];
    data = webread(readUrl);
    nama = data.nama_user;
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    nama = 'None';
end