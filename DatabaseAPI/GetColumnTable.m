function columnlist = GetColumnTable(conn, tableName)
query = sprintf('select * from %s;',tableName);
% display(query);
rs = fetch(exec(conn,query));
columnlist = columnnames(rs, true);
% display(columnlist);
