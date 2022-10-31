function [L, H] = kalman_matrix (k, sd_v, fn, Ts)
global P;
Rv = sd_v^2;
psi = 2*pi*fn * Ts;
%H = [cos(psi*k), sin(psi*k)];
H = cordic(psi*k, 28);
L = P * H' * (H*P*H' + Rv)^(-1); % Kalman gain
P = (eye(2) - L*H) * P; % Covarian matrix update

%{
P = P - P * H' * (H*P*H' + Rv)^(-1) * H * P; % Covarian matrix update
L = P * H' * sd_v^(-2); % Kalman gain
%}
