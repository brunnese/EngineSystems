%% LQR Controller Design

clc, clear all, close all

%% Load Params and Matrices

% Replace with any source of system matrices
load Par.mat

%% Extension Matrices

KI = 1; % integrator gain on v; scalar
Ae = zeros(1,1); 
Be = [1 0];
Ce = [KI; 0]; 
De = eye(2);

%% New System Matrices

A = [As, Bs*Ce; zeros(size(Ae,1),size(As,2)), Ae];
B = [Bs*De; Be];
C = [Cs, Ds*Ce];
D = [Ds*De];

%% LQR Gains

% Tunable Input Costs:
r1 = 1; % u_alpha
r2 = 1; % delta_u_zeta

R = diag([r1,r2]); % input cost

Q = C'*C; % state cost (only output is penalized)

K = lqr(A,B,Q,R); % feedback gain

Dc = zeros(2,1); % by definition

%% Observer

q = 1; % observer gain

L = lqr(A',C',B * B',q)'; % observer gain

%% Controller Matrices

% Connecting the extended system and the controller

% CT: 
ISCS_Ac = [Ae, -Be * K; zeros(size(A,1),size(Ae,2)), A-B*K-L*C];
ISCS_Bc = [Be * Dc; -L];
ISCS_Cc = [Ce, -De*K];
ISCS_Dc = [De * Dc];

% Discretization: 
Ts = 1e-3;
sysc = ss(ISCS_Ac, ISCS_Bc, ISCS_Cc, ISCS_Dc);
sysd = c2d(sysc, Ts, 'tustin');

% Controller Matrices
[ISCS_Ad, ISCS_Bd, ISCS_Cd, ISCS_Dd] = ssdata(sysd);