function [n, uc, us] = dft_cs (k, uc, us, fn, Ts, nw)
psi = 2*pi*fn * Ts; % = 2*pi/nw
%cs = [cos(psi*k), sin(psi*k)];
cs = cordic(psi*k, 28);

% Array shift
%N = length(uc);
%uc = [uc(2:N), cs(1)]; % Shift left array
%us = [us(2:N), cs(2)]; % Shift left array

% Circular array
n = mod(k, nw);
if n == 0
    n = nw;
end
uc(n) = cs(1);
us(n) = cs(2);