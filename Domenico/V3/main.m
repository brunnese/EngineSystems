clc 
clear all

run Par;
timespan = [0 10];
du = -25;
ualpha = 5;
theta_m = 295;
theta_a = 295;
p_a = 10^5;
p_e = 1.2*10^5;
ul=0;

[t,x,y] = sim('ISC_V3', timespan, par.simopt);

subplot(3,1,1)
grid on, hold on
plot(t,y(:,1)/1e5)
xlabel('Time [s]')
ylabel('$p_m$ [bar]','interpreter','latex')
subplot(3,1,2)
grid on, hold on
plot(t,y(:,2)*1e3)
xlabel('Time [s]')
ylabel('$\dot{m}_{\alpha}$ [g/s]','interpreter','latex')
subplot(3,1,3)
grid on, hold on
plot(t,y(:,3)*1e3)
xlabel('Time [s]')
ylabel('$\dot{m}_{\beta}$ [g/s]','interpreter','latex')