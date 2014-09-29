clc
clear

% Initializing all Variables

%-----Constants-----

%conductances(ms/cm^2)
gK= 36;
gNa= 120;
gL= .3;

%nernst potentials (mV)
EK=-12;
ENa= 115;
EL= 10.6;
Vrest=-70;

%Capacitance (uF)
Cm= 1; 

%Parameters
t=1:100;

% Creating memory for Vm 
Vm=zeros(1,length(t));

%Initial Conditions (t=0)
am= .1*((25-Vrest)/(exp((25-Vrest)/10)-1));
bm= 4*exp(-Vrest/18);
an= .01*((10*Vrest)/(exp((10*Vrest)/10)-1))
bn= .125* exp(-Vrest/80);
ah=.07*exp(-Vrest/20);
bh=1/(exp((30-Vrest)/10)+1);

mo=am/(am+bm);
no=an/(an+bn);
ho=ah/(ah+bh);

% Provided equations

% Gating variables:
% ? ?m = 0.1?((25?V m)/(exp((25?V m)/10) ? 1))
% ? ?m = 4?exp(?V m/18)
% ? ?n = .01 ? ((10?V m)/(exp((10?V m)/10) ? 1))
% ? ?n = .125?exp(?V m/80)
% ? ?h = .07?exp(?V m/20)
% ? ?h = 1/(exp((30?V m)/10) + 1)
% ? m0 = ?m/(?m+?m)
% ? n0 = ?n/(?n+?n)
% ? h0 = ?h/(?h+?h)
% Currents:
% ? INa = m3?g�Na?h?(V m?ENa)
% ? IK = n
% 4?g�K?(V m?EK)
% ? IL = gL?(V m?EL)
% ? Iion = I?IK?INa?IL
% Derivatives:
% ? dVm/dt = Iion/Cm
% ? dm/dt = ?m?(1?m)??m?m
% ? dn/dt = ?n?(1?n)??n?n
% ? dh/dt = ?h?(1?h)??h?h
% Euler?s method:
% ? yn+1 = yn+h*f(tn,yn)

%What I need to do:
%1. Set all variables/parameters to initial vals
%2. Complete chane in variables using VM
%3. Find nfw, vm, gating variables/gtc
%4. stop when I have reached end of simulation time