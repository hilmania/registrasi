function idActiveTest = GarjasGetActiveTest()
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];

    params = {'filter',['flag,eq,1']};
    apiUrl = [server 'apigarjas/api.php/disjas_active_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    idActiveTest = response.disjas_active_test.records{1,1}{2};
    
catch
    warning('Connection refused!');
    idActiveTest = '';
end