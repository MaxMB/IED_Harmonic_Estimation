function [y, ux] = dft_mag (x, ux, uc, us, nw, na)
%ux = [ux(2:nw), x]; % Shift left array
ux(na) = x; % circular array
% Yc = 2 * (ux*uc') / nw
% Ys = 2 * (ux*us') / nw
% |Y| = sqrt(Yc^2 + Ys^2) = 
y = 2 * sqrt((ux*uc')^2 + (ux*us')^2) / nw; % DFT
