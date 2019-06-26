function weight=readWeight(im,segmentMask,tableCode,tableNum)

ybr=rgb2ycbcr(im);
layR=ybr(:,:,3);
mask=layR>65;
mask=imclearborder(mask);
mask=bwareaopen(mask,500);%figure;imshow(mask)
mask=imdilate(mask,strel('line',15,90));
mask=imerode(mask,strel('disk',3));
% im=mask;
resultDigit=[];
try
    sigVer=sum(mask,2);
    sigVer(sigVer>0)=1;
    sigHor=sum(mask);
    sigHor(sigHor>0)=1;
    graVer=sigVer(2:end)-sigVer(1:end-1);
    graHor=sigHor(2:end)-sigHor(1:end-1);
    startHor=find(graHor>0)+1;
    endHor=find(graHor<0);
    startVer=find(graVer>0);
    endVer=find(graVer<0);
    wDigit=max(endHor-startHor);
    hDigit=endVer-startVer;
    if hDigit/wDigit>10
        wDigit=round(0.8*max(startHor(2:end-1)-startHor(1:end-2)));
    end
    startHor=endHor-wDigit;
    startHor(startHor<1)=1;
    N=numel(startHor);
    for k=1:N
        segDigit=mask(startVer+1:endVer,startHor(k)+1:endHor(k));
        codeDigit=zeros(1,7);
        for m=1:7
            segMask=segmentMask(:,:,m);
            sensor=segDigit.*imresize(segMask,size(segDigit));
            if sum(sensor(:))>0
                codeDigit(m)=1;
            end
        end
        for l=1:10
            if isequal(tableCode(l,:),codeDigit)
                readNum=tableNum(l);
                break
            else
                readNum='-';
            end
        end
        resultDigit=cat(2,resultDigit,readNum);
    end
catch
    readNum='-';
    resultDigit=cat(2,resultDigit,readNum);
end
% resultDigit
weight=str2double(resultDigit);

