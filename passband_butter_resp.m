function y = passband_butter_resp (x, t, fcenter, passband)
%passband = frequency passband [Hz]
%fcenter = center frequency [Hz]
fcl = fcenter - passband/2; % lower cuttoff frequency Hz
fcu = fcenter + passband/2; % upper cuttoff frequency Hz
% Band-Pass 2nd order Butterworth analog filter
[num_btw, den_btw] = butter(1, 2*pi*[fcl, fcu], 's');
sys_btw = tf(num_btw, den_btw); % analog filter transfer function
y = lsim(sys_btw, x, t); % output signal