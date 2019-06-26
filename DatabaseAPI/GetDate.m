function tanggal = GetDate(idTest)
tableName = 'disjas_master_test';
conn = OpenConnection();
id='id_test';
alldata = RetrieveData(conn,tableName,id,idTest);

if strcmp(alldata,'No Data')
    tanggal = '0';
else
    tanggal = alldata{2};
end
