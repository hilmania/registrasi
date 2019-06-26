% Function to get latest master test
% Input @param
% Output @params flag, id_test

function [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest()
try
    fileConf = fopen('C:\GConfig\server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    params = {'transform','1', 'order','id_test,desc'};
    apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    
    jumlahGroup = size(response.disjas_master_test, 1);

    listIdTest = cell(10,1);
    listTgl = cell(10,1);
    listTempat = cell(10,1);
    listNama = cell(10,1);
    ctr = 0;
    for i=1:jumlahGroup
        flag = CheckInContainer(response(1).disjas_master_test(i).id_test);
        if flag
            ctr = ctr+1;
            listIdTest{ctr} = response(1).disjas_master_test(i).id_test;
            listTgl{ctr} = response(1).disjas_master_test(i).tanggal;
            listTempat{ctr} = response(1).disjas_master_test(i).tempat;
            listNama{ctr} = response(1).disjas_master_test(i).nama_kegiatan;
        end
        if ctr==10
            break;
        end
    end
catch
    warning('Database operation failed!');
    listIdTest = '';
    listTgl = '';
    listTempat = '';
    listNama = '';
end

