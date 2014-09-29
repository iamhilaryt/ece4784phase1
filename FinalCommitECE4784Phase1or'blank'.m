clc
clear

% Initializing all Variables

coffee= input('You did not drink anything with caffeine (1) You did drink something with caffeine(2) You want to prevent your neuron from dying (3) ')

if (coffee == '2')
    I=5;
end
if (coffee == '1')
    I=0;
end





%-----Constants-----

%nernst potentials (mV)
EK=-12;
ENa= 115;
EL= 10.6;
Vrest=-70;

%Capacitance (uF)
Cm= 1; 



%Time Parameters
step= .02; % if any larger than derivatives and changes will not work
t=1:step:100;

% Creating memory  
Vm= zeros(1,length(t));
m= zeros(1,length(t));
n= zeros(1,length(t));
h= zeros(1,length(t));
gNa= zeros(1,length(t));
gK= zeros(1,length(t));
I= zeros(1,length(t));

%max conductances(ms/cm^2)
g_K= 36;
g_Na= 120;
g_L= .3;



%Initial Conditions (t=0)
%Vm(1)=0;
am= .1*((25-Vm(1))/(exp((25-Vm(1))/10)-1));
bm= 4*exp(-Vm(1)/18);
an= .01*((10-Vm(1))/(exp((10-Vm(1))/10)-1));
bn= .125* exp(-Vm(1)/80);
ah= .07*exp(-Vm(1)/20);
bh= 1/(exp((30-Vm(1))/10)+1);

m0= am/(am+bm);
n0= an/(an+bn);
h0= ah/(ah+bh);

%setting position 1 = initial condition
m(1)= m0;
n(1)= n0;
h(1)= h0;


%Initializing conductances
gNa(1)= ((m(1))^3)*g_Na*h(1);
gK(1)= ((n(1))^4)*g_K;
% no need to initialize gL because its just gL

% This part inserts  a 'pulse' into the current vector
if (coffee == '3')
    for j=1:.5/step
        I(j)=5;
    end
end

%-----Iterating for simulation-----
% has to start at 2 or else eulers wont work
for i=2:length(t)
    

    % change in gating variables    
    am= .1*((25-Vm(i-1))/(exp((25-Vm(i-1))/10)-1));
    bm= 4*exp(-Vm(i-1)/18);
    an= .01*((10-Vm(i-1))/(exp((10-Vm(i-1))/10)-1));
    bn= .125* exp(-Vm(i-1)/80);
    ah= .07*exp(-Vm(i-1)/20);
    bh= 1/(exp((30-Vm(i-1))/10)+1);
    
    % calculate next iteration probabilities
    h(i) = h(i-1)+(step*((ah*(1-h(i-1)))-(bh*h(i-1))));
    m(i) = m(i-1)+(step*((am*(1-m(i-1)))-(bm*m(i-1))));
    n(i) = n(i-1)+(step*((an*(1-n(i-1)))-(bn*n(i-1))));
    
    
    %Updating conductances
    gNa(i)= ((m(i-1))^3)*g_Na*h(i-1);
    gK(i)= ((n(i-1))^4)*g_K;
    
    %Updating ion current values using given equs.
    INa = gNa(i)*(Vm(i-1)-ENa);
    IK = gK(i)*(Vm(i-1)-EK);
    IL = g_L*(Vm(i-1)-EL);
    
    %Updating Iion = I?IK?INa?IL, I is sum of all currents
    Iion(i)= I(i)-INa-IK-IL;
    
    changeVm= step*(Iion(i)/Cm);
    
     Vm(i) = changeVm + Vm(i-1);
end


%accounting for Vrest
Vm2 = Vm + Vrest;


% graph results
figure(1)
plot(t,Vm2,'g','linewidth',2)
title('Membrane Potential Vs. Time')
xlabel('Time (ms)')
ylabel('Membrane Voltage (mV)')


figure(2)
hold on
plot(t,gNa,'b','linewidth',2)

plot(t,gK,'r','linewidth',2)
plot(t,g_L,'c','linewidth',2)

title('gNa, gK, gL Vs. Time')
xlabel('Time (ms)')
ylabel('Conductance (ms/cm^2')
legend('gNa', 'gK', 'g_L')
