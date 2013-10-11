% from Kashiwada and Ohta 2010

% linear; temperature in Celsius

junk=0; % junk variable to make the file interpreted as a script and not as a function definition

function dev=f_kashiwada(coeff,temp,offset) % form of y=coeff*temp-offset
	dev=coeff*temp-offset;
end

# eggs
kashiwada_eggs=zeros(1,size(templist,2))';
for i=1:size(templist,2)
	kashiwada_eggs(i)=f_kashiwada(0.0396,templist(i)-273,0.4439);
end

hold on;
plot(templist,kashiwada_eggs)

# larvae
kashiwada_larvae=zeros(1,size(templist,2))';
for i=1:size(templist,2)
	kashiwada_larvae(i)=f_kashiwada(0.0305,templist(i)-273,0.0621);
end

hold on;
plot(templist,kashiwada_larvae)
