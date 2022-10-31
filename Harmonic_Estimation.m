close, clear, clc;
%pkg load signal; % Octave

M = dlmread('Case4_mod.csv');
t = M(1,:); % [s]
VANs = M(2,:); % [V]
VBNs = M(3,:);
VCNs = M(4,:);
IALs = M(5,:); % [kA] --- [A]
IBLs = M(6,:);
ICLs = M(7,:);

%%% Conditioning & Protecting
v_amp = 115 / sqrt(3); % [V]
i_amp = 6; % [A]
in_amp = 5; % [V]
VANs_lim = cond_prot(VANs, -v_amp, v_amp, -in_amp, in_amp);
VBNs_lim = cond_prot(VBNs, -v_amp, v_amp, -in_amp, in_amp);
VCNs_lim = cond_prot(VCNs, -v_amp, v_amp, -in_amp, in_amp);
IALs_lim = cond_prot(IALs, -i_amp, i_amp, -in_amp, in_amp);
IBLs_lim = cond_prot(IBLs, -i_amp, i_amp, -in_amp, in_amp);
ICLs_lim = cond_prot(ICLs, -i_amp, i_amp, -in_amp, in_amp);

%%% Analog Filter
fn = 60; % fundamental frequency [Hz]
passband = 20;
VANs_fil = passband_butter_resp(VANs_lim, t, fn, passband);
VBNs_fil = passband_butter_resp(VBNs_lim, t, fn, passband);
VCNs_fil = passband_butter_resp(VCNs_lim, t, fn, passband);
IALs_fil = passband_butter_resp(IALs_lim, t, fn, passband);
IBLs_fil = passband_butter_resp(IBLs_lim, t, fn, passband);
ICLs_fil = passband_butter_resp(ICLs_lim, t, fn, passband);

%%% Sampling
sppc = 8; % sampled points per cycle
[td, VANs_fd, Ts, Ns, pd] = sampling(t, VANs_fil, sppc, fn);
VBNs_fd = samp_fast(VBNs_fil, Ns, pd);
VCNs_fd = samp_fast(VCNs_fil, Ns, pd);
IALs_fd = samp_fast(IALs_fil, Ns, pd);
IBLs_fd = samp_fast(IBLs_fil, Ns, pd);
ICLs_fd = samp_fast(ICLs_fil, Ns, pd);

%%% Quantization
nbits = 10;
VANs_fdq = quantization(VANs_fd, nbits, -in_amp, in_amp);
VBNs_fdq = quantization(VBNs_fd, nbits, -in_amp, in_amp);
VCNs_fdq = quantization(VCNs_fd, nbits, -in_amp, in_amp);
IALs_fdq = quantization(IALs_fd, nbits, -in_amp, in_amp);
IBLs_fdq = quantization(IBLs_fd, nbits, -in_amp, in_amp);
ICLs_fdq = quantization(ICLs_fd, nbits, -in_amp, in_amp);

%%% Harmonic Estimation
nw = sppc; % DFT window size
dft_cw = zeros(1,nw); % DFT cossine window
dft_sw = zeros(1,nw); % DFT sine window
VANs_dftw = zeros(1,nw); % DFT VANs window
VANs_dft = zeros(1,Ns);  % DFT VANs
VBNs_dftw = zeros(1,nw); % DFT VBNs window
VBNs_dft = zeros(1,Ns);  % DFT VBNs
VCNs_dftw = zeros(1,nw); % DFT VCNs window
VCNs_dft = zeros(1,Ns);  % DFT VCNs
IALs_dftw = zeros(1,nw); % DFT IALs window
IALs_dft = zeros(1,Ns);  % DFT IALs
IBLs_dftw = zeros(1,nw); % DFT IBLs window
IBLs_dft = zeros(1,Ns);  % DFT IBLs
ICLs_dftw = zeros(1,nw); % DFT ICLs window
ICLs_dft = zeros(1,Ns);  % DFT ICLs
for k = 1:Ns % DFT
  [na, dft_cw, dft_sw] = dft_cs(k, dft_cw, dft_sw, fn, Ts, nw);
  [VANs_dft(k), VANs_dftw] = dft_mag(VANs_fdq(k), VANs_dftw, ...
      dft_cw, dft_sw, nw, na);
  [VBNs_dft(k), VBNs_dftw] = dft_mag(VBNs_fdq(k), VBNs_dftw, ...
      dft_cw, dft_sw, nw, na);
  [VCNs_dft(k), VCNs_dftw] = dft_mag(VCNs_fdq(k), VCNs_dftw, ...
      dft_cw, dft_sw, nw, na);
  [IALs_dft(k), IALs_dftw] = dft_mag(IALs_fdq(k), IALs_dftw, ...
      dft_cw, dft_sw, nw, na);
  [IBLs_dft(k), IBLs_dftw] = dft_mag(IBLs_fdq(k), IBLs_dftw, ...
      dft_cw, dft_sw, nw, na);
  [ICLs_dft(k), ICLs_dftw] = dft_mag(ICLs_fdq(k), ICLs_dftw, ...
      dft_cw, dft_sw, nw, na);
end

%%% Tripping
% Voltage turn off
v_to = cond_prot(v_amp/10, -v_amp, v_amp, -in_amp, in_amp);
% Current turn off
i_to = cond_prot(i_amp/10, -i_amp, i_amp, -in_amp, in_amp);
pc_to = nw*2; % Points cycle turn off --- double cycle
i_oc = cond_prot(2.5, -i_amp, i_amp, -in_amp, in_amp); % Over current
pc_oc = nw/2; % Points cycle over current --- half cycle
t_init = 0.15; % Initializing time [us]
VANs_trip_to = trip_fault_v(td, VANs_dft, v_to, pc_to, t_init);
VBNs_trip_to = trip_fault_v(td, VBNs_dft, v_to, pc_to, t_init);
VCNs_trip_to = trip_fault_v(td, VCNs_dft, v_to, pc_to, t_init);
[IALs_trip_to, IALs_trip_oc] = trip_fault_i(td, IALs_dft, i_to, ...
    pc_to, i_oc, pc_oc, t_init);
[IBLs_trip_to, IBLs_trip_oc] = trip_fault_i(td, IBLs_dft, i_to, ...
    pc_to, i_oc, pc_oc, t_init);
[ICLs_trip_to, ICLs_trip_oc] = trip_fault_i(td, ICLs_dft, i_to, ...
    pc_to, i_oc, pc_oc, t_init);
%{
%%% Plot
plot_v('VANs', 0, t, td, VANs, VANs_lim, VANs_fil, VANs_fdq, ...
    VANs_dft, VANs_trip_to);
plot_v('VBNs', 1, t, td, VBNs, VBNs_lim, VBNs_fil, VBNs_fdq, ...
    VBNs_dft, VBNs_trip_to);
plot_v('VCNs', 2, t, td, VCNs, VCNs_lim, VCNs_fil, VCNs_fdq, ...
    VCNs_dft, VCNs_trip_to);
plot_i('IALs', 3, t, td, IALs, IALs_lim, IALs_fil, IALs_fdq, ...
    IALs_dft, IALs_trip_to, IALs_trip_oc);
plot_i('IBLs', 4, t, td, IBLs, IBLs_lim, IBLs_fil, IBLs_fdq, ...
    IBLs_dft, IBLs_trip_to, IBLs_trip_oc);
plot_i('ICLs', 5, t, td, ICLs, ICLs_lim, ICLs_fil, ICLs_fdq, ...
    ICLs_dft, ICLs_trip_to, ICLs_trip_oc);
%}