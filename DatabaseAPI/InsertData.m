function InsertData(conn, columnData, valueData, tableName)

%check numel columnData
ncolumn = numel(columnData);
strcolumn = repmat('%s,',1,ncolumn);
strcolumn(end) = [];
strdata = repmat('%s,',1,ncolumn);
strdata(end) = [];
namakolom = [];
value = [];

for i=1:ncolumn
    namakolom=cat(2,namakolom, sprintf('columnData{%d}',i) ,',');
end
namakolom(end)=[];

for i=1:ncolumn
    value=cat(2,value, [char('''''') valueData{i} char('''''') ',']);
end
value(end)=[];

% %insert data based on column name
if isconnection(conn)
    strquery = sprintf('sprintf(''INSERT INTO %%s(%s) VALUES(%s)'',tableName,%s)''',strcolumn,value,namakolom);
    strquery(end) = [];
    eval(['query=' strquery ';'])
    
%     display(query);
    fetch(exec(conn, query));
    display('Insert Success!');
else
    display('MySQL Connection Error');
end