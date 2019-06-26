clc
clear all
close all
% imaqreset;
% info=imaqhwinfo('winvideo');
% id=cell2mat(info.DeviceIDs);
% costructor=cell(size(id));
% for k=1:1%numel(id)
%     info=imaqhwinfo('winvideo',k);
%     eval(sprintf('vid%d=%s;',id(k),info.VideoInputConstructor));
%     eval(sprintf('triggerconfig(vid%d, ''Manual'');',id(k)));
%     eval(sprintf('set(vid%d,''TriggerRepeat'',Inf);',id(k)));
%     eval(sprintf('set(vid%d,''FramesPerTrigger'',1);',id(k)));
%     eval(sprintf('start(vid%d)',id(k)));
% end
% 
% 
% for k=1:100;
%     for m=1:1:%numel(id)
%         eval(sprintf('trigger(vid%d);',id(m)));
%         
%     
%     end
% end
%     
    

lst=webcamlist;
N=length(lst)
for k=1:N
    cam=webcam(k);
    im=snapshot(cam);
    im=imresize(im,[480 640]);
    im = insertText(im,[320 240],...
            sprintf('CamID: %d',k),'TextColor','blue',...
            'FontSize',72,'AnchorPoint','Center');
    figure;imshow(im)
end
    
    