% this should eventually be a template for complete regression automation; this is the mortality regression
function r_regress(phasename,degree)

% stage = 'pupae'
%phasename = "larvae"
temp=csvread(strcat("data/r",phasename,".csv"));
temp(1,:)=[]; # delete top row - headers
todelete=~any(temp(:,2),2);
temp(todelete,:)=[]; # delete any rows with a 0-value in the second column
stage=temp(:,2); # stage is the variable with all the mortality rates
temp=temp(:,1);

% need to take reciprocals to convert into rates of development per day
for n=1:size(stage)
	stage(n)=1/stage(n);
end

x=15:35; % might need to be changed; might not even be necessary
p=polyfit(temp,stage,degree); % usually going to be quadratic; might need to be changed for some cases, but not sure

% plot
scatter(temp,stage);
hold on;
f=polyval(p,x);
plot(x,f);
title(strcat("Polynomial regression of ",phasename," growth rate rate"))
xlabel("Temperature (Celsius)")
ylabel("Growth per day")

% save to file
save("-mat",strcat("fitr_",phasename,".mat"),"p");

% save plot to both SVG and PNG
print(strcat("plots/fitr_",phasename,".svg"),"-dsvg")
print(strcat("plots/fitr_",phasename,".png"),"-dpng")

end
