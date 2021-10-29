% Simulation Options

par.simopt = simset('Solver','ode1','FixedStep',1e-3,'SrcWorkspace', 'current');


% Thermodynamics
par.R = 287;

% Throttle
par.alpha0 = 3*1e-6;
par.alpha1 = 6*1e-6;

% Intake Manifold
par.Vm = 7*1e-3;

% Engine mass flow
par.Vd = 2.48*1e-3;
par.Vc = 2.48*1e-4;
par.sigma0 = 14.7;
par.kappa = 1.35
par.gamma0 = .6;
par.gamma1 = .002;
par.mdot_beta0 = 0.01;

% Engine torque generation
par.Hl = 42.5*1e6;
par.k = 2.3345*1e-4;
par.eta0 = .3;
par.eta1 = -3*1e-4;
par.beta0 = 7;
par.p_me0f = par.beta0*4*pi/par.Vd;
par.lambda = 1;

% Engine inertia
par.thetaE = .2;
par.omegae0 = 100;

% Load torque
par.etaGen = .7;
par.Pl = 1000;
