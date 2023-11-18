clear, clc, close all
wc = pi/3;
M_values = [20, 50, 150];

for M = M_values
    N = M + 1;
    n = 0:N-1;
    h_trunc = sinc((n - M/2) * wc/pi);
    h_pm = firpm(M, [0 0.9*wc/pi 1.1*wc/pi 1], [1 1 0 0]);
    
    c = conv(ones(1, length(h_pm)),h_pm);
    % figure;
    % plot(abs(c(N:length(c))))

    % figure;
    % freqz(h_trunc, 1, 1024);
    % title(['truncation methodfor M = ', num2str(M)]);
    figure;
    freqz(h_pm, 1, 1024);
    title(['Parks-McClellan for M = ', num2str(M)]);
end
