function Trip_vto = trip_fault_v (t, V_dft, v_to, pc_to, t_init)
N = length(V_dft);
Trip_vto = zeros(1,N); % Trip voltage turn off
c = 0; % counter
for i = 1:N
  if t(i) > t_init
    if V_dft(i) < v_to
      c = c + 1;
      if c > pc_to-1
        Trip_vto(i) = 1; % Turn off detection
      end
    else
      c = 0; % counter reset
    end
  end
end
