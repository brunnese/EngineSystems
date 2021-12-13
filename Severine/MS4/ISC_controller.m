clc
clear all

load ctrltest_0024;
run Par;

load LinSys
% linearised matrices
As = A;
Bs = B;
Cs = C;
Ds = D;

% extension
Ki = 4;  % has to be tuned c1: ki = 8 , c4: ki = 4;
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
r1 = 2;    % to be tuned: c1 r1= 1.5, c4 r1 = 2;
r2 = 0.01;    % to be tuned: c1, r2 = 0.05, c4 r2 = 0.01;
R = [r1 0; 0 r2];
Q = C'*C;
K = lqr(A,B,Q,R);


% LQG
q = 0.05;     % to be tuned c1 q = 0.01, c4 q= 0.05
% q → 0: fast observer = trust measurement, q → ∞: slow observer = trust model
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

% create tranfer function 
%sysD = ss(ISCS_Ad,ISCS_Bd,ISCS_Cd,ISCS_Dd,Ts);
sysC = ss(A,B,C,D);
sysD = c2d(sysC,Ts);
G = tf(sysD);
G1 = tf(G.Numerator(1),G.Denominator(1),Ts);
G2 = tf(G.Numerator(2),G.Denominator(2),Ts);

% bode plot
figure(1);
bode(G1,G2)
grid on
legend('G_{alpha}','G_{duign}')

% nyquist plot
figure(2);
nyquist(G1,G2)
legend('G_{alpha}','G_{duign}')

% normalisation
ISCS_Ty = Ty_omega_e;
ISCS_Tu = [Tu_alpha; Tu_ign];


% simulation where timespan last time value
% omega ref is the desired trajectory
% ul is the signal whether load is on or off
omega_ref = meas.omega_e_desired;
ul = meas.u_l;
timespan = omega_ref.time(end);
[t,x,y] = sim('simulation', timespan, par.simopt);

% set up cost function
k_ign = 2.3345*1e-4;
kmax = 1/(1 - k_ign*Tu_ign^2);
dualpha = gradient(y(:,2),Ts);
error_function = 0.2*kmax^2.5*abs(meas.omega_e_desired.signals.values - y(:,1))+ abs(dualpha);
cost = trapz(t, error_function);

fprintf('The total cost is %d.\n',cost);

% plot of omega, u_alpha and du_ign
figure(3);
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

ISCS_Tu = diag(ISCS_Tu);
%save('controller4','ISCS_Ty', 'ISCS_Tu', 'ISCS_Ad', 'ISCS_Bd', 'ISCS_Cd', 'ISCS_Dd');   
    
