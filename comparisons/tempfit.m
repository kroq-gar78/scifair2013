% temporary temperature fit for Rio de Janeiro

function temp=tempfit(t)
	temp=24.27056+2.8*cos(2*pi*t/365.25+18.30016);
end
