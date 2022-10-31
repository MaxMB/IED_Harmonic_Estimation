function ydq = quantization (yd, nbits, outL, outU)
%nbits = ADC bits
qLevels = 2^nbits; % 1024 qantization levels
% outL = Lower output voltage
% outU = Upper output voltage
scalingFactor = (outU - outL) / qLevels;
ydq = round(yd / scalingFactor) * scalingFactor;