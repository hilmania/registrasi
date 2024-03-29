function result = myusejavadialog(functionName)

%   Copyright 2006-2008 The MathWorks, Inc.
result = usejava('awt');
% For -nojvm/-nodisplay modes the dialogs follow a deprecated code path
% that already throws a warning


% Show the warning for -nodisplay/-noFigureWindows mode
% Throw error in -nojvm mode
% warnfiguredialog method only shows a warning if java is present
mywarnfiguredialog(functionName);


if (feature('UseOldFileDialogs') == 1)
    result = false;
end