function data = RetrieveIdMasterTest(conn)
if isconnection(conn)
    query = sprintf('SELECT id_test FROM disjas_master_test ORDER BY id_test DESC');
%     display(query);
    rs = fetch(exec(conn,query));
    data = get(rs,'Data');
%     display(data);
else
    display('MySQL Connection Error!');
end