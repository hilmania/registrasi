function RGB = myInsertText(I, position, text, varargin)
%insertText Insert text in image or video stream.
%  This function inserts text into an image or video. You can use it with
%  either a grayscale or truecolor image input. 
%
%  RGB = insertText(I, POSITION, TEXT_STRING) returns a truecolor image
%  with text string inserted into it. The input image, I, can be either a
%  truecolor or grayscale image. POSITION is an M-by-2 matrix of [x y]
%  coordinates of the upper-left corner of the text bounding box. The input
%  TEXT_STRING can be a single ASCII text string or a cell array of ASCII
%  strings of length M, where M is the number of rows in POSITION.  If a
%  single text string is provided it is used for all positions.
%
%  RGB = insertText(I, POSITION, NUMERIC_VALUE) returns a truecolor image
%  with numeric values inserted into it. NUMERIC_VALUE can be a scalar or a
%  vector of length M. If a scalar value is provided it is used for all
%  positions. Numeric values are converted to string using format '%0.5g'
%  as used by SPRINTF.
%
%  RGB = insertText(..., Name, Value)
%  specifies additional name-value pair arguments described below:
%
%  'FontSize'      Font size, specified in points, as an integer value in
%                  the range of 8 to 72.
%
%                  Default: 12
%
%  'TextColor'     Color for the text string. You can specify a different
%                  color for each string, or one color for all the strings.
%                  - To specify a color for each text string, set
%                    'TextColor' to a cell array of M strings or an M-by-3
%                    matrix of RGB values.
%                  - To specify one color for all text strings, set
%                    'TextColor' to either a color string or an [R G B]
%                    vector.
%                  RGB values must be in the range of the image data type.
%                  Supported color strings are, 'blue', 'green', 'red',
%                  'cyan', 'magenta', 'yellow', 'black', 'white'
%
%                  Default: 'black'
% 
%  'BoxColor'      Color of the text box. Specify the color in the same way
%                  as the 'TextColor'.
%   
%                  Default: 'yellow'
%
%  'BoxOpacity'    A scalar value from 0 to 1 defining the opacity of the
%                  text box. 0 corresponds to fully transparent and 1 to
%                  fully opaque. No text box appears when BoxOpacity is 0.
%                         
%                  Default: 0.6
% 
%  'AnchorPoint'   Defines the relative location of a point on the text
%                  box. Text box for each text string is positioned by
%                  placing the reference point (called anchor point) of the
%                  text box at point [x y] defined by a row in POSITION.
%                  AnchorPoint can be one of the following strings:
%                  'LeftTop',    'CenterTop',    'RightTop', 
%                  'LeftCenter', 'Center',       'RightCenter', 
%                  'LeftBottom', 'CenterBottom', 'RightBottom'                    
%   
%                  Default: 'LeftTop'
%
%  Class Support
%  -------------
%  The class of input I can be uint8, uint16, int16, double, single. Output
%  RGB matches the class of I.
%
%  Example 1: Insert numeric values
%  --------------------------------
%  I = imread('peppers.png');
%  position =  [1 50; 100 50]; % [x y]
%  value = [555 pi];
% 
%  RGB = insertText(I, position, value, 'AnchorPoint', 'LeftBottom');
%  figure, imshow(RGB), title('Numeric values');
%
%  Example 2: Insert numbers and strings
%  -------------------------------------
%  I = imread('board.tif');
%  % Create texts with fractional values
%  text_str = cell(3,1);
%  conf_val = [85.212 98.76 78.342]; % Detection confidence
%  for ii=1:3
%     text_str{ii} = ['Confidence: ' num2str(conf_val(ii),'%0.2f') '%'];
%  end
%  position = [23 373; 35 185; 77 107]; % [x y]
%  box_color = {'red','green','yellow'};
% 
%  RGB = insertText(I, position, text_str, 'FontSize', 18, ...
%        'BoxColor', box_color, 'BoxOpacity', 0.4);
%  figure, imshow(RGB), title('Board');
%
%  See also insertShape, insertMarker, insertObjectAnnotation

