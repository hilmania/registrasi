function UpdateData(conn, columnData, valueData, nomorPeserta, tableName)
% %update data based on column name
if isconnection(conn)
    strquery = sprintf('UPDATE %s SET %s=''%s'' WHERE id_user=''%s''',tableName, columnData, valueData, nomorPeserta);
    display(strquery);
    fetch(exec(conn, strquery));
    display('Update Success!');
else
    display('MySQL Connection Error');
end