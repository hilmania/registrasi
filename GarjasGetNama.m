% function to get nama from barcode/id_user provided
% @param id_user (barcode)

function nama = GarjasGetNama(id_user)
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_master_user/'];
    readUrl = [apiUrl id_user];
    data = webread(readUrl);
    nama = data.nama_user;
    
%     params = {'filter',['id_user,eq,' id_user], 'order','id_test,desc'};
%     apiUrl2 = [server 'apigarjas/api.php/disjas_card_test/'];    
%     [queryString, ~] = http_paramsToString(params,1);
%     readUrl2 = [apiUrl2 '?' queryString];
%     response = webread(readUrl2);
%     idTest = str2double(response.disjas_card_test.records{1,1}{2});
%     conn = OpenConnection();
%     activeID = str2double(RetrieveIdTest(conn));
%        
%     if ~isequal(idTest, activeID)
%         nama = '-';
%     else
%         nama = data.nama_user;
%     end
catch
    warning('Database operation failed!');
    nama = '-';
end