% Simulation Options

par.simopt = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace', 'current');


% Thermodynamics
par.R = 287;

par.alpha0 = 2.03355255389880e-06;% Initial guess: 3*1e-6;
par.alpha1 = 6.12871897972141e-06;% Initial guess: 6*1e-6;

% Intake Manifold
par.Vm = 0.005561622619629;% Initial guess: 7*1e-3;


% Engine mass flow
par.Vd = 2.48*1e-3;
par.Vc = 2.48*1e-4;
par.sigma0 = 14.7;
par.kappa = 1.35
par.gamma0 = .6823;% Initial guess: 0.6;
par.gamma1 = 8.6052e-4;% Initial guess: 0.002;
par.mdot_beta0 = 0.01;

% Engine torque generation
par.Hl = 42.5*1e6;
par.k = 2.3345*1e-4;
par.eta0 = 0.3068; %0.368238150312718;%.3;  other estimate : 0.3068
par.eta1 = -3.02*1e-4; %-5.035702051889969e-04;%-3*1e-4; other estimate : -3.02*10^-4
par.beta0 = 6.78; %11.310594467121987;%7; other estimate : 6.78
par.p_me0f = par.beta0*4*pi/par.Vd; 
par.lambda = 1;

% Engine inertia
par.thetaE = 0.205; %0.250056378585116;%.2; other estimate: 0.205
par.omegae0 = 100;

% Load torque
par.etaGen = .7;
par.Pl = 1000;

% simulation
par.lambda = 1;
par.p_a = 10^5;
par.p_e = 10^5;
par.theta_a = 298;
par.theta_m = 300;
par.ul = 0;
par.pm_initial = 0.3*10^5;
par.omegae_initial = 70;

