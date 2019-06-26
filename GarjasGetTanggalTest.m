function testDate=GarjasGetTanggalTest(id_test)

fileConf = fopen('C:\GConfig\server.txt');
serverCon = textscan(fileConf,'%s');
fclose(fileConf);
server = ['http://' serverCon{1}{1} '/'];
params = {'transform','1', 'order','id_test,desc'};
apiUrl = [server 'apigarjas/api.php/disjas_master_test/'];
[queryString, ~] = http_paramsToString(params,1);
readUrl = [apiUrl '?' queryString];
respon = webread(readUrl)
respon.disjas_master_test.tanggal(id_test)
testDate=1;