function V = modellguete(par, data, options)

% This is the so called 'error function' (modellguete.m) that is used in 
% combination with fminsearch.

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

% Set global optimization variables
%     global V_m lambda_lw

% Assign new parameter values (used in Simulink model SystemModel.slx)
    V_m = par(1);
    lambda_lw  = par(2);

% Run simulation to determine the quality of the parameter values    
    [tsim,~,psim] = sim( 'SystemModel', data.mdot_in.time, options.sim_options );

% Calculate objective function
    V = sum((data.p.signals.values-psim).^2);

% plot curves
if options.enablePlot
    figure(options.fig_num);
    plot(data.p.time, data.p.signals.values, 'b'); hold on; grid on;
    plot(tsim, psim, '-r' ); hold off;
    xlabel('Time [s]');
    ylabel('Model Output [-]');
	legend({'Measurements','Simulation'},'Location','NorthEast')
    set(gca,'XLim',[data.p.time(1) data.p.time(end)]);
    set(gca,'YLim',[min(data.p.signals.values)-1/10*mean(data.p.signals.values) max(data.p.signals.values)+1/10*mean(data.p.signals.values)]);
    drawnow;
end