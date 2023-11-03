%% q1 
clc, clear, close all
% (a) 导入 KillarneyPic.png，并报告其大小和字节
img = imread('KillarneyPic.png');
disp(['(a) Image size: ', num2str(size(img))]);
disp(['(a) Image bytes: ', num2str(numel(img))]);

% (b) 转换图像为 double 类型并显示
img_double = double(img) / 255;
figure; imshow(img_double); title('(b) Original Image in Double');

% (c) 设置颜色映射为灰度，并尝试 (1-gray) 的颜色映射
figure; imshow(img_double); colormap(gray); title('(c) Colormap: Gray');
figure; imshow(img_double); colormap(1 - gray); title('(c) Colormap: 1 - Gray');
colormap(gray);

% (d) 重采样和重构
% (i) 脉冲采样
img_impulse = img_double;
img_impulse(:, 2:5:end) = 0;
img_impulse(:, 3:5:end) = 0;
img_impulse(:, 4:5:end) = 0;
img_impulse(:, 5:5:end) = 0;
figure; imshow(img_impulse); title('(d-i) Impulse Sampling');

% (ii) 下采样
img_downsample = img_double(:, 1:5:end);
figure; imshow(img_downsample); title('(d-ii) Downsampling');

% (iii) 零阶保持重构
img_zero_order = repelem(img_downsample, 1, 5);
figure; imshow(img_zero_order); title('(d-iii) Zero-Order Hold Reconstruction');

% (iv) 一阶保持重构（线性插值）
img_first_order = interp1(1:size(img_downsample, 2), img_downsample', linspace(1, size(img_downsample, 2), size(img_double, 2)), 'linear')';
figure; imshow(img_first_order); title('(d-iv) First-Order Hold Reconstruction');

%% q2
% (a) 创建一个计算 DFT 的 MATLAB 函数
clc, clear, close all

% (b) 使用该函数计算 5 个不同长度的矩形信号的 DFT
N_values = [16, 32, 64, 128, 256];

for N = N_values
    x = [ones(1, 16), zeros(1, N-16)];
    X = myDFT(x);
    figure;
    plot(abs(X));
    title(['(b) DFT Magnitude for N = ', num2str(N)]);
    xlabel('Frequency Index');
    ylabel('Magnitude');
end

% (c) 描述输出的幅度变化
disp('(c) As the zero-padding at the tail end of the rectangular signal increases in length, the main lobe of the DFT becomes narrower and the side lobes become less pronounced.');

% (d) 使用 Lab 2 中的函数计算 DTFT，并找到与 DFT 相同的输出
% 假设 Lab 2 中的函数名为 myDTFT
% function X = myDTFT(x, w)
%     ...
% end
h1 = [1/4 1/2 1/4];
h2 = [-1/4 1/2 -1/4];

for N = N_values
    x = h1;
    w = 2 * pi * (0:N-1) / N;  % 与 DFT 相同的频率点
    X = myDTFT(x, w);
    figure;
    plot(w, abs(X));
    title(['(d) DTFT Magnitude for N = ', num2str(N)]);
    xlabel('Frequency (rad/s)');
    ylabel('Magnitude');
end



%% q3
clc, clear, close all
% 3. FFT based speech recognition

% (a) Load "yes.wav" and "no.wav" files and plot the magnitude of the FFT
[y_yes, fs_yes] = audioread('yes.wav');
[y_no, fs_no] = audioread('no.wav');

X_yes = abs(fft(y_yes));
X_no = abs(fft(y_no));

figure;
plot(X_yes, 'b'); hold on;
plot(X_no, 'r');
legend('Yes', 'No');
title('FFT Magnitude of "Yes" and "No"');
xlabel('Frequency Index');
ylabel('Magnitude');

% (b) Use the code to find a threshold that can distinguish between "yes" and "no"
recording = false;  % true or false
if recording == true  % record audio data from a microphone
    fs = 16000;
    nBits = 16;
    nChannels = 1;
    ID = -1;  % default audio input device
    recObj = audiorecorder(fs, nBits, nChannels, ID);
    disp('Start speaking. Recording ends in 3 seconds.')
    recordblocking(recObj, 3);
    disp('End of Recording.');
    play(recObj);
    y = getaudiodata(recObj);
else
    filename = 'yes.wav';  % change filename to test provided 'yes' and 'no'
    [y, fs] = audioread(filename);
    soundsc(y, fs);
end

N = length(y);
k1 = round(N/4);  % FFT component corresponding to fs/4 Hz
k2 = round(N/2);  % FFT component corresponding to fs/2 Hz
X = abs(fft(y));
f = sum(X(1:k1)) / sum(X(k1+1:k2));

threshold = 6;  % Set a value to distinguish words 'yes' and 'no'
if f < threshold
    disp('yes');
else
    disp('no');
end

% (c) Demonstrate speech recognition on the TMS 320 DSP processor
% The code for this part would be specific to the TMS 320 DSP processor and is not provided here.
% line 11 mag 1200000
% mic 6 mag 2000000
function X = myDFT(x)
    N = length(x);
    k = 0:N-1;
    n = k';
    W = exp(-1i * 2 * pi * n * k / N);
    X = W * x(:);
end