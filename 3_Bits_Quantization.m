clc, clear, close all
% q1
%t = linspace(0,0.5,50);
t = 0:1/100:0.5;
%t_cont = linspace(0,0.5,1000);
t_cont = 0:1/1000:0.5;
A = 5;
f = [10,25,40,60,40,60];
phi = [0,0,0,0,pi/2,pi/2];
x = zeros(length(f),51);
x_cont = zeros(length(f),length(t_cont));
for i=1:length(f)
    x(i,:) = A*cos(2.*pi.*f(i).*t+ phi(i));
    
    figure(1)
    subplot(2, 3, i);
    stem(t, x(i, :));
    xlabel("n");
    ylabel("x(n)");
    title(sprintf("figure A - A=5 - f=%d - phase=%.2f", f(i), phi(i)));
    
    figure(2)
    subplot(2, 3, i);
    plot(t, x(i, :));
    xlabel("n");
    ylabel("x(n)");
    title(sprintf("figure A - A=5 - f=%d - phase=%.2f", f(i), phi(i)));


    x_cont(i,:) = A*cos(2.*pi.*f(i).*t_cont+ phi(i));
    
    figure(3)
    subplot(2, 3, i);
    plot(t_cont, x_cont(i, :));
    xlabel("n");
    ylabel("x(n)");
    title(sprintf("figure A - A=5 - f=%d - phase=%.2f", f(i), phi(i)));
end

%% q2
clc, clear, close all
% Define the range of samples
n = 1:30;

%a
% Create the unit impulse signal δ[n - 16]
impulse_signal_16 = zeros(size(n)); % Initialize with zeros
impulse_signal_16(n == 16) = 1;     % Set the value to 1 at n = 16

% Create the unit step signal u[n - 12]
step_signal_12 = zeros(size(n)); % Initialize with zeros
step_signal_12(n >= 12) = 1;     % Set the value to 1 for n >= 12

%b
% Create the unit impulse signal u[n - 14]
step_signal_14 = zeros(size(n)); % Initialize with zeros
step_signal_14(n >= 14) = 1;     % Set the value to 1 at n = 14

% Create the unit impulse signal u[n - 15]
step_signal_15 = zeros(size(n)); % Initialize with zeros
step_signal_15(n >= 15) = 1;     % Set the value to 1 at n = 15

% difference sig
new_impulse_x1 = step_signal_14 - step_signal_15;

%c

% Create the unit impulse signal u[n - 9]
step_signal_9 = zeros(size(n)); % Initialize with zeros
step_signal_9(n >= 9) = 1;     % Set the value to 1 at n = 9

% Create the unit impulse signal u[n - 16]
step_signal_16 = zeros(size(n)); % Initialize with zeros
step_signal_16(n >= 16) = 1;     % Set the value to 1 at n = 16

% difference sig
new_impulse_x2 = step_signal_9 - step_signal_16;
x2_width = sum(new_impulse_x2);


% Plot both signals using stem()
figure(1)
subplot(2, 1, 1);
stem(n, impulse_signal_16);
xlabel('n');
ylabel('δ[n - 16]');
title('Unit Impulse Signal δ[n - 16]');

subplot(2, 1, 2);
stem(n, step_signal_12);
xlabel('n');
ylabel('u[n - 12]');
title('Unit Step Signal u[n - 12]');

figure(2)
stem(n,new_impulse_x1)
xlabel('n');
ylabel('δ[n - K]');
title('step signal 14 - step signal 15');

figure(3)
stem(n,new_impulse_x2)
xlabel('n');
ylabel('δ[n - K]');
title('step signal 9 - step signal 16');

%% q3
clc, clear, close all
% note to self
% x=A⋅(cos(wn)+i⋅sin(wn))
% re(x) = A*cos(wn)
% im(x) = A*sin(wn)
n = 1:40;
A = 1;
w = pi/10;
x = A*exp(i*w*n);

figure(1)
plot(real(x),imag(x))
xlabel('real');
ylabel('imag');

