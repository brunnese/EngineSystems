clc
clear all

load dynamic_0001;
run Par;

load LinSys
% linearised matrices
As = A;
Bs = B;
Cs = C;
Ds = D;

% extension
Ki = 12;  % has to be tuned c1: ki = 8
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
r1 = 2;    % to be tuned: c1 r1= 1.5
r2 = 0.01;    % to be tuned: c1, r2 = 0.05
R = [r1 0; 0 r2];
Q = C'*C;
K = lqr(A,B,Q,R);


% LQG
q = 0.1;     % to be tuned c1 q = 0.01, 
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
sysC = ss(As,Bs,Cs,Ds);
sysD = c2d(sysC,Ts);
G = tf(sysD);
G1 = tf(G.Numerator(1),G.Denominator(1),Ts);
G2 = tf(G.Numerator(2),G.Denominator(2),Ts);

% bode plot
figure(1);
bode(G1,G2)
grid on
legend('G_{alpha}','G_{duign}')


% normalisation
ISCS_Ty = Ty_omega_e;
ISCS_Tu = [Tu_alpha; Tu_ign];


% simulation where timespan last time value
omega_ref = meas.omega_e;
timespan = omega_ref.time(end);

[t,x,y] = sim('simulation', timespan, par.simopt);
% plot of omega, u_alpha and du_ign

e = 0;
for i = 1:timespan
    e = e + abs(meas.omega_e.signals.values(i) - y(i,1));
end



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

ISCS_Tu = diag(ISCS_Tu);
% to save controller as mat file
%save('controller3','ISCS_Ty', 'ISCS_Tu', 'ISCS_Ad', 'ISCS_Bd', 'ISCS_Cd', 'ISCS_Dd');   
    
