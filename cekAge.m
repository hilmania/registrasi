clc
lahirStr='120598';
bornDate=str2double(lahirStr(1:2))
bornMonth=str2double(lahirStr(3:4))
bornYear=str2double(lahirStr(5:6))
currentDay=date
currentYear=str2double(currentDay(end-3:end))
if bornYear>currentYear-2000
    bornYear=bornYear+1900;
else
    bornYear=bornYear+2000;
end
dateOfBirth=[bornDate bornMonth bornYear];

time = clock;
dateToday = round([time(3) time(2) time(1)]);
YY = dateToday(3) - dateOfBirth(3)
MM = dateToday(2) - dateOfBirth(2)
DD = dateToday(1) - dateOfBirth(1)
if DD < 0
    DD = DD+30;
    MM = MM-1;
end
if MM < 0
    MM = MM+12;
    YY =YY-1;
end
age = [YY MM DD];