figure(2)
subplot(2, 1, 1);
stem(n, real(x));
xlabel('n');
xlabel('n');
ylabel('x(n)');
title('real');

subplot(2, 1, 2);
stem(n, imag(x));
xlabel('n');
xlabel('n');
ylabel('x(n)');
title('imag');

% Calculate the magnitude and phase of x[n]
magnitude = abs(x);
phase = angle(x);

figure(3)
% Create separate stem plots for magnitude and phase
subplot(2, 1, 1);
stem(n, magnitude);
xlabel('Sample Number (n)');
ylabel('Magnitude');
title('Magnitude of x[n]');

subplot(2, 1, 2);
stem(n, phase);
xlabel('Sample Number (n)');
ylabel('Phase (radians)');
title('Phase of x[n]');


%% q4
close all
[y ,fs] = audioread('defineit.wav');

t = (0:length(y) - 1)/fs;

%b
figure(1)
subplot(2,1,1)
plot(t, y);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('Audio wave');

subplot(2,1,2)
histogram(y,50);
xlabel ("Amplitude distribution");
ylabel ("Count of sample");
title("sample distribution before scaling")
%c
%soundsc(y,fs);

y_scaled = (y/max(abs(y)));

%d, e and f
% Define the number of bits
num_bits = 3;

% Define the range of the input signal
input_min = -1;
input_max = 1;

% Calculate the step size
step_size = (input_max - input_min) / (2^num_bits);

% Create a vector of quantization levels
quantization_levels = input_min + step_size/2 : step_size : input_max - step_size/2;

% Read the input signal (replace 'input_signal.wav' with your input signal)
%y = audioread('input_signal.wav');

% Quantize the input signal
y3bits = zeros(size(y));

for i = 1:length(y_scaled)
    % Find the closest quantization level
    [~, index] = min(abs(y_scaled(i) - quantization_levels));
    
    % Assign the quantized value
    y3bits(i) = quantization_levels(index);
end

figure(2)
subplot(3,1,1)
plot(t, y_scaled);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('y_scaled');

subplot(3,1,2)
plot(t, y3bits);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('y3bits');

subplot(3,1,3)
histogram(y3bits,quantization_levels+step_size/2);
xlabel ("Amplitude distribution");
ylabel ("Count of sample");
title ("sample after quantization")

%soundsc(y3bits,fs);


% calculate and display the quantization error
quantization_error = y_scaled - y3bits;
mean_squared_error = mean(quantization_error.^2);
disp(['Mean Squared Error: ', num2str(mean_squared_error)]);

figure(3)
subplot(2,1,1)
plot(t, quantization_error);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('quantization error');

subplot(2,1,2)
histogram(quantization_error,50);
xlabel ("error distribution");
ylabel ("Count of sample");
title("quantization error distribustion")

%soundsc(quantization_error,fs);
%g
y3bits_pclip = zeros(size(y));

y_pclip = y/(max(y)-0.05);
for i = 1:length(y_pclip)
    % Find the closest quantization level
    [~, index] = min(abs(y_pclip(i) - quantization_levels));
    
    % Assign the quantized value
    y3bits_pclip(i) = quantization_levels(index);
end


figure(4)
subplot(3,1,1)
plot(t, y_pclip);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('y_pclip');

subplot(3,1,2)
plot(t, y3bits_pclip);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('y3bits_pclip');

subplot(3,1,3)
histogram(y3bits_pclip,quantization_levels+step_size/2);
xlabel ("Amplitude distribution");
ylabel ("Count of sample");
title ("sample after quantization")

quantization_error_clip = y_pclip - y3bits_pclip;
mean_squared_error = mean(quantization_error_clip.^2);
disp(['Mean Squared Error: ', num2str(mean_squared_error)]);

figure(5)
subplot(2,1,1)
plot(t, quantization_error_clip);
xlabel ('Time (s)');
ylabel ('Amplitude');
title('quantization error');

subplot(2,1,2)
histogram(quantization_error_clip,50);
xlabel ("error distribution");
ylabel ("Count of sample");
title("quantization error distribustion")

%soundsc(quantization_error_clip,fs);