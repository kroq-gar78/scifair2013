% set up and run the main solver

lsode_options("minimum step size",1.E-6) % set time step to 0.0001 so that the time step doesn't become too small (also for efficiency); 0.0001 days ~= 6 seconds, so shouldn't affect the result

function temp=tempfit(a,b,c,t)
	temp=a+b*cos(2*pi*t/365.25+c);
	%temp=fita+fitb*cos(2*pi*t/365.25+fitc);
end

%t_start=0; # days
%t_start=templist(1,1);
t_start=rainfall(1,1);
%t_end=templist(size(templist(:,1),1));
t_end=rainfall(size(rainfall(:,1),1)); # days
t_step=1; # days
teven=linspace(t_start,t_end,(t_end-t_start)/t_step+1)'; % uniformly/evenly spaced time intervals

%tlist=templist(1:t_end/t_step,1);
%tlist=templist(1:end,1);
tlist=teven;

%temps=tempfit(26.89,3.82,10.1188,tlist); % double hump
%temps=tempfit(18,6.7,9.2,tlist); % sinusoidal for Buenos Aires (from Otero, et al. 2006)
%temps=tempfit(26.89,3.82,10.12,tlist);
temps=templist(:,2);
%temps=zeros(size(teven,1),1)+27; % constant temperature of 27
%temps=zeros(size(teven,1),1)+22.21735781261146;

%{
% testing manual splitting of the execution
idx = 4;
pop=diffeq([tlist(1:idx) temps(1:idx)],[E L P A1]);
%tmp=diffeq([tlist(idx:end) temps(idx:end)], (pop(end,:) ./ 2));
tmp=diffeq([tlist(idx:end) temps(idx:end)], (pop(end,:)));
pop=[pop;tmp(2:end,:)];
%}

%pop=diffeq([tlist temps],[E L P A1],[rainfall(:,1) (.25 ./ rainfall(:,2))]);
pop=diffeq([tlist temps],[E L P A1],[rainfall(:,1) (.4 ./ rainfall(:,2))]);

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
