function PrintPassportPhoto (PhotoType,PhotoReso)
% Print your passport or visa or other ID photos on a 4x6-inch-sized photo paper!
%
% This is the main function!
% 
% This program generates a printable 4x6-inch-sized photo that contains
% several standard passport- or visa-sized photos.
% Photo sizes that are supported:
% 1 inch (38x25mm); big 2 inch (53x35mm); small 2 inch (48x33mm); 
% 2 inch square (50x50mm)
%
% User direction:
% 
% Specify photo type, photo resolution (optional)
% Run this function, select the source photo,
% Then this code will output a picture that is suitable for printing on a
% 4x6-inch-sized photo paper.
% You can print it out at a local or online store, which costs less than 15 cents.
% NOTE: you must choose the 4x6-inch-sized photo paper!
% After the 4x6 photo is done, cut the photo into passport or visa photos.
%
% Input Values:
% PhotoType: 
% '1': 1 inch: 38x25 mm
% '2b': big 2 inch:  53x35 mm
% '2s': small 2 inch: 48x33 mm (for Chinese passport)
% 'sq2' 2 inch square: 50x50 mm (for USA visa) 
% defaul format is 'sq2'
%
% PhotoReso = [Height, Width] in pixels
% default resolution: 1200x1800 pixels
%
% Photo paper size is 4x6 inches. This can not be modified
%
% Author: Zhen Qian (email: zhqian@gmail.com)
% 10/27/2009 All rights reserved


if nargin <1
    PhotoType = 'sq2';
end

if nargin <2
    PhotoReso = [1200,1800];
else
    PhotoReso = [PhotoReso(1),round(PhotoReso(1)/2*3)];
end
    
[filename,pathname] = uigetfile('*.*','Read in source image');
if filename==0
    return
end
InputI = imread([pathname,filename]);
if ndims(InputI)==2
    temp = zeros(size(InputI,1),size(InputI,2),3);
    temp(:,:,1)=InputI;
    temp(:,:,2)=InputI;
    temp(:,:,3)=InputI;
    InputI = temp;
end
if size(InputI,1)<size(InputI,2)
    temp = zeros(size(InputI,2),size(InputI,1),3);
    temp(:,:,1)=(InputI(:,:,1))';
    temp(:,:,2)=(InputI(:,:,2))';
    temp(:,:,3)=(InputI(:,:,3))';
    InputI = temp;
end

InputI = double(InputI);
InputI = InputI/max(InputI(:))/1.01;
I = ones(PhotoReso(1),PhotoReso(2),3);

if strcmp(PhotoType,'1')
    H = 38*size(I,2)/150;
    W = 25*size(I,2)/150;
    H = round(H);
    W = round(W);
    InputI = ResizePhoto(InputI,H/W);
    InputI =  imresize(InputI,[H,W]);
    I = ArrangePhoto(InputI,I,2,6);
elseif strcmp(PhotoType,'2b')
    H = 53*size(I,2)/150;
    W = 35*size(I,2)/150;
    InputI = ResizePhoto(InputI,H/W);
    InputI =  imresize(InputI,[H,W]);
    I = ArrangePhoto(InputI,I,1,4);
elseif strcmp(PhotoType,'2s')
    H = 48*size(I,2)/150;
    W = 33*size(I,2)/150;
    InputI = ResizePhoto(InputI,H/W);
    InputI =  imresize(InputI,[H,W]);
    I = ArrangePhoto(InputI,I,2,4);
elseif strcmp(PhotoType,'sq2')
    H = 50*size(I,2)/150;
    W = 50*size(I,2)/150;
    InputI = ResizePhoto(InputI,H/W);
    InputI =  imresize(InputI,[H,W]);
    I = ArrangePhoto(InputI,I,2,3);
else
    warndlg('Please input the correct photo type!','Warning');
end
  
[filename,pathname] = uiputfile('*.jpg;*.png;*.bmp;*.gif;','Save as image files');
if length(filename)<4
    filename = [filename,'.jpg'];
end    
if ~strcmp(filename(end-3),'.')
    filename = [filename,'.jpg'];
end
if filename==0
    return
end
imwrite(I,[pathname,filename])