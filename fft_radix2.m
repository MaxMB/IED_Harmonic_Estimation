%%% Radix-2 decimation-in-time (DIT) Cooley-Tukey algorithm for FFT
function X = fft_radix2 (x, p)
n = 2^p;

% Bit Reverse Order (BRO) algorithm --- Record order
X = [bitrevorder(x)', zeros(n,1)];
%{
bro = [1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31,...
    2, 18, 10, 26, 6, 22, 14, 30, 4, 20, 12, 28, 8, 24, 16, 32];
X = zeros(n,2);
for k = 1:n
    X(k,1) = x(bro(k));
end
%}

for s = 1:p
    m = 2^s;
    %wm = exp(-2*pi*1i/m);
    % cos(-x) = cos(x)
    % sin(-x) = - sin(x)
    wm = cordic(-2*pi/m, 28);
    %wm(2) = - wm(2);
    for k = 0:m:(n-1)
        w = [1, 0];
        for j = 1:(m/2)
            u = X(k + j, :);
            %t = w * X(k + j + m/2);
% t = (w1 + 1e*w2) * (X1 + 1e*X2) = (w1*X1 - w2*X2) + 1e*(w1*X2 + w2*X1)
            t = X(k + j + m/2, :);
            t = [w(1)*t(1) - w(2)*t(2), w(1)*t(2) + w(2)*t(1)];
            X(k + j, :) = u + t;
            X(k + j + m/2, :) = u - t;
            %w = w * wm;
            w = [w(1)*wm(1) + w(2)*wm(2), w(2)*wm(1) - w(1)*wm(2)];
        end
    end
end

X = X(:,1) + 1i * X(:,2);

end