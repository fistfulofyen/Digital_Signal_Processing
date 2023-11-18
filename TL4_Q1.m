clear, clc, close all
wc = pi/3;  % Cutoff frequency
M_values = [20, 50, 150];  % Filter orders

for M = M_values%filter order
    N = M + 1;%length of filter, total number of coefficents
    n = 0:N-1;%discrete-time indicies 
    % a
    h = sinc((n - M/2) * wc/pi); %sinc = sin(x)/x
    
    % h is the impulse response, Directly using sinc function
    figure;
    stem(n, h);
    title(['Linear-phase lowpass impulse response for M= ', num2str(M)]);
    xlabel('n');
    ylabel('h[n]');
    % b
    figure;
    freqz(h, 1, 1024);%the line shows the frequency response 1 means that's FIR filter, 1024 means resolution of frequency responce slot
    title(['frequency response for M = ', num2str(M)]);
    % c
    [H, w] = freqz(h, 1, 1024);%get the frequency response
    phase_response = unwrap(angle(H));%angle calculate the phase angle and unwrap smooth the plot
    figure;
    plot(w, phase_response);
    title(['phase response for M = ', num2str(M)]);
    xlabel('frequency');
    ylabel('phase');
    % d
    h_firls = firls(M, [0 wc/pi wc/pi 1], [1 1 0 0]);
    figure;
    stem(n, h_firls);
    title(['impulse response using firls() for M = ', num2str(M)]);
    xlabel('n');
    ylabel('h[n]');
end

% e
noise = randn(1000, 1);
M_values = [20, 50, 150];

for M = M_values%filter order
    N = M + 1;%length of filter, total number of coefficents
    n = 0:N-1;%discrete-time indicies 
    h = sinc((n - M/2) * wc/pi);%impulse function
    conv_signal = conv(noise, h);
    filter_signal = filter(h, 1, noise);
    figure;
    subplot(2,1,1);
    plot(conv_signal);
    title(['convolved signal for M = ', num2str(M)]);
    xlabel('sample');
    ylabel('amplitude');

    subplot(2,1,2);
    plot(filter_signal);
    title(['filtered Signal using filter() for M = ', num2str(M)]);
    xlabel('sample');
    ylabel('amplitude');
end
