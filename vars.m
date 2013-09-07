% variable definitions (current/initial populations, growth/death rates)

%temp=25;

%E = 3000;
E=10;
L = 100;
P = 100;
%Ah = 100;
Ah = 10;
Ar = 100;
Ao = 100;

% const
%r=new int[6] % advancement rate (e.g. egg -> larva)
% r={egg,larva,pupa,adult-host,adult-rest,adult-oviposit}
%r=[.48,0.14,0.5,0.0,0.03,0.4];
%m=new int[6] % death/mortality rate
%m=[0.688,0.44,0.52,0.18,0.0043,0.41];

load fitr_eggs.mat;
reggs_p=p; # weights for transition rate of eggs
load fitr_larvae.mat;
rlarvae_p=p; # weights for transition rate of larvae
load fitr_pupae.mat;
rpupae_p=p; # weights for transition rate of pupae


load fitm_eggs.mat;
meggs_p=p; # weights for death rate of eggs
load fitm_larvae.mat;
mlarvae_p=p; # weights for death rate of larvae
load fitm_pupae.mat;
mpupae_p=p; # weights for death rate of pupae
load fitm_adults.mat;
madults_p=p; # weights for death rate of adults

%b=16; % number of female eggs laid per oviposition
load fit_oviposit.mat;
oviposit_p=p;
b=polyval(oviposit_p,temp)/2; if(b<0); b=0; disp("Oviposition amount less than 0"); end

% r={egg,larva,pupa,ovipositRate}
%r=[.48 .14 .5 .4];
%r=[.48 .14 .5 .1];
r=[polyval(reggs_p,temp) polyval(rlarvae_p,temp) polyval(rpupae_p,temp) .4];
for n=1:4; if(r(n)<0); r(n)=0; end; end;
% m={egg,larva,pupa,adult}
%m=[.688 .44 .52 .41];
%m=[.9 .6 .52 1/20];
m=[polyval(meggs_p,temp) polyval(mlarvae_p,temp) polyval(mpupae_p,temp) polyval(madults_p,temp)];
for n=1:4; if(m(n)>1); m(n)=1; end; end;
