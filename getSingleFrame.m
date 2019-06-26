function [frameCol, frameDepth]=getSingleFrame(camKinect)

while true
    validData = camKinect.updateData;
    if validData
        frameCol = camKinect.getColor;
        frameDepth = camKinect.getDepth;
        break
    end
end