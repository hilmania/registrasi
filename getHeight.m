function hval=getHeight(zeropoint,dst)

dstInt=floor(dst);
dstDec=dst-dstInt;
dstDec=round(100*dstDec)/100;
dst=dstInt+dstDec;
hm=abs(zeropoint-dst);
dechm=hm-floor(hm);
dechm=round(2*dechm)/2;
hval=floor(hm)+dechm;
if hval<=10
    hval=0;
end