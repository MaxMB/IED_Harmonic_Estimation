function plot_i (inam, n, t, td, I, I_lim, I_fil, I_fdq, I_dft, ...
    I_trip_to, I_trip_oc)
figure(2*n+1), set(gcf,'color','w');
plot(t,I,'k', t,I_lim,'r', t,I_fil,'g'), hold on, stairs(td,I_fdq,'b');
    hold off, grid on;
legend('Input','Limited','Filtered','Discretized & Quantized');
xlabel('Time [s]'), ylabel([inam ' [A]']);

figure(2*n+2), set(gcf,'color','w');
subplot(311), stairs(td,I_dft,'r'), grid on;
    title([inam ' DFT --- Discretized & Quantized signal']);
subplot(312), stairs(td,I_trip_to,'r','LineWidth',1), grid on;
    title(['Trip ' inam ' --- Turn off']);
subplot(313), stairs(td,I_trip_oc,'r','LineWidth',1), grid on;
    title(['Trip ' inam ' --- Over current']), xlabel('Time [s]');
