clear, clc, close all
fs = 8000; f1 = 1000; f2 = 2000; f3 = 3000;
L = 8000*5; n = (0:L-1);
A = 1/5; % adjust playback volume
x1 = A * cos(2 * pi * n * f1 / fs);
x2 = A * cos(2 * pi * n * f2 / fs);
x3 = A * cos(2 * pi * n * f3 / fs);
noise = (2 * A * rand(1, L) - A) * 0.1; % zero-mean white noise
x = x1 + x2 + x3 + noise;
% x = x1;
sound(x, fs);


y = filter(Num1,1,x);
t = n / fs;
figure;
plot(t, x, 'b');
hold on;
plot(t, y, 'r');
title('input and output signal');
xlabel('seconds');
ylabel('amplitude');
legend('input', 'output');
hold off;
