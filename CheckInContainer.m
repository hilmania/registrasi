function flag = CheckInContainer(id_test)
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
%     params = {'filter',['id_test,eq,' id_test]};
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/'];    
%     [queryString, ~] = http_paramsToString(params,1);
%     readUrl = [apiUrl '?' queryString];
%     response = webread(readUrl);
    response = webread(apiUrl);
    nTest = size(response.disjas_card_test.records,1);
    
    idTestGroup = cell(nTest, 1);
    for i=1:nTest
        idTestGroup{i} = response.disjas_card_test.records{i,1}{2}; 
    end
    
    uniqIdTest = unique(idTestGroup);
    
    for j=1:size(uniqIdTest,1)
        if strcmp(uniqIdTest{j}, id_test)
           idTest = uniqIdTest{j};
           break;
        else
            idTest = '0';
        end
    end
   
    flag = isequal(id_test, idTest);
catch
    warning('Database operation failed!');
    flag = false;
end