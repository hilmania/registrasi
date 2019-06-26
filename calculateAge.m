function age = calculateAge(dateOfBirth,ref)

time=datevec(datestr(datenum(ref,'ddmmyy')));
% time = clock;
dateToday = round([time(3) time(2) time(1)]);

YY = dateToday(3) - dateOfBirth(3);
MM = dateToday(2) - dateOfBirth(2);
DD = dateToday(1) - dateOfBirth(1);
if DD < 0
    DD = DD+30;
    MM = MM-1;
end
if MM < 0
    MM = MM+12;
    YY =YY-1;
end
age = [YY MM DD];