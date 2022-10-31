function [y, sd_v] = noise_gen (x, SNR_dB)
% SNR_dB = signal-to-noise ratio [dB]
N = length(x);
sd_v = sqrt(var(x) + mean(x)^2) * 10^(-SNR_dB/20);
y = x + sd_v * randn(1,N);