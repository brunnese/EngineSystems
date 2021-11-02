run Par;
load("quasistatic_0001.mat");
%%
%alpha0 und alpha1
M_alpha=ones([size(meas.time,1),2]);
M_alpha(:,2)=meas.u_alpha.signals.values;
x_alpha_old=[par.alpha0;par.alpha1];
y_alpha=(meas.m_dot_alpha.signals.values.*sqrt(2*par.R*meas.T_a.signals.values)./meas.p_a.signals.values);
X_alpha=lsqr(M_alpha,y_alpha);
Y_alpha=M_alpha*X_alpha;
y_alpha_old=M_alpha*x_alpha_old;
m_dot_alpha_proj_old=(y_alpha_old./y_alpha.*meas.m_dot_alpha.signals.values);
m_dot_alpha_proj=(Y_alpha./y_alpha.*meas.m_dot_alpha.signals.values);
alpha0_ParID=X_alpha(1);
alpha1_ParID=X_alpha(2);

figure(1)
grid on, hold on;
plot(meas.u_alpha.signals.values,meas.m_dot_alpha.signals.values,'r+',meas.u_alpha.signals.values,m_dot_alpha_proj,'b',meas.u_alpha.signals.values,m_dot_alpha_proj_old,'k');
xlabel('u_{\alpha} [%]');
ylabel('$\dot{m}_{\alpha} [kg/s]$','Interpreter','latex');
hold off


%%
%gamma0 und gamma1
lambdalp=(meas.p_e.signals.values./meas.p_m.signals.values);
lambdalp=(par.Vc+par.Vd)/par.Vd-lambdalp.^(1/par.kappa)*par.Vc/par.Vd;

M_lambda=ones([size(meas.time,1),2]);
M_lambda(:,2)=meas.omega_e.signals.values;
x_lambda_old=[par.gamma0;par.gamma1];
y_lambda=(4*pi*par.R/par.Vd*meas.T_m.signals.values.*meas.m_dot_alpha.signals.values./meas.p_m.signals.values./meas.omega_e.signals.values./lambdalp.*(1+1./meas.lambda.signals.values/par.sigma0));
X_lambda=lsqr(M_lambda,y_lambda);
Y_lambda=M_lambda*X_lambda;
y_lambda_old=M_lambda*x_lambda_old;
gamma0_parID=X_lambda(1);
gamma1_ParId=X_lambda(2);

figure(2);
subplot(3,1,1);
grid on, hold on;
plot(meas.omega_e.signals.values,y_lambda,'r+',meas.omega_e.signals.values,Y_lambda,'b',meas.omega_e.signals.values,y_lambda_old,'k');
xlabel('\omega_{e}');
ylabel('\lambda_{l\omega}');
hold off;
subplot(3,1,2);
hold on;
plot(meas.omega_e.signals.values,lambdalp,'+');
xlabel('\omega_{e}');
ylabel('\lambda_{lp}','Interpreter','tex');
hold off;
subplot(3,1,3);
hold on;
plot(meas.omega_e.signals.values,lambdalp.*y_lambda,'+')
xlabel('\omega_{e}');
ylabel('\lambda_{l}');
