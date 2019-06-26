function name = GetName(barcode)
tableName = 'disjas_master_user';
conn = OpenConnection();
id='id_user';
alldata = RetrieveData(conn,tableName,id,barcode);
name = alldata{2};