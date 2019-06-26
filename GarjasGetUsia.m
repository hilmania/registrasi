% function to get usia from barcode/id_user provided
% @param id_user (barcode)

function [flag, usia] = GarjasGetUsia(id_user)
try
    fileConf = fopen('C:\GConfig\server.txt');
%     fileConf = fopen('server.txt');
    serverCon = textscan(fileConf,'%s');
    fclose(fileConf);
    server = ['http://' serverCon{1}{1} '/'];

    params = {'filter',['id_user,eq,' id_user]};
    apiUrl = [server 'apigarjas/api.php/disjas_card_test/'];    
    [queryString, ~] = http_paramsToString(params,1);
    readUrl = [apiUrl '?' queryString];
    response = webread(readUrl);
    lastCheckIn = response.disjas_card_test.records{1,1}{9};
    
    apiUrlBirth = [server 'apigarjas/api.php/disjas_master_user/'];
    readUrlBirth = [apiUrlBirth id_user];
    responseBirth = webread(readUrlBirth);
    birthDate = responseBirth.tgl_lahir;
    
    bornDate=str2double(birthDate(1:2));
    bornMonth=str2double(birthDate(3:4));
    bornYear=str2double(birthDate(5:6));
    currentDay=date;
    currentYear=str2double(currentDay(end-3:end));
    if bornYear>currentYear-2000
        bornYear=bornYear+1900;
    else
        bornYear=bornYear+2000;
    end
    age = calculateAge([bornDate bornMonth bornYear], datestr(lastCheckIn(1:10),'ddmmyy'));
    usia = age(1);
    flag = true;
catch
    warning('Connection refused!');
    flag = false;
    usia = '0';
end