% Function for create data participant
% Input @params id_user, nama_user, tinggi, berat, tgl_lahir,
% jenis_kelamin, usia
% Output @params flag, response

function [flag, response] = GarjasRegisterUser(id_user, nama_user, tgl_lahir, jenis_kelamin, usia)
% try
%     fileConf = fopen('server.txt');
fileConf = fopen('C:\GConfig\server.txt');
serverCon = textscan(fileConf,'%s');
fclose(fileConf);

params = {'id_user',id_user, 'nama_user', nama_user, 'tgl_lahir', tgl_lahir, 'jenis_kelamin', ...
    jenis_kelamin, 'usia', usia};
[queryString,header] = http_paramsToString(params,1);
server = ['http://' serverCon{1}{1} '/'];
apiUrl = [server 'apigarjas/api.php/disjas_master_user'];
response = urlread2(apiUrl,'POST',queryString,header);

if strcmp(response, 'null')
    h=mywarndlg({'Duplicate Data!; Registration Canceled!'},'Notification');
    pause(2);
    try %#ok<TRYNC>
        close(h) 
    end 
    
%     notif = msgbox('Duplicate Data!','Notif!');
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     javaFrame    = get(notif,'JavaFrame');
%     iconFilePath = 'default_icon_48.png';
%     javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    flag = false;
else
    flag = true;
end
% catch
%     warning('Database operation failed!');
%     flag = false;
%     response = -1;
% end