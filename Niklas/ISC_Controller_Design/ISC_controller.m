% Version 1.12.21 16:34

clc
clear all
close all

load dynamic_0001;
run Par;

load LinSys
% linearised matrices
As = A;
Bs = B;
Cs = C;
Ds = D;

% extension
Ki = 8;  % has to be tuned
Ae = 0;
Be = [1 0];
Ce = [Ki; 0];
De = eye(2);

% extended system
A = [As Bs*Ce; zeros(1,10) Ae];
B = [Bs*De; Be];
C = [Cs Ds*Ce];
D = Ds*De;

% LQR 
r1 = 1.5;    % to be tuned
r2 = 0.05;    % to be tuned
R = [r1 0; 0 r2];
Q = C'*C;
K = lqr(A,B,Q,R);


% LQG
q = 0.01;     % to be tuned q → 0: fast observer = trust measurement, q → ∞: slow observer = trust model
L = lqr(A',C',B*B',q)';

% continuous matrices of whole controller
Dc = zeros(2,1);
ISCS_Ac = [Ae -Be*K; zeros(11,1) A-B*K-L*C];
ISCS_Bc = [Be*Dc; -L];
ISCS_Cc = [Ce -De*K];
ISCS_Dc = De*Dc;
sysC = ss(ISCS_Ac,ISCS_Bc,ISCS_Cc,ISCS_Dc);


% discrete matrices
Ts = 0.001;
sysD = c2d(sysC,Ts);
ISCS_Ad = sysD.A;
ISCS_Bd = sysD.B;
ISCS_Cd = sysD.C;
ISCS_Dd = sysD.D;

% normalisation
ISCS_Ty = Ty_omega_e;
ISCS_Tu = [Tu_alpha; Tu_ign];

% create tranfer function 
sysP = ss(As,Bs,Cs,Ds); % linearized system
sysP = c2d(sysP,Ts);
sysC = ss(ISCS_Ad,ISCS_Bd,ISCS_Cd,ISCS_Dd,Ts); % controller

switch 'Obs'
    case 'CL'
        sysD = feedback(sysP * sysC, 1); % T(s)
        G = tf(sysD);
        bode(G)
        grid on
    case 'OL'
        sysD = sysP * sysC; % L(s)
        G = tf(sysD);
        bode(G)
        grid on
    case 'C'
        sysD = sysC; % C(s)
        G = tf(sysD);
        G1 = tf(G.Numerator(1),G.Denominator(1),Ts);
        G2 = tf(G.Numerator(2),G.Denominator(2),Ts);
        figure(1);
        bode(G1,G2)
        grid on
        legend('G_{alpha}','G_{duign}')
    case 'Obs'
        %Bd = [1; zeros(9,1)]; % disturbance only affects omega_e
        %Cd = 1;
        %A_obs = [As, Bd; Cs, Cd];
        %B_obs = [Bs, 0];
        
end


% simulation where timespan last time value
omega_ref = meas.omega_e;
timespan = omega_ref.time(end);

[t,x,y] = sim('simulation', timespan, par.simopt);
% plot of omega, u_alpha and du_ign

figure(2);
subplot(3,1,1)
grid on, hold on
plot(t,y(:,1),omega_ref.time, omega_ref.signals.values,'--')
xlabel('Time [s]')
ylabel('$\omega_{e}$ [rad/s]','interpreter','latex')
subplot(3,1,2)
grid on, hold on
plot(t,y(:,2))
xlabel('Time [s]')
ylabel('$u_{alpha}$ [\%]','interpreter','latex')
subplot(3,1,3)
grid on, hold on
plot(t,y(:,3))
xlabel('Time [s]')
ylabel('$du_{ign}$ [deg]','interpreter','latex')

% error of omega to omega ref for intuitiv tuning
% e = 0;
% for i = 1:length(t)
%     e = e + abs(y(i) - omega_ref)*Ts;
% end

%save('controller1','ISCS_Ty', 'ISCS_Tu', 'ISCS_Ad', 'ISCS_Bd', 'ISCS_Cd', 'ISCS_Dd');   
    
