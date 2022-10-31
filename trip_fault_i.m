function [Trip_ito, Trip_ioc] = trip_fault_i (t, I_dft, i_to, ...
	pc_to, i_oc, pc_oc, t_init)
N = length(I_dft);
Trip_ito = zeros(1,N); % Trip current turn off
Trip_ioc = zeros(1,N); % Trip over current
c_to = 0; % counter turn off
c_oc = 0; % counter over current
for i = 1:N
  if t(i) > t_init
    if I_dft(i) < i_to
      c_to = c_to + 1;
      if c_to > pc_to-1
        Trip_ito(i) = 1; % Turn off detection
      end
    else
      c_to = 0; % counter reset
      if I_dft(i) > i_oc
        c_oc = c_oc + 1;
        if c_oc > pc_oc
          Trip_ioc(i) = 1; % Overcurrent detection
        end
      else
        c_oc = 0; % counter reset
      end
    end
  end
end
