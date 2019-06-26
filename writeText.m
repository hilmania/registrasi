function frameCol=writeText(frameCol, txt, xPos, yPos, textCol)

frameCol = insertText(frameCol,[xPos yPos], txt,'TextColor',textCol,...
    'FontSize',50,'AnchorPoint','CenterTop');

