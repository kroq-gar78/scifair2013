function datenum = str2date(date) % assuming the input is in the format of "yyyymmdd"
datenum = strptime(num2str(date,9),"%Y%m%d");
end
