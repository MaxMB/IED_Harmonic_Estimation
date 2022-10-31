function [td, yd, Ts, Ns, pd] = sampling (t, y, pc, fb)
% pc = sampled points per cycle
% fb = max frequency boundary
N = length(t);
fs = pc * fb; % Sampling frequency
Ts = 1 / fs; % Sampling period
dt = t(N) - t(1); % time variation
Ns = round(dt * fs); % number of sampled points
pd = floor(N / Ns); % point distance
Ns = Ns + floor((t(N)-t(pd*Ns))/Ts); % adjust Ns
td = zeros(1,Ns); % discrete time
td(1) = t(1);
yd = zeros(1,Ns); % discrete signal
yd(1) = y(1);
for i = 1:Ns
    td(i) = t(pd*i);
    yd(i) = y(pd*i);
end
