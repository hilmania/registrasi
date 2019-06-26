function [binerCode, numericCode, imRaw, imCode] = encodeEAN13(inputCode)
%Reference
% http://www.barcodeisland.com/ean13.phtml

% Converting inputCode to matrix
codeStr=num2str(inputCode);
codeMx=[];
for k=1:numel(codeStr)
    codeMx=cat(2,codeMx,str2double(codeStr(k)));
end
if numel(codeMx)<12
    codeMx=cat(2,zeros(1,12-numel(codeMx)), codeMx);
elseif numel(codeMx)>12
    codeMx=codeMx(1:12);
end

%calculate checksum
weighting=[1 3 1 3 1 3 1 3 1 3 1 3];
weightedCode=codeMx.*weighting;
weightedSum=sum(weightedCode);
nextTeen=10*ceil(weightedSum/10);
checkSum=nextTeen-weightedSum;
finalCode=[codeMx checkSum];

numericCode=[];
for k=1:13
    numericCode=cat(2,numericCode,num2str(finalCode(k)));
end

codeCell=cell(1,13);
for k=2:13
    codeCell{k}=num2str(finalCode(k-1));
end
codeCell{1}=num2str(finalCode(13));

% Preparing Table
leftGuard=[1 0 1];
rightGuard=[1 0 1];
centerGuard=[0 1 0 1 0];
decimalCode= [88 76 100 94 98 70 122 110 118 104];
leftOddTable = de2bi(decimalCode, 7); %right msb
rightTable=~leftOddTable;
leftEvenTable=fliplr(rightTable);

%parityTable; 1 => Odd ; 0 => Even
% parityTable = [a b c d e f] => a second number, b,c d e f manufacture code 1 to 5
decimalParity=[63 11 19 35 13 25 49 21 37 41];
parityTable=de2bi(decimalParity);

%Start Encoding
finalBarcode=leftGuard;
guardPos=leftGuard;
textPointer=[0 0 0 1 0 0 0];
textY=zeros(size(textPointer));
ixParity=finalCode(1)+1;
parity=parityTable(ixParity,:);
for k=2:13
    num2code=finalCode(k);
    ixCode=num2code+1;
    if k<=7
        if parity(k-1)==1
            finalBarcode=cat(2,finalBarcode,leftOddTable(ixCode,:));
            guardPos=cat(2,guardPos,zeros(1,7));
            textY=cat(2,textY,textPointer);
        else
            finalBarcode=cat(2,finalBarcode,leftEvenTable(ixCode,:));
            guardPos=cat(2,guardPos,zeros(1,7));
            textY=cat(2,textY,textPointer);
        end
        if k==7
            finalBarcode=cat(2,finalBarcode,centerGuard);
            guardPos=cat(2,guardPos,centerGuard);
            textY=cat(2,textY,zeros(1,4));
        end
    else
        finalBarcode=cat(2,finalBarcode,rightTable(ixCode,:));
        guardPos=cat(2,guardPos,zeros(1,7));
        textY=cat(2,textY,textPointer);
    end
    if k==13
        finalBarcode=cat(2,finalBarcode,rightGuard);
        guardPos=cat(2,guardPos,rightGuard);
        textY=cat(2,textY,zeros(size(textPointer)));
    end
end

binerCode=~finalBarcode;
guard=~guardPos;

wBar=4;
wd=wBar*95;
goldenRatio=1.618;
hg=round(wd/(1.1*goldenRatio)); %height guard
hBottomAdd=round(hg/(2.5*goldenRatio));
textY=cat(2,round(0.5*hBottomAdd),hBottomAdd-4*wBar+wBar*find(textY>0));
textX=round(repmat(hg+0.5*hBottomAdd,size(textY)));
textPos=[textY; textX]';

imRaw=cat(3,uint8(255*repmat(imresize(binerCode,[hg wd],'box'),[1 1 3])));
imGuard=cat(3,uint8(255*repmat(imresize(guard,[round(hBottomAdd/goldenRatio) wd],'box'),[1 1 3])));
bottomAdd=cat(3,uint8(255*repmat(ones(round(hBottomAdd/(goldenRatio+1)),wd),[1 1 3])));
imCode=cat(1,imRaw,imGuard,bottomAdd);

[newH, ~, ~]=size(imCode);
imCode=cat(2,uint8(255*repmat(ones(newH,hBottomAdd),[1 1 3])),imCode);
imCode=insertText(imCode,textPos,codeCell,...
    'FontSize', 40,'BoxOpacity',0,'AnchorPoint','Center');
imCode=cat(1,uint8(255*repmat(ones(round(hBottomAdd/(goldenRatio+1)),size(imCode,2)),[1 1 3])),imCode);
imCode=cat(2,imCode,uint8(255*repmat(ones(size(imCode,1),round(hBottomAdd/(goldenRatio+1))),[1 1 3])));
imCode([1,2,end-1,end],:,:)=0;
imCode(:,[1,2,end-1,end],:)=0;