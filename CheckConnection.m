function flag = CheckConnection(conn)
if isconnection(conn)
    flag = 1;
else
    flag = 0;
end