function plot_v (vnam, n, t, td, V, V_lim, V_fil, V_fdq, V_dft, V_trip)
figure(2*n+1), set(gcf,'color','w');
plot(t,V,'k', t,V_lim,'r', t,V_fil,'g'), hold on, stairs(td,V_fdq,'b');
    hold off, grid on;
legend('Input','Limited','Filtered','Discretized & Quantized');
xlabel('Time [s]'), ylabel([vnam ' [V]']);

figure(2*n+2), set(gcf,'color','w');
subplot(211), stairs(td,V_dft,'r'), grid on, title([vnam ' DFT']);
subplot(212), stairs(td,V_trip,'r','LineWidth',1), grid on;
    title(['Trip ' vnam ' --- Turn off']), xlabel('Time [s]');
