close, clear, clc;
fcenter = 60;
passband = 20;
%passband = frequency passband [Hz]
%fcenter = center frequency [Hz]
fcl = fcenter - passband/2; % lower cuttoff frequency Hz
fcu = fcenter + passband/2; % upper cuttoff frequency Hz
% Band-Pass 2nd order Butterworth analog filter
[num_btw, den_btw] = butter(1, 2*pi*[fcl, fcu], 's');
sys_btw = tf(num_btw, den_btw); % analog filter transfer function

figure(1), set(gcf,'color','w');
opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(sys_btw, opts), grid on;
%xlim([10,100]);