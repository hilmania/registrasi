function [flag, response] = GarjasCheckCon()
try
    fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];
    apiUrl = [server 'apigarjas/api.php/disjas_master_test?transform=1'];    
    response = webread(apiUrl);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    response = 0;
end