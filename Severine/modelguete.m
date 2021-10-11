function V = modellguete(par, data, options)

% This is the so called 'error function' (modellguete.m) that is used in 
% combination with fminsearch.

% Set global optimization variables
%     global tau beta
  
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
   endTime = data.mdot_in.time(end);

% Assign new parameter values (used in Simulink model SystemModel.slx)
    lambda_lw = par(1);
    Vm  = par(2);

% Run simulation to determine the quality of the parameter values    
    [tsim,~,ysim] = sim( 'intake_manifold', data.mdot_in.time, options.sim_options );

% Calculate objective function
    V = sum((data.p.signals.values-p.data).^2);

% plot curves
if options.enablePlot
    figure(options.fig_num);
    plot(data.p.time, data.p.signals.values, 'b'); hold on; grid on;
    plot(p.time, p.data, '-r' ); hold off;
    xlabel('Time [s]');
    ylabel('Model Ooutput [-]');
	legend({'Measurements','Simulation'},'Location','NorthEast')
    set(gca,'XLim',[data.p.time(1) data.p.time(end)]);
    set(gca,'YLim',[min(data.p.signals.values)-1/10*mean(data.p.signals.values) max(data.p.signals.values)+1/10*mean(data.p.signals.values)]);
    drawnow;
end
