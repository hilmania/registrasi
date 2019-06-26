clc
clear all
close all
conn = OpenConnection();

%init table disjas_card_test
tableName3 = 'disjas_card_test';
% listColumnCard = GetColumnTable(conn,tableName3);
% valueCard = {'110890000123','2','114','','','','','','',''};
% InsertData(conn, listColumnCard, valueCard, tableName3);
% 
% %init table disjas_master_test
% tableName = 'disjas_master_test';
% listColumnTest = GetColumnTable(conn,tableName);
% valueTest = {'5','10/27/2015','Tegal'};
% InsertData(conn, listColumnTest, valueTest, tableName);
% 
% %init table disjas_master_user
% tableName2 = 'disjas_master_user';
% listColumnUser = GetColumnTable(conn,tableName2);
% valueUser = {'117','Assiddiq','','166','66','110890','L','25'};
% InsertData(conn, listColumnUser, valueUser, tableName2);
% 
% %skenario update data di tiap post
% nomorPeserta = '110890000123';
% columnData = 'nlongrun';
% valueData = '9';

% UpdateData(conn, columnData, valueData, nomorPeserta, tableName3)

id='id_user';
valueId='114';
alldata = RetrieveData(conn,tableName3,id,valueId);
