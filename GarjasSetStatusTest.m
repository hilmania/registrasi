function GarjasSetStatusTest(id_test, val)
% try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    
    apiUrl3 = [server 'apigarjas/api.php/disjas_active_test/'];
    response3 = webread(apiUrl3);
    
    nNullActive = size(response3.disjas_active_test.records, 1);
    nulledId = cell(nNullActive,1);
        
    for i=1:nNullActive
        nulledId{i} = response3.disjas_active_test.records{i}{1};
        params3 = {'id_active_test',nulledId{i},'flag','0'};
        [queryString3,header3] = http_paramsToString(params3,1);
        apiUrl4 = [server 'apigarjas/api.php/disjas_active_test/' nulledId{i}];
        response4 = urlread2(apiUrl4,'PUT',queryString3,header3);
    end
    
    params = {'filter',['id_test,eq,' id_test]};
    apiUrl = [server 'apigarjas/api.php/disjas_active_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
        
    %Cek disini sebelum update, jika tidak ada, masukkan
    if isempty(response.disjas_active_test.records)
        params2 = {'id_test',id_test, 'flag', val};
        [queryString2,header] = http_paramsToString(params2,1);
        apiUrl2 = [server 'apigarjas/api.php/disjas_active_test/'];
        response2 = urlread2(apiUrl2,'POST',queryString2,header);
    else
        idActive = response.disjas_active_test.records{1,1}{1};
        params2 = {'id_active_test',idActive, 'flag', val};
        [queryString2,header] = http_paramsToString(params2,1);
        apiUrl2 = [server 'apigarjas/api.php/disjas_active_test/' idActive];
        response2 = urlread2(apiUrl2,'PUT',queryString2,header);
    end
    
% catch
%     warning('Database operation failed!');
% end