%% == Parse inputs and validate ==

% insertText does not work without the JVM.
if ~usejava('jvm')
    error(javachk('jvm'));
end

narginchk(3,13);
 
[RGB, position, text, anchorPoint, boxColor, textColor, ...
    boxOpacity, fontSize, isEmpty, isTextNumeric] = ...
    validateAndParseInputs(I, position, text, varargin{:});

% handle empty I or empty position
if isEmpty    
    return;
end
%% == Setup System Objects ==
textInserter = getSystemObjects(boxOpacity, fontSize, ...
                                class(I), isTextNumeric);

%% == Output ==
% insert text and its background
tuneOpacity(textInserter, boxOpacity);
textAndBoxColor = [textColor boxColor];
textLocWidthAlignment = appendWidthAlignment(position, anchorPoint); 
RGB = textInserter.step(RGB,text,textAndBoxColor,textLocWidthAlignment);

%==========================================================================
% Parse inputs and validate
%==========================================================================
function [RGB,position,outText,anchorPoint,boxColor,textColor,...
    boxOpacity,fontSize,isEmpty,isTextNumeric] = ...
    validateAndParseInputs(I, position, text, varargin)

%--input image--
checkImage(I);
RGB = convert2RGB(I);
inpClass = class(I);
    
%--position--
% position data type does not depend on input data type
validateattributes(position, {'numeric'}, ...
    {'real','nonsparse', '2d', 'finite', 'size', [NaN 2]}, ...
    mfilename,'POSITION', 2);
position = int32(position);
numPos = size(position, 1);

%--text--
checkText(text);
isTextNumeric = isnumeric(text);
% text conversion:
%    string text is converted to uint8 vector required by
%    vision.TextInserter
%    scalar text is repeated
[numTexts, outText] = getTexts(text, numPos);

%--isEmpty--
isEmpty = isempty(I) || isempty(position);

if isEmpty    
    [anchorPoint,boxColor,textColor,boxOpacity,fontSize] = ...
        deal([],[],[],[], []);
else


    %--other optional parameters--
    [anchorPoint,boxColor, textColor, boxOpacity, fontSize] = ...
                         validateAndParseOptInputs(inpClass,varargin{:});     
    crossCheckInputs(position, numTexts, boxColor, textColor);
    boxColor = getColorMatrix(inpClass, numPos, boxColor);
    textColor = getColorMatrix(inpClass, numPos, textColor);
end

%==========================================================================
function [anchorPoint,boxColor,textColor,boxOpacity,fontSize] = ...
                               validateAndParseOptInputs(inpClass,varargin)
% Validate and parse optional inputs

defaults = getDefaultParameters(inpClass);
% Setup parser
parser = inputParser;
parser.CaseSensitive = false;
parser.FunctionName  = mfilename;

parser.addParameter('AnchorPoint', defaults.AnchorPoint);
parser.addParameter('BoxColor', defaults.BoxColor);
parser.addParameter('TextColor', defaults.TextColor);
parser.addParameter('BoxOpacity', defaults.BoxOpacity, ...
                     @checkBoxOpacity);
parser.addParameter('FontSize', defaults.FontSize, @checkFontSize);

%Parse input
parser.parse(varargin{:});

anchorPoint = checkAnchorPoint(parser.Results.AnchorPoint);
boxColor    = checkColor(parser.Results.BoxColor, 'BoxColor');
textColor   = checkColor(parser.Results.TextColor, 'TextColor');
boxOpacity  = double(parser.Results.BoxOpacity);
fontSize    = double(parser.Results.FontSize);

%==========================================================================
function checkImage(I)
% Validate input image

validateattributes(I,{'uint8', 'uint16', 'int16', 'double', 'single'}, ...
    {'real','nonsparse'}, mfilename, 'I', 1)
