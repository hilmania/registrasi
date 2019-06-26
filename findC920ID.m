function camID=findC920ID

info=imaqhwinfo('winvideo');
ID=cell2mat(info.DeviceIDs);
camID=[];
for k=1:numel(ID)
    info=imaqhwinfo('winvideo',ID(k));
    if strcmp(info.DeviceName,'Logitech HD Pro Webcam C920')
        camID=ID(k);
        break
    end
end