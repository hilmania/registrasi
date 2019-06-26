function serialPort=connectSerial
instrreset
comList=instrhwinfo('serial');
if ~isempty(comList)
    N=numel(comList.SerialPorts);
    portName=comList.SerialPorts;
    serBuf=[];
    for k=1:N
        serialPort=serial(portName{k},'BaudRate',115200);
        try %#ok<TRYNC>
            fopen(serialPort);
            fwrite(serialPort, 'C');
            serBuf=readSerial(serialPort);
        end
        if ~isempty(serBuf)
            if serBuf==67
                fclose(serialPort);
                break
            end
        else
            delete(serialPort)
            serialPort=[];
        end
    end
else
    serialPort=[];
end

