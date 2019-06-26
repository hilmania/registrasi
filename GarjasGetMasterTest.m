% Function to get latest master test
% Input @param
% Output @params flag, id_test

function [flag, response] = GarjasGetMasterTest(id_user)
if nargin==1
    try
        [~, ~, ~, idTest] = GarjasGetTestPeserta(id_user);
        %     fileConf = fopen('server.txt');
        fileConf = fopen('C:\GConfig\server.txt');
        serverCon = textscan(fileConf,'%s');
        fclose(fileConf);
        server = ['http://' serverCon{1}{1} '/'];
        
        %     params = {'transform','1', 'order','id_test,desc'};
        apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];
        %     [queryString, ~] = http_paramsToString(params,1);
        readUrl = [apiUrl idTest];
        response = webread(readUrl);
        %     id_test = response.id_test;
        %     tgl_test = response.tanggal;
        
        flag = true;
    catch
        warning('Connection refused!');
        flag = false;
        response= '';
    end
else
    try
        %     fileConf = fopen('server.txt');
        fileConf = fopen('C:\GConfig\server.txt');
        serverCon = textscan(fileConf,'%s');
        fclose(fileConf);
        server = ['http://' serverCon{1}{1} '/'];
        params = {'transform','1', 'order','id_test,desc'};
        apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];
        [queryString, ~] = http_paramsToString(params,1);
        readUrl = [apiUrl '?' queryString];
        respon = webread(readUrl);
        response = respon(1).disjas_master_test(1).id_test;
        flag = true;
    catch
        warning('Connection refused!');
        flag = false;
        response = '';
    end
end

