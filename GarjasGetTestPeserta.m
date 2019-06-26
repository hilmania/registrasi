function [flag, response, idCardtest, id_test] = GarjasGetTestPeserta(id_user)
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];

    params = {'filter',['id_user,eq,' id_user]};
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    idCardtest = response.disjas_card_test.records{1,1}{1};
    id_test = response.disjas_card_test.records{1,1}{2};
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    idCardtest = '';
end