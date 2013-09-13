% this gets the mortality regression of the adults (female)
function m_adults(degree)

% stage = 'pupae'
phasename = "adults";
temp=csvread(strcat("data/m",phasename,".csv"));
temp(1,:)=[];
todelete=~any(temp(:,2),2);
temp(todelete,:)=[];
stage=temp(:,2);
temp=temp(:,1);

% since all of the values in the CSV are days, reciprocals are needed for rates
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

% save to file
save("-mat",strcat("fitm_",phasename,".mat"),"p");

end
