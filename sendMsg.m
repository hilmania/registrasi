function sendMsg(handles, msgStr)
global height width
clearingDisplay_Callback(handles)
blankMsg=uint8(255*ones(height,width,3));
msg= insertText(blankMsg,[width/2 height/2], msgStr,'TextColor','blue',...
    'FontSize',35,'AnchorPoint','Center');
imshow(msg,'Parent',handles.axes2);
pause(1e-3)