% input image must be 2d or 3d (with 3 planes)
if (ndims(I) > 3) || ((size(I,3) ~= 1) && (size(I,3) ~= 3))
    error(message('vision:dims:imageNot2DorRGB'));
end

%==========================================================================
function checkText(text)
% Validate text

if isnumeric(text)
   validateattributes(text, {'numeric'}, ...
       {'real', 'nonsparse', 'nonnan', 'finite', 'nonempty', 'vector'}, ...
       mfilename, 'TEXT');  
else
    if ischar(text)
        validateattributes(text,{'char'},{},mfilename, 'TEXT');        
        text = {text};
    else
        validateattributes(text,{'cell'}, {'nonempty', 'vector'}, ...
                                                      mfilename, 'TEXT');
        allTextCellsChar = all(cellfun(@ischar,text));
        if  ~allTextCellsChar
          error(message('vision:insertText:textCellNonChar'));
        end                                                  
    end
    
    % Following escape characters are not supported
    % \b     Backspace
    % \f     Form feed
    % \r     Carriage return
    % \t     Horizontal tab 
    
    % \n     line termination : supported by insertText, 
    %                           but not by insertObjectAnnotation 
    throwErrorForEscapeChar(text, {'\b','\f','\r','\t'});    
end

%==========================================================================
function throwErrorForEscapeChar(text, escapeCharsCell)

for ii=1:length(escapeCharsCell)
    escapeChar    = sprintf(escapeCharsCell{ii});
    escapeCharIdx = strfind(text, escapeChar);
    hasEscapeChar = ~isempty([escapeCharIdx{1:end}]);
    if (hasEscapeChar)
        error(message('vision:insertText:unsupportedEscapeChar', ...
            escapeCharsCell{ii}));
    end
end

%==========================================================================
function anchorPointOut = checkAnchorPoint(anchorPoint)
% Validate AnchorPoint
                     
anchorPointOut = validatestring(anchorPoint, ...
                  {'LeftTop', 'LeftCenter', 'LeftBottom', ... 
                   'RightTop', 'RightCenter', 'RightBottom', ...
                   'CenterTop', 'CenterCenter', 'Center', 'CenterBottom'}, ...
                   mfilename,'AnchorPoint');
                               
%==========================================================================
function crossCheckInputs(position, numTexts, boxColor, textColor)
% Cross validate inputs

numRowsPositions = size(position, 1); 
numBoxColor      = getNumColors(boxColor);
numTextColors    = getNumColors(textColor);

% cross check text and position (rows)
if (numTexts ~=1) && (numTexts ~= numRowsPositions)
    error(message('vision:insertText:invalidNumTexts'));
end

% cross check color and position (rows). Empty color is caught here
if (numBoxColor ~= 1) && (numRowsPositions ~= numBoxColor)
    error(message('vision:insertText:invalidNumPosNumBoxColor'));
end

% cross check text color and position (rows). Empty color is caught here
if (numTextColors ~= 1) && (numRowsPositions ~= numTextColors)
    error(message('vision:insertText:invalidNumPosNumTextColor'));
end

%==========================================================================
function color = getColorMatrix(inpClass, numPos, color)

color = colorRGBValue(color, inpClass);
if (size(color, 1)==1)
    color = repmat(color, [numPos 1]);
end

%==========================================================================
function numColors = getNumColors(color)

% Get number of colors
numColors = 1;
if isnumeric(color)
    numColors = size(color,1);
elseif iscell(color) % if color='red', it is converted to cell earlier
    numColors = length(color);
end

%==========================================================================
function defaults = getDefaultParameters(inpClass)

% Get default values for optional parameters
% default color 'black', default text color 'yellow'
black = [0 0 0]; 
switch inpClass
   case {'double', 'single'}
       yellow = [1 1 0];  
   case 'uint8'
       yellow = [255 255 0];  
   case 'uint16'
       yellow = [65535  65535  0];          
   case 'int16'
       yellow = [32767  32767 -32768];
       black  = [-32768  -32768  -32768];         
