clear all
close all
clc

tic
a='192.168.1.155';
% a='202.99.192.68';

while 1
    if toc>2
        [Y] = dos(['ping ' a]);
        break;
    end
end

% i=0;
% tic,
% while 1
%     i=i+1;
%     if toc>10
%         disp(['done ' num2str(toc)])
%         break; 
%     end
% end