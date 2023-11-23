%**************************************************************************
%** Computer Simulation On Matched Filters for BPSK and BFSK Detection **
%** Diego Benavides 0241824 **
%** March 29, 2007 **
%**************************************************************************
%**************************************************************************
%** Initialize workspace **************************************************
close all;
clear;
clc;
%**************************************************************************
%**************************************************************************
%** Constants and Variable Setup ******************************************
toPlot=1; % set to 1 to show some sample graphs
n0=4; % used for w1, bfsk
n1=1; % used for w2, bfsk
N=20; % defined in project outline
Ts=1; % sampling period of binary sequence
Tb=N*Ts; % period of binary sequence
eta=2; % noise spectral content
SNRe=-4:4; % SNR: -4dB to 4dB
t=0:N-1; % timing for simulation
bitLength=500; % chosen abritrarily
vi=1; % virtual index
% number of bit errors
err_fsk=0;
err_psk=0;
% decoded output sequences
bko_fsk=zeros(1,bitLength);
bko_psk=zeros(1,bitLength);
%**************************************************************************
%** Set up shift keying frequencies ***************************************
w1=2*pi*(n0+n1)/Tb; % first bfsk frequency
w2=2*pi*(n0-n1)/Tb; % second bfsk frequency
wc=n0*2*pi/Tb; % carrier frequency, bpsk
%**************************************************************************
bk=round(rand(1,bitLength)); %1. generate random binary sequence
A=sqrt(2*eta/Tb*10.^(SNRe/10)); %3. compute A for varying SNR levels
for SNR_loop=1:length(SNRe)
    for TRIAL_loop=1:N % 20 independent trials
    err_fsk=0;
    err_psk=0;
    noise=randn(1,bitLength*N); %2. generate zero-mean white Gaussian noise
    vi=1;
    %**********************************************************************
    %** Use A to setup signal functions ***********************************
    s1_fsk=A(SNR_loop)*cos(w1*t); % bfsk 1
    s2_fsk=A(SNR_loop)*cos(w2*t); % bfsk 0
    s1_psk=A(SNR_loop)*cos(wc*t); % bpsk 1
    s2_psk=-A(SNR_loop)*cos(wc*t); % bpsk 0
    d=length(s1_fsk); % signal duration
    %**********************************************************************
    for i=1:bitLength %4. generate FSK and PSK mod signals
        if(bk(i)==1) % virtual index
            s_fsk(vi:vi+(N-1))=s1_fsk(1:N);
            s_psk(vi:vi+(N-1))=s1_psk(1:N);
        else
            s_fsk(vi:vi+(N-1))=s2_fsk(1:N);
            s_psk(vi:vi+(N-1))=s2_psk(1:N);
        end

        vi=vi+N;
    end

    v_fsk=s_fsk+noise; %5. generate noisy signals
    v_psk=s_psk+noise;

    if(toPlot==1) % display preliminary output if desired
        figure(1)
        plot(s_fsk);
        axis([0,100,-1/2,1/2]);
        title('Random Binary FSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        figure(2)
        plot(s_psk);
        axis([0,100,-1/2,1/2]);
        title('Random Binary PSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        figure(3)
        plot(v_fsk);
        axis([0,100,-3,3]);
        title('Random Binary FSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
        figure(4)
        plot(v_psk);
        axis([0,100,-3,3]);
        title('Random Binary PSK Signal');
        ylabel('Amplitude');
        xlabel('Time');
        set(gcf,'Color',[1 1 1])
        grid on
    end
    toPlot=0;
    %6. create matched filters and corresponding signal through each
    mf_fsk=fliplr(s1_fsk-s2_fsk); % BFSK output
    mf_psk=fliplr(s1_psk-s2_psk); % BPSK output
    vo_fsk=conv(v_fsk,mf_fsk);
    vo_psk=conv(v_psk,mf_psk);
    % adjustment for detection
    vo_fsk=vo_fsk(1:bitLength*N);
    vo_psk=vo_psk(1:bitLength*N);
    % sample the output signal
    for m=N:N:(bitLength*N)
        vo_fsk(m/N)=vo_fsk(m);
        vo_psk(m/N)=vo_psk(m);
    end
    %7. threshold detection
    for m=1:bitLength*N;
        if(vo_fsk(m)<=0) % PSK detection
            bko_fsk(m)=0;
        else
            bko_fsk(m)=1;
        end
        if(vo_psk(m)<=0) % PSK detection
            bko_psk(m)=0;
        else
            bko_psk(m)=1;
        end
    end
    %8. find bit error rates
    for m=1:bitLength;
        if(bk(m)~=bko_fsk(m))
            err_fsk=err_fsk+1;
        end
        if(bk(m)~=bko_psk(m))
            err_psk=err_psk+1;
        end
    end
    
    ber_fsk(TRIAL_loop)=err_fsk/bitLength;
    ber_psk(TRIAL_loop)=err_psk/bitLength;
    
    end
    
    fprintf(' Bit Error Rates, SNR=%ddB\n',SNRe(SNR_loop));
    fprintf(' FSK: \t%.4f\n',mean(ber_fsk));
    fprintf(' PSK: \t%.4f\n',mean(ber_fsk));
    performance_fsk(SNR_loop)=mean(ber_fsk);
    performance_psk(SNR_loop)=mean(ber_psk);
end


%**********************************************************************
%** Overal results ****************************************************
figure(5)
semilogy(SNRe,performance_fsk,'-ok');
hold on
semilogy(SNRe,performance_psk,'-or');
title('Performance of FSK vs PSK');
ylabel('Bit Error Rate');
xlabel('SNR');
legend('FSK','PSK');
set(gcf,'Color',[1 1 1])
grid on
figure(6)
plot(SNRe,performance_fsk-performance_psk)
title('Error Rate Reduction, PSK vs FSK');
ylabel('Reduction')
xlabel('SNR')
axis([-4,4,0,0.1]);
set(gcf,'Color',[1 1 1])
grid on
figure(7)
semilogy(SNRe,1/2*erfc(1/2*sqrt(Tb/eta*A.^2)),'r');
hold on
semilogy(SNRe,performance_psk);
title('Theoretical and Experimental PSK Perormance');
ylabel('Performance')
xlabel('SNR')
legend('Theoretical','Experimental');
set(gcf,'Color',[1 1 1])
grid on
figure(8)
semilogy(SNRe,1/2*erfc(1/2*sqrt(Tb/eta/2*A.^2)),'r');
hold on
semilogy(SNRe,performance_fsk);
title('Theoretical and Experimental FSK Perormance');
ylabel('Performance')
xlabel('SNR')
legend('Theoretical','Experimental');
set(gcf,'Color',[1 1 1])
grid on
%**********************************************************************