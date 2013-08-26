% this does the regression for the amount of eggs per oviposition

% stage = 'pupae'
phasename = "oviposit"
temp=csvread(strcat("data/",phasename,".csv"));
temp(1,:)=[];
todelete=~any(temp(:,2),2);
temp(todelete,:)=[];
stage=temp(:,2);
temp=temp(:,1);

x=15:35; % might need to be changed; might not even be necessary
p=polyfit(temp,stage,2); % usually going to be quadratic; might need to be changed for some cases, but not sure

% plot
scatter(temp,stage);
hold on;
f=polyval(p,x);
plot(x,f);

% save to file
save("-mat",strcat("fit_",phasename,".mat"),"p");
