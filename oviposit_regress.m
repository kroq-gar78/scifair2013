% this does the regression for the amount of eggs per oviposition
function oviposit_regress(degree)

% stage = 'pupae'
phasename = "oviposit";
temp=csvread(strcat("data/",phasename,".csv"));
temp(1,:)=[];
todelete=~any(temp(:,2),2);
temp(todelete,:)=[];
stage=temp(:,2);
temp=temp(:,1);

x=15:35; % might need to be changed; might not even be necessary
p=polyfit(temp,stage,degree); % usually going to be quadratic; might need to be changed for some cases, but not sure

% plot
scatter(temp,stage);
hold on;
f=polyval(p,x);
plot(x,f);
title(strcat("Polynomial regression of oviposition rate"))
xlabel("Temperature (Celsius)")
ylabel("Growth per day")

% save to file
save("-mat",strcat("fit_",phasename,".mat"),"p");

% save plot to both SVG and PNG
print(strcat("plots/fitr_",phasename,".svg"),"-dsvg")
print(strcat("plots/fitr_",phasename,".png"),"-dpng")

end
