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

%Initial current
I=0;

%Time Parameters
step= 1
t=1:100;

% Creating memory  
Vm= zeros(1,length(t));
m= zeros(1,length(t));
n= zeros(1,length(t));
h= zeros(1,length(t));
gNa= zeros(1,length(t));
gK= zeros(1,length(t));



%Initial Conditions (t=0)
am= .1*((25-Vrest)/(exp((25-Vrest)/10)-1));
bm= 4*exp(-Vrest/18);
an= .01*((10*Vrest)/(exp((10*Vrest)/10)-1));
bn= .125* exp(-Vrest/80);
ah= .07*exp(-Vrest/20);
bh= 1/(exp((30-Vrest)/10)+1);

m0= am/(am+bm);
n0= an/(an+bn);
h0= ah/(ah+bh);

%setting position 1 = initial condition
m(1)= m0;
n(1)= n0;
h(1)= h0;
Vm(1)=0;

%Initializing conductances
gNa0= ((m(1))^3)*gNa*h(1);
gK0= ((n(1))^4)*gk;
% no need to initialize gL because its just gL


%Iterating for simulation
for i=2:length(t)
    
    m(i)= m(i-1)+(step*((am*(1-m(i-1)))-(bm*m(i-1))));
    h(i) = h(i-1)+(step*((ah*(1-h(i-1)))-(bh*h(i-1))));
    n(i) = n(i-1)+(step*((an*(1-n(i-1)))-(bn*n(i-1))));
    % change in gating variables    
    am= .1*((25-Vm(i-1))/(exp((25-Vrest)/10)-1));
    bm= 4*exp(-Vm(i-1)/18);
    an= .01*((10*Vm(i-1))/(exp((10*Vrest)/10)-1));
    bn= .125* exp(-Vm(i-1)/80);
    ah= .07*exp(-Vm(i-1)/20);
    bh= 1/(exp((30-Vm(i-1))/10)+1);
    
    h(i) = h(i-1)+(step*((ah*(1-h(i-1)))-(bh*h(i-1))));
    m(i) = m(i-1)+(step*((am*(1-m(i-1)))-(bm*m(i-1))));
    n(i) = n(i-1)+(step*((an*(1-n(i-1)))-(bn*n(i-1))));
    
    
    %Updating conductances
    gNa(i)= ((m(i-1))^3)*gNa*h(i-1);
    gK(i)= ((n(i-1))^4)*gk;
    
    %Updating current values using given equs.
    INa = ((m(i-1))^3)*gNa*h(i-1)*(Vm(i-1)-ENa);
    IK = (n((i-1))^4)*gKcon*(Vm(i-1)-EK);
    IL = gL*(Vm(i-1)-EL);
    
    %Updating Iion = I?IK?INa?IL
    Iion= I
    
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
% ? INa = m3?g¯Na?h?(V m?ENa)
% ? IK = n
% 4?g¯K?(V m?EK)
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