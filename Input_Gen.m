close, clear, clc;
M = dlmread('Case4.csv');

m = 4000;
%m = max(size(M));
n = 1:m;

t = M(n,2) * 1e-6; % [s] --- Medido originalmente em us

v_amp = 115 / sqrt(3); % [V]
vANs = M(n,3);
vANs = cond_prot(vANs, 0, 4096, -v_amp, v_amp);
vANs = noise_gen(vANs', 30);
vBNs = M(n,4);
vBNs = cond_prot(vBNs, 0, 4096, -v_amp, v_amp);
vBNs = noise_gen(vBNs', 30);
vCNs = M(n,5);
vCNs = cond_prot(vCNs, 0, 4096, -v_amp, v_amp);
vCNs = noise_gen(vCNs', 30);

i_amp = 6; % [A]
iALs = M(n,6);
iALs = cond_prot(iALs, 0, 4096, -i_amp, i_amp);
iALs = noise_gen(iALs', 30);
iBLs = M(n,7);
iBLs = cond_prot(iBLs, 0, 4096, -i_amp, i_amp);
iBLs = noise_gen(iBLs', 30);
iCLs = M(n,8);
iCLs = cond_prot(iCLs, 0, 4096, -i_amp, i_amp);
iCLs = noise_gen(iCLs', 30);

Mw = [t'; vANs; vBNs; vCNs; iALs; iBLs; iCLs];
dlmwrite('Case4_mod.csv',Mw);

figure(1);
subplot(211), plot(t,vANs, t,vBNs, t,vCNs), grid on;
subplot(212), plot(t,iALs, t,iBLs, t,iCLs), grid on;