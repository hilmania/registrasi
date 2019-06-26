function data = GetData(conn,tableName,columnName,id,valueId)
if isconnection(conn)
    query = sprintf('SELECT %s FROM %s WHERE %s=%s;',columnName, tableName,id,valueId);
%     display(query);
    rs = fetch(exec(conn,query));
    data = get(rs,'Data');
%     display(data);
else
    display('MySQL Connection Error!');
end