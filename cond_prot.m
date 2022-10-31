function y = cond_prot (x, inL, inU, outL, outU)
N = length(x);

%%% Conditioning --- Linear Mapping
% inL = Lower input voltage
% inU = Lower input voltage
% outL = Lower output voltage
% outU = Upper output voltage
y = (outU - outL) * (x - inL) / (inU - inL) + outL;

%%% Protection --- Limiter [y1, y2]
for i = 1:N
  if (y(i) < outL)
    y(i) = outL;
  elseif (y(i) > outU)
    y(i) = outU;
  end
end
