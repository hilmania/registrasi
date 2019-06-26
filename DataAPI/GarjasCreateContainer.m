% function to create container for each participant in registration
% input @params id_user, id_test
% output @params flag, response

function [flag, response] = GarjasCreateContainer(id_user)
try
    [~, id_test] = GarjasGetMasterTest(); 
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    params = {'id_test',id_test, 'id_user', id_user};
    [queryString,header] = http_paramsToString(params,1);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_card_test'];
    response = urlread2(apiUrl,'POST',queryString,header);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end