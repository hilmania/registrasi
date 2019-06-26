function [flag, response] = GarjasEditContainer(id_user, id_test)

try
    [~, ~, idCardtest] = GarjasGetTestPeserta(id_user); 
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    
    params = {'id_user',id_user,'id_test', id_test};
    [queryString,header] = http_paramsToString(params,1);
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/' idCardtest];
    response = urlread2(apiUrl,'PUT',queryString,header);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end
