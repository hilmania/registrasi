function alldata = RetrieveData(conn,tableName,id,valueId)
if isconnection(conn)
    query = sprintf('SELECT * FROM %s WHERE %s=''%s'' ',tableName,id,valueId);
    display(query);
    rs = fetch(exec(conn,query));
    alldata = get(rs,'Data');
    display(alldata);
else
    display('MySQL Connection Error!');
end