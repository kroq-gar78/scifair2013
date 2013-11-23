%vars % set the default variables
%r, m, b
%r

% equation: 18+6.7*sin(2*pi*t/365.24+9.2)
%tempeq=

t_start=0; # days
%t_start=templist(1,1);
%t_end=templist(size(templist(:,1),1));
t_end=1200; # days
t_step=1; # days
tlist=linspace(t_start,t_end,(t_end-t_start)/t_step+1)';

%t=templist(1:t_end/t_step,1);
%tlist=templist(1:size(templist(:,1),1)-1,1);
%t=linspace(templist(1,1),templist(size(templist(:,1),1),1),1);

pop=zeros(size(tlist,1),4);
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
	poss=size(templist(:,1),1);
	
	if(templist(end,1)>t)
		poss=find(t<=templist(:,1));
	end
	
	%[t poss(1)]
	temp=templist(poss(1),2);
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

function temp=tempfit(a,b,c,t)
	temp=a+b*cos(2*pi*t/365.25+c);
	%temp=fita+fitb*cos(2*pi*t/365.25+fitc);
end

temps=tempfit(21.2755144118492,18.7014981438,9.2866007993,tlist);

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

fd = @(pop,t)f(pop,t,[tlist temps]);
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
