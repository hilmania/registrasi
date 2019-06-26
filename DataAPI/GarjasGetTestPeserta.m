function [flag, response, idCardtest] = GarjasGetTestPeserta(id_user)
try
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];

    params = {'filter',['id_user,eq,' id_user]};
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    idCardtest = response.disjas_card_test.records{1,1}{1};
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    idCardtest = '';
end