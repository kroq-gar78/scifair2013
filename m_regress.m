% this should eventually be a template for complete regression automation; this is the mortality regression
function m_regress(phasename,degree)

% stage = 'pupae'
%phasename = "pupae"
temp=csvread(strcat("data/m",phasename,".csv"));
temp(1,:)=[]; # delete top row - headers
%todelete=~any(temp(:,2),2);
%temp(todelete,:)=[]; # delete any rows with a 0-value in the second column
stage=temp(:,2); # stage is the variable with all the mortality rates
temp=temp(:,1);

stage=stage/100; % since all of the values in the CSV are of percent units, need to be divided by 100
stage=1-stage; % we're loading the SURVIVAL RATE, NOT THE MORTALITY RATE!

x=15:35; % might need to be changed; might not even be necessary
p=polyfit(temp,stage,degree); % usually going to be quadratic; might need to be changed for some cases, but not sure

% plot
scatter(temp,stage);
hold on;
f=polyval(p,x);
plot(x,f);
title(strcat("Polynomial regression of ",phasename," mortality rate"))
xlabel("Temperature (Celsius)")
ylabel("Mortality rate (%)")

% save to file
save("-mat",strcat("fitm_",phasename,".mat"),"p");

% save plot to both SVG and PNG
print(strcat("plots/fitm_",phasename,".svg"),"-dsvg")
print(strcat("plots/fitm_",phasename,".png"),"-dpng")

end
