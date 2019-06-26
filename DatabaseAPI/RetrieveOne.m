% function for retrieve all data from one column without condition
function data = RetrieveOne(conn,tableName,columnName)
if isconnection(conn)
    query = sprintf('SELECT %s FROM %s;',columnName, tableName);
%     display(query);
    rs = fetch(exec(conn,query));
    data = get(rs,'Data');
%     display(data);
else
    display('MySQL Connection Error!');
end