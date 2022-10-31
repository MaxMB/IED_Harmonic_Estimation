close, clear, clc;
%pkg load signal;
k = 7; % highest odd harmonic
N = 1e5; % number of points
t = linspace(0, 0.2, N); % time
fn = 60; % natural frequency [Hz]
Amp = 115/sqrt(3); % fundamental amplitude ~66.4V
harm_div = 1/2; % harmonic decay

%%% Clean input signal
x = zeros(1,N); % input signal
for i = 1:k % odds harmonics only
  if (mod(i,2)==1)
    x = x + Amp * harm_div^(i-1) * sin(2*pi*fn*i*t);
  end
end

%%% White Gaussian Noise
SNR_dB = 40; % signal-to-noise ratio [dB]
% noise standard deviation
sd_n = sqrt(var(x) + mean(x)^2) * 10^(-SNR_dB/20);
x = x + sd_n * randn(1,N); % adding noise

%%% Transient signal --- Gaussian PDF
xt = 2 * normpdf(t, (t(N)-t(1))/2, 0.05);
x = x + xt;

%%% Conditioning --- Linear Mapping
inL = -Amp; % Lower input voltage
inU = Amp; % Lower input voltage
outL = 0; % Lower output voltage
outU = 5; % Upper output voltage
x_cond = (outU - outL) * (x - inL) / (inU - inL) + outL;

%%% Protection --- Limiter [y1, y2]
for i = 1:N
    if (x_cond(i) < outL)
        x_cond(i) = outL;
    elseif (x_cond(i) > outU)
        x_cond(i) = outU;
    end
end

%%% Fundamental
x0_cond = (outU-outL)/2 * sin(2*pi*fn*t) + (outU+outL)/2;

%%% Analog Filter
passband = 20; % frequency passband [Hz]
fcenter = fn; % center frequency [Hz]
fcl = fcenter - passband/2; % lower cuttoff frequency Hz
fcu = fcenter + passband/2; % upper cuttoff frequency Hz
% Band-Pass 2nd order Butterworth analog filter
[num_btw, den_btw] = butter(1, 2*pi*[fcl, fcu], 's');
sys_btw = tf(num_btw, den_btw); % analog filter transfer function
dc_offset = (outU - outL)/2;
y = lsim(sys_btw, x_cond, t) + dc_offset; % output signal

%%% Sampling --- fs/fn = points per cycle
pc = 16; % sampled points per cycle
fs = pc * fn; % Sampling frequency
dt = t(N) - t(1); % time variation
np = round(dt * fs); % number of sampled points
pd = floor(N / np); % point distance
td = zeros(1,np); % discrete time
td(1) = t(1);
yd = zeros(1,np); % discrete signal
yd(1) = y(1);
for i = 1:np
    td(i) = t(pd*i);
    yd(i) = y(pd*i);
end

%%% Quantization
nbits = 10; % ADC bits
qLevels = 2^nbits; % 1024 qantization levels
scalingFactor = (outU - outL) / qLevels;
yd_qt = round(yd / scalingFactor) * scalingFactor;

%%% FFT
fas = 1 / (t(2)-t(1)); % analog sampling frequency
nc = round(N / (dt * fn)); % analog points per fundamental cycle
if (mod(nc,2)==1)
    nc = nc + 1;
end
L = N - nc + 1;
X_cond = abs(fft(x_cond(L:N)) / nc); % fft
X_cond = [X_cond(1), 2*X_cond(2:nc/2), X_cond(nc/2+1)]; % mirror fft
Y = abs(fft(y(L:N)) / nc); % fft
Y = [Y(1); 2*Y(2:nc/2); Y(nc/2+1)]; % mirror fft
freq_fft = fas * (0:(nc/2)) / nc;

%%% Plot
figure(1), set(gcf,'color','w');
plot(t,x0_cond,'b', t,x_cond,'k', t,y,'r');
hold on, stairs(td,yd_qt,'g'), hold off;
legend('Fundamental', 'Input', 'Output', 'Digital Output');
xlabel('Time [s]'), ylabel('Voltage [V]'), grid on;

figure(2), set(gcf,'color','w');
opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(sys_btw, opts), grid on;

figure(3), set(gcf,'color','w');
subplot(211), stem(freq_fft, X_cond, 'r'), grid on;
xlabel('f (Hz)'), ylabel('|X_{cond}(f)|'), xlim([0,1e3]);
subplot(212), stem(freq_fft, Y, 'r'), grid on;
xlabel('f (Hz)'), ylabel('|Y(f)|'), xlim([0,1e3]);

figure(4), set(gcf,'color','w');
plot(t, xt, 'k'), grid on;
xlabel('Time [s]'), ylabel('Voltage [V]');