end
       
defaults = struct(...
    'AnchorPoint', 'LeftTop', ...
    'BoxColor', yellow, ... 
    'TextColor',  black, ... 
    'BoxOpacity', 0.6,...
    'FontSize', 12);

%==========================================================================
function colorOut = checkColor(color, paramName) 
% Validate 'BoxColor' or 'TextColor'

% Validate color
if isnumeric(color)
   % must have 6 columns
   validateattributes(color, ...
       {'uint8','uint16','int16','double','single'},...
       {'real','nonsparse','nonnan', 'finite', '2d', 'size', [NaN 3]}, ...
       mfilename, paramName);
   colorOut = color;
else
   if ischar(color)
       colorCell = {color};
   else
       validateattributes(color, {'cell'}, {}, mfilename, 'BoxColor');
       colorCell = color;
   end
   supportedColorStr = {'blue','green','red','cyan','magenta','yellow', ...
                        'black','white'};
   numCells = length(colorCell);
   colorOut = cell(1, numCells);
   for ii=1:numCells
       colorOut{ii} =  validatestring(colorCell{ii}, ...
                                  supportedColorStr, mfilename, paramName);
   end
end

%==========================================================================
function tf = checkBoxOpacity(opacity)
% Validate 'BoxOpacity'

validateattributes(opacity, {'numeric'}, {'nonempty', 'nonnan', ...
    'finite', 'nonsparse', 'real', 'scalar', '>=', 0, '<=', 1}, ...
    mfilename, 'BoxOpacity');
tf = true;

%==========================================================================
function tf = checkFontSize(FontSize)
% Validate 'FontSize'

validateattributes(FontSize, {'numeric'}, ...
    {'nonempty', 'integer', 'nonsparse', 'scalar', '>=', 8, '<=', 200}, ...
    mfilename, 'FontSize');
tf = true;

%==========================================================================
function sizeTI = getCacheSizeForTextInserter()
% Text inserter object needs to be created for the following
% parameters:
% first: input data types: 'double','single','uint8','uint16','int16'
% second: font size: 8:72 (length(8:72) = 65)
% third: text type: number or string

numInDTypes  = 5;
numFontSizes = 193; 
numTextTypes = 2;

sizeTI = [numInDTypes numFontSizes numTextTypes];

%==========================================================================  
function textLocWidthAlignment = appendWidthAlignment(position, anchorPoint)

% position data-type must be int32
anchorIdx = getAnchorPointIdx(anchorPoint);
lastCol = repmat([int32(0) int32(0) int32(anchorIdx)], [size(position,1) 1]);
textLocWidthAlignment = [position lastCol];

%========================================================================== 
function anchorIdx = getAnchorPointIdx(anchorPoint)

switch anchorPoint
    case 'LeftTop'
        anchorIdx = 0;
    case 'LeftCenter'
        anchorIdx = 1;
    case 'LeftBottom'
        anchorIdx = 2;
    case 'RightTop'
        anchorIdx = 3;
    case 'RightCenter'
        anchorIdx = 4;
    case 'RightBottom'
        anchorIdx = 5;
    case 'CenterTop'
        anchorIdx = 6;
    case {'CenterCenter', 'Center'}
        anchorIdx = 7;
    case 'CenterBottom'
        anchorIdx = 8;
end

%========================================================================== 
function tuneOpacity(textInserter, boxOpacity)

if (boxOpacity ~= textInserter.Opacity(2))
    textInserter.Opacity = [1 boxOpacity];
end

%========================================================================== 
function inRGB = convert2RGB(I)

if ismatrix(I)
    inRGB = cat(3, I , I, I);
else
    inRGB = I;
end

%==========================================================================
function outColor = colorRGBValue(inColor, inpClass)

if isnumeric(inColor)
    outColor = cast(inColor, inpClass);
