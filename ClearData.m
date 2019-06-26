function ClearData(conn)
if isconnection(conn)
    query = sprintf('TRUNCATE TABLE disjas_active_test;');
    query2 = sprintf('TRUNCATE TABLE disjas_master_test;');
    query3 = sprintf('TRUNCATE TABLE disjas_master_user;');
    query4 = sprintf('TRUNCATE TABLE disjas_card_test;');
%     display(query);
    rs = fetch(exec(conn,query));
    rs = fetch(exec(conn,query2));
    rs = fetch(exec(conn,query3));
    rs = fetch(exec(conn,query4));
%     alldata = get(rs,'Data');
%     display(alldata);
else
    display('MySQL Connection Error!');
end