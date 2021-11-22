clc
clear all

run Par;

load LinSys
% linearised matrices
As = A;
Bs = B;
Cs = C;
Ds = D;

% extension
Ki = 1;  % has to be tuned
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
r1 = 1;    % to be tuned
r2 = 1;    % to be tuned
R = [r1 0; 0 r2];
Q = C'*C;
K = lqr(A,B,Q,R);

% LQG
q = 1;     % to be tuned q → 0: fast observer = trust measurement, q → ∞: slow observer = trust model
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

ISCS_Ty = Ty_omega_e;
ISCS_Tu = [Tu_alpha; Tu_ign];


% simulation
omega_ref = 100;
timespan = 1:10:10000;

[t,x,y] = sim('simulation', timespan, par.simopt);

figure;
grid on, hold on
plot(t,y)
xlabel('Time [s]')
ylabel('$\omega_{e}$ [rad/s]','interpreter','latex')
