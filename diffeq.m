%vars % set the default variables
%r, m, b
%r

% equation: 18+6.7*sin(2*pi*t/365.24+9.2)
%tempeq=

%function pop=diffeq(timetemp,initpop)
function pop=diffeq(timetemp,initpop,alphas)

tlist = timetemp(:,1);
temps = timetemp(:,2);
pop=zeros(size(tlist,1),4); % initialize blank population matrix
pop(1,:)=initpop; % initialize population at t=0

% differential equations
%function popf=f(pop,t,templist)
function popf=f(pop,t,templist,alphas)
%function popf=f(t,pop,templist)
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
	
	vars % calculate variables from temperature
	
	%alphas=[0 0.01; templist(end,1)+1 0.01];
	%alphas=[0 0.01;220 0.01;235 0.02]
	%alphas=[0 0.01; 200 0.01; 220 0.015; 230 0.02; 235 0.02; 400 0.015; 600 0.01; 1200+1 0.01];
	
	%rainfall_scale = 0.25; % used to calculate alpha from rainfall
	%alphas=[rainfall(:,1) (rainfall_scale ./ rainfall(:,2))];
	
	alpha=interp1(alphas(:,1),alphas(:,2),t,"spline");
	
	popf(1)=b*r(4)*pop(4)-(m(1)+r(1)*(1-gamma))*pop(1);
	popf(2)=r(1)*pop(1)*(1-gamma)-alpha*(pop(2)^2)-(m(2)+r(2))*pop(2);
	popf(3)=r(2)*pop(2)-(m(3)+r(3))*pop(3);
	popf(4)=r(3)*pop(3)/2-(m(4))*pop(4);
	%tmpmatrix=[t temp pop(1) pop(2) pop(3) pop(4)];
	%tmpmatrix=[t temp popf(1) popf(2) popf(3) popf(4)];
	tmpmatrix=[t pop(2) popf(2) (r(1)*pop(1)-(m(2)+r(2))*pop(2)) (r(1)*pop(1)-(m(2)+r(2))*pop(2))/0.009*0.01 alpha];

	%tmpmatrix=[t popf(1) popf(2) popf(3) popf(4) pop(1) pop(2) pop(3) pop(4)];
	%tmpmatrix=[t popf(1) (m(2)+r(2))*pop(2) popf(3) popf(4) pop(1) pop(2) pop(3) pop(4)];
	%tmpmatrix=[t popf(1) popf(2) popf(3) popf(4) (b*r(4)*pop(4)-(m(1)+r(1)*(1-gamma))*pop(1)) (r(1)*pop(1)*(1-gamma)-alpha*(pop(2)^2)-(m(2)+r(2))*pop(2)) (r(2)*pop(2)-(m(3)+r(3))*pop(3)) (r(3)*pop(3)/2-(m(4))*pop(4)) pop(1) pop(2) pop(3) pop(4)];
	%tmpmatrix=[t temp popf(1) popf(2) popf(3) popf(4) (r(1)*pop(1)*(1-gamma)-(m(2)+r(2))*pop(2)) pop(1) pop(2) pop(3) pop(4)];
	
	tmp_2=mat2str(tmpmatrix,4);
	tmpmatrix=eval(tmp_2);
	%output_precision(3);
	%csvwrite("step_out_2014-02-27_aChange.csv",tmpmatrix,"-append")
	%{
	popf(1)=b*(r(4)*pop(4)+r(5)*pop(5))-(m(1)+r(1)*(1-gamma))*pop(1);
	popf(2)=r(1)*pop(1)*(1-gamma)-0.01*pop(2)*pop(2)-(m(2)+r(2))*pop(2);
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

tmparray=[(tlist(1)-lsode_options("minimum step size")),temps(1);tlist temps;(tlist(end)+lsode_options("minimum step size")),temps(end)]; % add extra lines (beginning and end) to the array so that the interpolation doesn't try to evaluate out of bounds
alphas_tmparray=[(alphas(1,1)-lsode_options("minimum step size")),alphas(1,2);alphas;(alphas(end,1)+20),alphas(end,2)];
%fd = @(t,pop)f(t,pop,tmparray);
%[t_junk,pop]=ode45(fd,tlist,pop(1,:));
%fd = @(pop,t)f(pop,t,tmparray);
fd = @(pop,t)f(pop,t,tmparray,alphas_tmparray);

[pop,istate,msg]=lsode(fd,pop(1,:),tlist);
if(istate!=2)
	disp(istate)
	disp(msg)
end


% save plot; this MIGHT be broken, but it could also be because of error-related outputs earlier in the program
%print(strcat("plots/diffeq.svg"),"-dsvg")
%print(strcat("plots/diffeq.png"),"-dpng")

% save the population
%csvwrite("pop_INSERT-DATE.csv",[teven interp1(tmparray(:,1),tmparray(:,2),tlist) pop])

end
