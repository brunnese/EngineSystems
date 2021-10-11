% Example script for dynamic parameter iderntification
% Engine Systems Class, IDSC, ETH Zurich

clear; close all; clc;

% Set simulation options. The simset options are a command-based way to 
% define the simulation options. An alternative is to set them in the 
% simulink model itself. Using simset and applying the same options to all 
% simulations through the options-input in the "sim"-command is a way to 
% make sure all simulations use the same options.
    options.sim_options = simset('SrcWorkspace','current');
    
% Load measurement data for parameter identification and add it to
% fmin_data sruct
    load('IntakeManifoldData/DataIdentification.mat');
    
   % Parameters
   cp = 1003;
   cv = 717;
   kappa = cp/cv;
   Vd = 2.5*10^(-3);
   epsilon = 10;
   pe = 10^5;
   R = 287;
   theta_in = 295;
   omega_e = 125;
   endTime = IdData.mdot_in.time(end);

% Display measurement values
    figure;
    subplot(2,1,1);
    plot(IdData.mdot_in.time, IdData.mdot_in.signals.values);
        xlabel('Time [s]');
        legend({'mdot_in'},'Location','NorthWest');
    subplot(2,1,2);
    plot(IdData.p.time, IdData.p.signals.values);
        xlabel('Time [s]');
        legend({'p'},'Location','NorthWest');

% Find the number of open figures, so a new figure can be created and used
% over and over again. This command is not necessarily needed but it is
% nice to have.
    fh=findall(0,'type','figure');
    options.fig_num = length(fh)+1;
    options.enablePlot = 1;
    
% Define starting values of the optimization variables.
    lambda_lw0 = 0.9;
    Vm0 = 3*Vd;
    par0 = [lambda_lw0, Vm0];
    
% Run fminsearch using the error function and find optimal parameter values      
    % Define function with only one input (parameters to be optimized)
        errorfnc_fminsearch = @(par0) modellguete(par0, IdData, options);
    % Call fminsearch    
        opt_options = optimset('Algorithm','sqp','display','iter','Maxit',30);
        optpar = fminsearch(errorfnc_fminsearch, par0, opt_options);

% Extract optimal parameter values                    
    lambda_lw = optpar(1);
    Vm  = optpar(2);

% Load validation data
    load('IntakeManifoldData/DataValidation.mat');

% Run a simulation with the identified optimal variable values
    data.mdot_in = ValData.mdot_in;
    [tValSim,~,yvalsim] = sim('intake_manifold', ValData.mdot_in.time, options.sim_options);

% Graphically represent the quality of the optimization routine
    figure;
    subplot(2,1,1);
    plot(tValSim, ValData.mdot_in.signals.values);
        xlabel('Time [s]');
        ylabel('Inputs');
        legend('mdot_in');
    subplot(2,1,2);
    plot(tValSim, ValData.p.signals.values, ...
        tValSim, p.data);
        xlabel('Time [s]');
        ylabel('Outputs');
        legend('Measured p','Modelled p')
