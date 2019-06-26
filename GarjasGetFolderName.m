function folderName=GarjasGetFolderName(handles)

fileConf = fopen('C:\GConfig\server.txt');
serverCon = textscan(fileConf,'%s');
fclose(fileConf);
server = ['http://' serverCon{1}{1} '/'];
params = {'transform','1', 'order','id_test,desc'};
apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];
[queryString, ~] = http_paramsToString(params,1);
readUrl = [apiUrl '?' queryString];
respon = webread(readUrl);
all_id_test=cat(1,respon.disjas_master_test.id_test);
if numel(all_id_test)==1
    folderName=respon.disjas_master_test.nama_kegiatan;
elseif numel(all_id_test)>1
    string_id_test = get(handles.groupTest,'string');
    value_id_test = get(handles.groupTest,'value');
    ixStrip = find(string_id_test{value_id_test}=='-');
    id_test=string_id_test{value_id_test}(1:ixStrip-1);
    [listIdTest, ~, ~, listNama] = GarjasGetListIdTest();
    n=length(listIdTest);
    for k=1:n
        dataIdTest=listIdTest{k};
        if dataIdTest==id_test
            folderName=listNama{k};
            break
        end
    end
end
