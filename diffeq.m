%vars % set the default variables
%r, m, b
%r

% equation: 18+6.7*sin(2*pi*t/365.24+9.2)
%tempeq=

lsode_options("minimum step size",1.E-4) % set time step to 0.0001 so that the time step doesn't become too small (also for efficiency); 0.0001 days ~= 6 seconds, so shouldn't affect the result

function temp=tempfit(a,b,c,t)
	temp=a+b*cos(2*pi*t/365.25+c);
	%temp=fita+fitb*cos(2*pi*t/365.25+fitc);
end

%t_start=0; # days
t_start=templist(1,1);
t_end=templist(size(templist(:,1),1));
%t_end=2000; # days
t_step=0.5; # days
teven=linspace(t_start,t_end,(t_end-t_start)/t_step+1)'; % evenly spaced time intervals

%tlist=templist(1:t_end/t_step,1);
tlist=templist(1:end,1);
%tlist=teven;

%temps=tempfit(26.89,3.82,10.1188,tlist); % double hump
temps=templist(:,2);

pop=zeros(size(teven,1),4);
pop(1,:)=[E;L;P;A1];

%{
global fita = 18.0
global fitb = 0.7
global fitc = 9.2
%}

function popf=f(pop,t,templist)
	%temp=tempfit(18.0,6.7,9.2,t);
	%temp=tempfit(fita,fitb,fitc);
	%temp=33; % 18, 21, 24, 27, 30, 33
	#temp=temp;
	%poss=find(ismember(t,templist(:,1)))
	%{
	format long;
	display(t)
	
	poss=size(templist(:,1),1);
	
	if(templist(end,1)>t)
		poss=find(t<=templist(:,1));
	end
	
	%[t poss(1)]
	temp=templist(poss(1),2);
	%}
	temp=interp1(templist(:,1),templist(:,2),t,"spline");
	
	vars % set the default variables
	
	popf(1)=b*r(4)*pop(4)-(m(1)+r(1)*(1-0.63))*pop(1);
	popf(2)=r(1)*pop(1)*(1-0.63)-0.01*pop(2)*pop(2)-(m(2)+r(2))*pop(2);
	popf(3)=r(2)*pop(2)-(m(3)+r(3))*pop(3);
	popf(4)=r(3)*pop(3)/2-(m(4))*pop(4);
	
	%{
	popf(1)=b*(r(4)*pop(4)+r(5)*pop(5))-(m(1)+r(1)*(1-0.63))*pop(1);
	popf(2)=r(1)*pop(1)*(1-0.63)-0.01*pop(2)*pop(2)-(m(2)+r(2))*pop(2);
	popf(3)=r(2)*pop(2)-(m(3)+r(3))*pop(3);
	popf(4)=r(3)*pop(3)/2-(m(4)+r(4))*pop(4);
	popf(5)=r(4)*pop(4)-m(4)*pop(5);
	%}
end

%{
%global templist=tempfit(24.27056,2.8,18.30016,t)
for n=1:size(tlist,1)-1
	#global temp = templist(n)
	%temp=17.8995;
	%temp=18;
	%temp=tempfit(18.0,6.7,9.2,t(n));
	temp=templist(n,2);
		
	fd = @(pop,t)f(pop,t,temp);
	
	[tmp,istate,msg]=lsode(fd, pop(n,:), [tlist(n),tlist(n+1)]);
	if(istate!=2)
		disp(msg)
	end
	%pop(n+1,:)=tmp(2,:);
	pop(n+1,:)=tmp(2,1:size(pop,2));
end
%}

tmparray=[(tlist(1)-lsode_options("minimum step size")),temps(1);tlist temps;(tlist(end)+lsode_options("minimum step size")),temps(end)]; % add extra line to the array so that the interpolation doesn't try to evaluate out of bounds
fd = @(pop,t)f(pop,t,tmparray);
%fd = @(pop,t)f(pop,t,[teven temps]);
[pop,istate,msg]=lsode(fd,pop(1,:),tlist);
if(istate!=2)
	disp(msg)
end

% plot and annotate
%plot(tlist,pop)
plot(tlist,pop(:,4))
%plot(t,[pop(:,1:3) pop(:,4)+pop(:,5)])
%title("Populations of stages of Aedes aegypti over time");
%xlabel("Time (days)");
%ylabel("Population");
%legend("Eggs","Larvae","Pupae","Adults (1)","Adults (2)");
%legend("Eggs","Larvae","Pupae","Adults");
legend("Adults");

% save plot; this MIGHT be broken, but it could also be because of error-related outputs earlier in the program
%print(strcat("plots/diffeq.svg"),"-dsvg")
%print(strcat("plots/diffeq.png"),"-dpng")

% save the population
%csvwrite("pop_INSERT-DATE.csv",[teven interp1(tmparray(:,1),tmparray(:,2),tlist) pop])
