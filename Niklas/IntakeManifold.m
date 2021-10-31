% Example script for dynamic parameter iderntification
% Engine Systems Class, IDSC, ETH Zurich

clear; close all; clc;

c_p = 1003; % Specific heat capacity at constant pressure [J/(kg*K)]
c_v = 717; % Specific heat capacity at constant volume [J/(kg*K)]
kappa = c_p/c_v; % Isentropic coefficient[-]
V_d = 2.5*10^-3; % Engine displacement volume [m^3]
epsilon = 10; % Compression Ratio [-]
p_e = 10^5; % Pressure of the exhaust gas trapped at TDC [Pa]
R = 287; % Specific gas constant [J/(kg*K)]
T_in = 295; % Temperature of the air entering the manifold [K]
omega_e = 125; % Engine speed [rad/s]
%V_m = 8*10^-3; % Volume of the intake manifold [m^3]
%lambda_lw = 1; % Fitting constant for volumetric efficiency [-]


% Set simulation options. The simset options are a command-based way to 
% define the simulation options. An alternative is to set them in the 
% simulink model itself. Using simset and applying the same options to all 
% simulations through the options-input in the "sim"-command is a way to 
% make sure all simulations use the same options.
    options.sim_options = simset('SrcWorkspace','current','FixedStep',1e-2);
    
% Load measurement data for parameter identification and add it to
% fmin_data sruct
    load('DataIdentification.mat');

% Display measurement values
    figure;
    subplot(2,1,1);
    plot(IdData.mdot_in.time, IdData.mdot_in.signals.values);
        xlabel('Time [s]');
        legend({'mdot_in'},'Location','NorthWest');
    subplot(2,1,2);
    plot(IdData.p.time, IdData.p.signals.values);
        xlabel('Pressure [Pa]');
        legend({'p'},'Location','NorthWest');

% Find the number of open figures, so a new figure can be created and used
% over and over again. This command is not necessarily needed but it is
% nice to have.
    fh=findall(0,'type','figure');
    options.fig_num = length(fh)+1;
    options.enablePlot = 1;
    
% Define starting values of the optimization variables.
    par0 = [8e-3, 1];
    
% Run fminsearch using the error function and find optimal parameter values      
    % Define function with only one input (parameters to be optimized)
        errorfnc_fminsearch = @(par0) modellguete(par0, IdData, options);
    % Call fminsearch    
        opt_options = optimset('Algorithm','sqp','display','iter','Maxit',30);
        optpar = fminsearch(errorfnc_fminsearch, par0, opt_options);

% Extract optimal parameter values                    
    V_m = optpar(1);
    lambda_lw  = optpar(2);

% Load validation data
    load('DataValidation.mat');

% Run a simulation with the identified optimal variable values
    data.mdot_in = ValData.mdot_in;
    [tValSim,~,pValSim] = sim('SystemModel', ValData.mdot_in.time, options.sim_options);

% Graphically represent the quality of the optimization routine
    figure;
    subplot(2,1,1);
    plot(tValSim, ValData.mdot_in.signals.values);
        xlabel('Time [s]');
        ylabel('Input');
        legend('mdot_in');
    subplot(2,1,2);
    plot(tValSim, ValData.p.signals.values, ...
        tValSim, pValSim);
        xlabel('Time [s]');
        ylabel('Output');
        legend('Measured p','Modelled p')