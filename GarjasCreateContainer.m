% function to create container for each participant in registration
% input @params id_user, id_test
% output @params flag, response

function response = GarjasCreateContainer(id_user,handles)
% try
[listIdTest, ~, ~, ~] = GarjasGetListIdTest();
upID=listIdTest{1};
if isempty(upID)
    upID=0;
end
val=get(handles.groupTest,'value');
str=get(handles.groupTest,'string');
if iscell(str)
    str=str{val};
    ixstrip=find(str=='-');
    currentID=str(1:ixstrip-1);
else
    currentID=0;
end
[~, latest_ID] = GarjasGetMasterTest();

if latest_ID > upID
    id_test=latest_ID;
else
    if upID~=currentID
        id_test=currentID;
    else
        id_test=upID;
    end
end


% [~, id_test] = GarjasGetMasterTest();
% id_test = GarjasGetActiveTest();


fileConf = fopen('C:\GConfig\server.txt');
serverCon = textscan(fileConf,'%s');
fclose(fileConf);
server = ['http://' serverCon{1}{1} '/'];

% Cek jika sudah ada
params2 = {'filter',['id_user,eq,' id_user],'order','id_test,desc'};
[queryString2,~] = http_paramsToString(params2,1);
apiUrl2 = [server 'apigarjas/api.php/disjas_card_test'];
readUrl = [apiUrl2 '?' queryString2];
response2 = webread(readUrl);

if isempty(response2.disjas_card_test.records)
    params = {'id_test',id_test, 'id_user', id_user};
    [queryString,header] = http_paramsToString(params,1);
    apiUrl = [server 'apigarjas/api.php/disjas_card_test'];
    response = urlread2(apiUrl,'POST',queryString,header);
    %         flag = true;
else if strcmp(id_test, response2.disjas_card_test.records{1,1}{2})
        %             notif = msgbox('Duplicate data!');
        response = -1;
    end
end
%     warning('Database operation failed!');
%     flag = false;
%     response = -1;
% end