function yd = samp_fast (y, Ns, pd)
yd = zeros(1,Ns); % discrete signal
yd(1) = y(1);
for i = 1:Ns
    yd(i) = y(pd*i);
end