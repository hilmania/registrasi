% Function for store test result
% Input @params id_user, nilai, station
% Output @params flag, response

function [flag, response] = GarjasPostResult(id_user, nilai, station)
try
    [~, ~, idCardtest] = GarjasGetTestPeserta(id_user); 
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    
    params = {'id_user',id_user, station, nilai};
    [queryString,header] = http_paramsToString(params,1);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/' idCardtest];
    response = urlread2(apiUrl,'PUT',queryString,header);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end