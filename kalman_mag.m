function [mag_rms, xs] = kalman_mag (k, xs, L, H, y)
xs = xs + L * (y(k) - H * xs);
mag_rms = sqrt(xs' * xs);% / sqrt(2); % RMS: X_RMS = X / sqrt(2)
%yc(k) = xs(1);
%ys(k) = xs(2);
%mag = sqrt(yc.^2 + ys.^2);
%ang = atan(ys./yc);
