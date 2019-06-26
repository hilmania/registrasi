function conn = OpenConnection()
%# JDBC connector path
% currentfolder = pwd;
% drivername = 'mysql-connector-java-5.0.8-bin.jar';
% javaaddpath([currentfolder '\' drivername]);
%# connection parameteres

host = '192.168.1.155';
% host = 'localhost';
user = 'root';
password = '';
dbName = 'disjasad';
jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
jdbcDriver = 'com.mysql.jdbc.Driver';
logintimeout(jdbcDriver,3);

%# Create the database connection object
conn = ConnectDatabase(dbName, user , password, jdbcDriver, jdbcString);