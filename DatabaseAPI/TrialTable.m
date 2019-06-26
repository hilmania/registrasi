conn = OpenConnection();

colorgen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];

columnNames = {'Posture Check', 'Long Run', 'Shuttle Run', 'Pull Up', 'Sit Up', 'Push Up'};
rowNames = {'Hilman', 'Ibnu', 'Assiddiq', 'Fulan', 'Jono', 'Ho'};
data = {  'Hilman', colorgen('#FF0000','Red')
         'Ibnu', colorgen('#00FF00','Green')
         'Assiddiq', colorgen('#0000FF','Blue')
       };


%init table disjas_card_test
tableName3 = 'disjas_card_test';
database = GetAllData(conn,tableName3);

temp = database(1:2,4:end);
nRow = size(temp, 1);
nCol = size(temp, 2);

for i=1:nRow
    for j=1:nCol
        if strcmp(temp{i,j},'')
            temp{i,j}=colorgen('#FF0000','-');
        elseif strcmp(temp{i,j},'0')
            temp{i,j}=colorgen('#FFFF00','?');
        else
            temp{i,j}=colorgen('#00FF00',temp{i,j});

        end
    end
end

% l   = cellfun(@length,temp);
% temp = num2cell([arrayfun(@blanks,max(l)-l,'un',0) temp],1);
% temp = strcat(temp{:});
% temp = cellfun(@(s) sprintf('%*s',max(cellfun(@length,temp)),s),temp);

t = uitable('Data', temp, 'ColumnName', columnNames, 'RowName', rowNames);
t.Position(3) = t.Extent(3);
t.Position(4) = t.Extent(4);