else    
    if iscell(inColor)
        textColorCell = inColor;
    else
        textColorCell = {inColor};
    end

   numColors = length(textColorCell);
   outColor = zeros(numColors, 3, inpClass);

   for ii=1:numColors
    supportedColorStr = {'blue','green','red','cyan','magenta','yellow',...
                         'black','white'};  
    % http://www.mathworks.com/help/techdoc/ref/colorspec.html
    colorValuesFloat = [0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0;1 1 1];                    
    idx = strcmp(textColorCell{ii}, supportedColorStr);
    switch inpClass
       case {'double', 'single'}
           outColor(ii, :) = colorValuesFloat(idx, :);
       case {'uint8', 'uint16'} 
           colorValuesUint = colorValuesFloat*double(intmax(inpClass));
           outColor(ii, :) = colorValuesUint(idx, :);
       case 'int16'
           colorValuesInt16 = im2int16(colorValuesFloat);
           outColor(ii, :) = colorValuesInt16(idx, :);           
    end
   end
end

%==========================================================================
function text = cell2texts(origTexts, numPos)
% This function converts the string to uint8 vector required by
% vision.TextInserter System Object

text = uint8(origTexts{1});
if (length(origTexts)==1)
    for i = 2: numPos   
        text = [uint8(text) 0 uint8(origTexts{1})];
    end    
else
    for i = 2: length(origTexts)    
        text = [uint8(text) 0 uint8(origTexts{i})];
    end
end

%==========================================================================
function [numTexts, text] = getTexts(text, numPos)

numTexts = length(text);
if isnumeric(text)
   if (numTexts==1)
       text = repmat(double(text), [1  numPos]);
   else
       text = double((text(:))');        
   end
else
   if ischar(text)
       text = {text};
       numTexts = 1;
   end
   text = cell2texts(text, numPos);
end

%==========================================================================
% Setup System Objects
%==========================================================================
function textInserter = getSystemObjects(boxOpacity, ...
    fontSize, inpClass, isTextNumeric)

persistent cache % cache for storing System Objects

if isempty(cache)
    cache.textInserterObjects = cell(getCacheSizeForTextInserter());
end

fontSizeIdx = fontSize-8+1;% 8=supportedFontSizes(1)
inDTypeIdx  = getDTypeIdx(inpClass);
textTypeIdx = getTextTypeIdx(isTextNumeric);

if isempty(cache.textInserterObjects{inDTypeIdx,fontSizeIdx,textTypeIdx})
    if (textTypeIdx==1)
        % integer vector
        formatSpecifier = '%0.5g'; 
    else
        % strings (in fact, uint8-separated by uint8('0')=48)
        formatSpecifier = '%s';  
    end
        
    % create the TextInserter
    textInserter = vision.TextInserter( ...
                     'Text',formatSpecifier,'Antialiasing',true, ...
                     'ColorSource', 'Input port', ...
                     'LocationSource','Input port',...
                     'OpacitySource', 'Property', ...
                     'Opacity', [1 double(boxOpacity)], ...
                     'FontSize', double(fontSize), ...
                     'Font','Segoe UI Bold',...
                     'isTextBackgroundMode', 1);
    
    % cache the TextInserter object in cell array
    cache.textInserterObjects{inDTypeIdx, fontSizeIdx, textTypeIdx} = ...
        textInserter;
else
    % point to the existing object
    textInserter = cache.textInserterObjects{inDTypeIdx, fontSizeIdx, ...
                                              textTypeIdx};
end

%==========================================================================
function dtIdx = getDTypeIdx(dtClass)

switch dtClass
    case 'double',
        dtIdx = 1;
    case 'single',
        dtIdx = 2;
    case 'uint8',
        dtIdx = 3;
    case 'uint16',
        dtIdx = 4;
    case 'int16',
        dtIdx = 5;
end

%==========================================================================
function textTypeIdx = getTextTypeIdx(isTextNumeric)

if (isTextNumeric)
    textTypeIdx = 1;
else
    textTypeIdx = 2;
end
