clc, clear, close all
n = 0 : 20;
step_signal_0 = zeros(size(n)); % Initialize with zeros
step_signal_0(n >= 0) = 1;     % Set the value to 1 for n >= 12

step_signal_10 = zeros(size(n)); % Initialize with zeros
step_signal_10(n >= 10) = 1;     % Set the value to 1 for n >= 12

x = step_signal_0 - step_signal_10;

a = conv(x,x);

figure(1);

stem(a);
title('a');
xlabel('n');
ylabel('Convolution Result');
grid on;

b = conv(a,x);
c = conv(b,x);
d = conv(c,x);

figure(3);
stem( b);
title('b');
xlabel('n');
ylabel('Convolution Result');
grid on;

figure(4);
stem( c);
title('c');
xlabel('n');
ylabel('Convolution Result');
grid on;

figure(5);
stem( d);
title('d');
xlabel('n');
ylabel('Convolution Result');
grid on;

%% q2
clc, clear, close all
[impr,fs] = audioread('impr.wav');
plot(impr);
title('impr');
xlabel('t');
ylabel('A');

%soundsc(impr);

[y,fs] = audioread('oilyrag.wav');

c = conv(y,impr);
soundsc(c);

%% q3
% Define the input signal and angular frequencies
clc, clear, close all
x = [1, 2, 3, 4];
w = linspace(-3*pi, 3*pi, 100);  % Angular frequencies from -pi to pi

h1 = [1/4 1/2 1/4];
h2 = [-1/4 1/2 -1/4];

% Calculate the DTFT
% output_dtft = calculate_dtft(x, w);
% 
% % Plot the magnitude of the DTFT
% plot(w, abs(output_dtft));
% xlabel('Angular Frequency (w)');
% ylabel('Magnitude of DTFT');
% title('DTFT of the Input Signal');
output_dtft_h1 = calculate_dtft(h1, w);
output_dtft_h2 = calculate_dtft(h2, w);

figure(1)
subplot(2,1,1);
plot(w,output_dtft_h1);
xlabel('Angular Frequency (w)');
ylabel('Magnitude of DTFT');
title('DTFT of the Input Signal');

subplot(2,1,2);
plot(w,output_dtft_h2);
xlabel('Angular Frequency (w)');
ylabel('Magnitude of DTFT');
title('DTFT of the Input Signal');

function output_dtft = calculate_dtft(x, w)
    % x: Input signal vector
    % w: Discrete-time frequency vector
    
    % Calculate the sample index vector 'n'
    N = length(x);
    n = -ceil((N-1)/2):floor((N-1)/2);

    % Initialize the output DTFT
    output_dtft = zeros(size(w));
    
    % Calculate the DTFT using the formula
    for k = 1:length(w)
        output_dtft(k) = sum(x .* exp(-1i * w(k) * n));
    end
end












