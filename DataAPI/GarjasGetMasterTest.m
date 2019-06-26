% Function to get latest master test
% Input @param
% Output @params flag, id_test

function [flag, id_test] = GarjasGetMasterTest()
try
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    params = {'transform','1', 'order','id_test,desc'};
    apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    id_test = response(1).disjas_master_test(1).id_test;
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    id_test = '';
end

