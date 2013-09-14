%vars % set the default variables
%r, m, b
%r

% equation: 18+6.7*sin(2*pi*t/365.24+9.2)
%tempeq=

t_start=0; # days
t_end=200; # days
t_step=1; # days
t=linspace(t_start,t_end,(t_end-t_start)/t_step+1)';

pop=zeros(size(t,1),4);
pop(1,:)=[E;L;P;Ah];
for n=1:size(t,1)-1
	%temp=templist(n);
	%temp=17.8995;
	temp=18;
	function popf=f(pop,t)
		temp=pop(5);
		vars % set the default variables
		%{
		popf(1)=b*r(6)*pop(6)-(m(1)+r(1))*pop(1);
		popf(2)=r(1)*pop(1)-(m(2)+r(2))*pop(2);
		popf(3)=r(2)*pop(2)-(m(3)+r(3))*pop(3);
		popf(4)=r(3)*pop(3)-(m(4)+r(4))*pop(4);
		popf(5)=r(4)*pop(4)-(m(5)+r(5))*pop(5);
		popf(6)=r(5)*pop(5)-(m(6))*pop(6);
		%}
		popf(1)=b*r(4)*pop(4)-(m(1)+r(1))*pop(1);
		popf(2)=r(1)*pop(1)-(m(2)+r(2))*pop(2);
		popf(3)=r(2)*pop(2)-(m(3)+r(3))*pop(3);
		popf(4)=r(3)*pop(3)-(m(4))*pop(4);
		popf(5)=0;
	end
	
	[tmp,istate,msg]=lsode("f", [pop(n,:) temp], [0,t(n+1)-t(n)]);
	if(istate!=2)
		disp(msg)
	end
	%pop(n+1,:)=tmp(2,:);
	pop(n+1,:)=tmp(2,1:size(pop,2));
end

%pop = lsode("f", [E;L;P;Ah], (t=linspace(0,800,1600)'));
%[t,pop] = rk4('f',[0,50],[E;L;P;Ah;Ar;Ao]);

% plot and annotate
plot(t,pop)
title("Populations of stages of Aedes aegypti over time");
xlabel("Time (days)");
ylabel("Population");
legend("Eggs","Larvae","Pupae","Adults");

% save plot; this MIGHT be broken, but it could also be because of error-related outputs earlier in the program
%print(strcat("plots/diffeq.svg"),"-dsvg")
%print(strcat("plots/diffeq.png"),"-dpng")
