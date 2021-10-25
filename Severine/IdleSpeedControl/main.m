clc 
clear all

run Par;
timespan = [0 10];
du = 25;
ualpha = 5;
theta_m = 293;
theta_a = 293;
p_a = 10^5;
p_e = 1.2*10^5;

simout = sim('ISC_V1', timespan, par.simopt);
