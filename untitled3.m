clc;
clear;
% Initialize Time
stepsize = 1/10000; % This is the step size taken to get from 0 to 100
t = [0:stepsize:100]; %Time

% Constants
gKcon = 36; %mS/cm^2
gNacon = 120; %mS/cm^2
gL = 0.3; %mS/cm^2
EK = -12; %mS/cm^2
ENa = 115; %mV
EL = 10.6; %mV
Vrest = 0; %mV Originally -70mV, but this will be corrected at the end.
           %Simplification method based on Piazza comment.
Cm = 1; %uF/cm^2

% Initial Conditions
Vm = ones(1,length(t)).*0; %Initializes the membrane voltage vector which 
                           %is the same size as the time vector, to zero
  
am = 0.1*((25-Vrest)/(exp((25-Vrest)/10)-1));
bm = 4*exp(-1*Vrest/18);
an = 0.01*((10-Vrest)/(exp((10-Vrest)/10)-1));
bn = 0.125*exp(-1*Vrest/80);
ah = 0.07*exp(-1*Vrest/20);
bh = 1/(exp((30-Vrest)/10)+1);
    % This block above are the given equations for alpha and beta
    
mo = am/(am+bm);
no = an/(an+bn);
ho = ah/(ah+bh);
    % Calculates the initial probabilities m,n, and h

I = 0; %Injected current initialized to zero

m(1) = mo;
n(1) = no;
h(1) = ho;
gNa(1) = ((m(1))^3)*gNacon*h(1);
gK(1) = (n((1))^4)*gKcon;
    % The first values are initialized into there respective vectors
    % because the for loop starts at 2.
    
    % The for loop starts at 2 so eulers method can be used so n(the next 
    % value) will bebase off of (n - 1)(the pervious value or "current") 
for i = 2:length(t)
    
    am = 0.1*((25-Vm(i-1))/(exp((25-Vm(i-1))/10)-1));
    bm = 4*exp(-1*Vm(i-1)/18);
    an = 0.01*((10-Vm(i-1))/(exp((10-Vm(i-1))/10)-1));
    bn = 0.125*exp(-1*Vm(i-1)/80);
    ah = 0.07*exp(-1*Vm(i-1)/20);
    bh = 1/(exp((30-Vm(i-1))/10)+1);
        % The new values of the alpha's and beta's are calculated here
        % based off the previous (n-1) voltage value. 
    
    m(i) = m(i-1)+(stepsize*((am*(1-m(i-1)))-(bm*m(i-1))));
    n(i) = n(i-1)+(stepsize*((an*(1-n(i-1)))-(bn*n(i-1))));
    h(i) = h(i-1)+(stepsize*((ah*(1-h(i-1)))-(bh*h(i-1))));
        % These are the derivative equations used to calculate the next 
        % probabilities m,n, an h. These values are scaled by the step size
  
    gNa(i) = ((m(i-1))^3)*gNacon*h(i-1);
    gK(i) = (n((i-1))^4)*gKcon;
        % The calculation of conductances for Na and K.  
    
    INa = ((m(i-1))^3)*gNacon*h(i-1)*(Vm(i-1)-ENa);
    IK = (n((i-1))^4)*gKcon*(Vm(i-1)-EK);
    IL = gL*(Vm(i-1)-EL);
        % The calculation of each individual currect based on the previous
        % voltage and/or probability values
    
    Iion(i) = I - INa - IK - IL;
        % Total currect found as a summation
    
    dVm = (Iion(i)/Cm)*stepsize;
        % Derivative equation for voltage
    
    Vm(i) = Vm(i-1)+(dVm);
        % New voltage calculation based off previous value and derivative
    
end

Vmm = Vm + ones(1,length(t))*-70;

figure
plot(t,Vmm)
figure
plot(t,gNa,'r')
figure
plot(t,gK,'b')