function serBuf=readSerial(serialPort)

serBuf=[];
tOut=0.5;
tStart=clock;
while 1
    if serialPort.BytesAvailable~=0
        datByte=fread(serialPort,1);
        if datByte==10
            break
        else
            serBuf=cat(2,serBuf,datByte);
        end
    end
    if etime(clock,tStart)>tOut
        break
    end
end