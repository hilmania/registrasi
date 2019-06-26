% function for retrieve id_test by descending
function data = RetrieveIdTest(conn)
if isconnection(conn)
    query = sprintf('SELECT id_test FROM disjas_card_test ORDER BY CAST(id_test AS UNSIGNED) DESC');
%     display(query);
    rs = fetch(exec(conn,query));
    data = get(rs,'Data');
%     display(data);
else
    display('MySQL Connection Error!');
end