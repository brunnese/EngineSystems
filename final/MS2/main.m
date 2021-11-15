clc 
clear all

load dynamic_0001.mat

Data = meas;

run Par;
timespan = [Data.p_m.time(1) Data.p_m.time(end)];



[t,x,y] = sim('ISC_MS2', timespan, par.simopt);

subplot(3,1,1)
grid on, hold on
plot(t,y(:,1),'g',t,Data.p_m.signals.values,'r')
xlabel('Time [s]')
ylabel('$p_m$ [bar]','interpreter','latex')
subplot(3,1,2)
grid on, hold on
plot(t,y(:,2),'g',t,Data.omega_e.signals.values,'r')
xlabel('Time [s]')
ylabel('$\omega_{e}$ [rad/s]','interpreter','latex')
subplot(3,1,3)
grid on, hold on
plot(t,y(:,3),'g', t, Data.m_dot_alpha.signals.values,'r')
xlabel('Time [s]')
ylabel('$\dot{m}_{\alpha}$ [g/s]','interpreter','latex')
