% function for retrieve id_test by descending

% QUERY : 
% SELECT DISTINCT disjas_card_test.id_test FROM disjas_card_test 
% JOIN disjas_active_test
% on disjas_card_test.id_test=disjas_active_test.id_test
% WHERE disjas_active_test.flag='0'
% ORDER BY CAST(disjas_card_test.id_test AS UNSIGNED) DESC

% SELECT id_test FROM disjas_card_test ORDER BY CAST(id_test AS UNSIGNED) DESC

function data = RetrieveIdTest(conn)
if isconnection(conn)
    query = 'SELECT DISTINCT disjas_card_test.id_test FROM disjas_card_test JOIN disjas_active_test on disjas_card_test.id_test=disjas_active_test.id_test WHERE disjas_active_test.flag=''1'' ORDER BY CAST(disjas_card_test.id_test AS UNSIGNED) DESC';
%     display(query);
    rs = fetch(exec(conn,query));
    data = get(rs,'Data');
%     display(data);
else
    display('MySQL Connection Error!');
end