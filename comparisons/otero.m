% from Otero et. al 2005

% non-linear, freaky exponential type thingy; temperature in Kelvin

R=8.3144621; % universal gas constant

function dev=f_otero(t,rdk,dha,dhh,thalf)
	R=8.3144621; % universal gas constant
	%dev=rdk*((t/298)*exp((ha/R)(1/298-1/t))/(1+exp(hh/R)(1/thalf-1/t)));
	dev=rdk*((t/298)*exp((dha/R)*(1/298-1/t))/(1+exp((dhh/R)*(1/thalf-1/t))));
end

# egg hatching
%t=temp;
otero_eggs=zeros(1,size(templist,2))';
for i=1:size(templist,2)
	otero_eggs(i)=f_otero(templist(i),0.24,10798,100000,14184);
end
%otero_eggs=f_otero(templist,0.24,10798,100000,14184);

plot(templist,otero_eggs)

# larval development
otero_larvae=zeros(1,size(templist,2))';
for i=1:size(templist,2)
	otero_larvae(i)=f_otero(templist(i),0.2088,26018,55990,304.6);
end

hold on;
plot(templist,otero_larvae)

# pupal development
otero_pupae=zeros(size(templist,2))';
for i=1:size(templist,2)
	otero_pupae(i)=f_otero(templist(i),0.384,14931,-472379,148);
end

plot(templist,otero_pupae)
