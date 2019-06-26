function alldata = GetAllData(conn,tableName)
if isconnection(conn)
    query = sprintf('SELECT * FROM %s',tableName);
    display(query);
    rs = fetch(exec(conn,query));
    alldata = get(rs,'Data');
    display(alldata);
else
    display('MySQL Connection Error!');
end