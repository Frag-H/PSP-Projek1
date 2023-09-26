clc;
clear all;
%% Speech Enhancement and Object Evaluation Program
environment = ["babble", "exhibition", "restaurant"]; %noise yang digunakan
dB = ["0", "5", "10", "15"]; %Signal To Noise Ratio (SNR) dari noisy speech, semakin besar semakin clean
method = ["wiener", "SS"]; %Metode yang digunakan
rootdir = 'D:\Tugas Kuliah\2021-2022 Genap\PSP\Projek 2\Kode' %Direktori kalian menyimpan folder
[clean_speech, fs]= audioread(strcat(rootdir,'\male\sp21.wav'));
aInfo = audioinfo(strcat(rootdir,'\male\sp21.wav'));
nbits = aInfo.BitsPerSample; % 16 bits resolution
for i = 1:length(environment)
    for j = 1:length(dB)
        infile = strcat(rootdir,'\male\', environment(i), '\in\sp21_', ... 
            environment(i), '_sn', dB(j), '.wav'); %Direktori file input suara noisy
        [noisy_speech{i,j}, fs]= audioread(infile);
        for k = 1:length(method)
            outfile = strcat(rootdir, '\male\', environment(i), '\out\', method(k), ...
                '_sp21_', environment(i), '_sn', dB(j), '.wav'); %Direktori file suara hasil filtering
            if k == 1
                [enhanced_wiener{i,j}, fs, nbits] = wiener_as(infile, outfile); %Metode wiener
            elseif k == 2
                [enhanced_ss{i,j}, Srate] = specsub(infile, outfile); %Metode spectral substraction
            end
            fwSNRseg((i-1)*length(dB)+j,k) = comp_fwseg(strcat(rootdir,'\male\sp21.wav'), outfile); %itung fwSNReq
            LLR((i-1)*length(dB)+j,k) = comp_llr(strcat(rootdir,'\male\sp21.wav'), outfile); %LLR
            PESQ((i-1)*length(dB)+j,k) = pesq(strcat(rootdir,'\male\sp21.wav'), outfile); %PESQ
        end
    end
end
all_result = table(fwSNRseg, LLR, PESQ);
%% Plot Signal in Time and Frequency Domain
% [SNR((i-1)*length(dB)+j,k), segSNR((i-1)*length(dB)+j,k), LLR((i-1)*length(dB)+j,k), ...
%                  PESQ((i-1)*length(dB)+j,k), SIG((i-1)*length(dB)+j,k), BAK((i-1)*length(dB)+j,k), ...
%                  OVL((i-1)*length(dB)+j,k)] = composite('..\male\sp24.wav', outfile);
% all_result2 = table(SNR, segSNR, SIG, BAK, OVL);
for i = 1:length(environment)
    %signal plot in time domain
    figure();
    subplot(4,1,1), plot((1:length(clean_speech))/fs,clean_speech);
    title('Clean Speech');
    xlabel('Time (s)');ylabel('Amplitude');
    subplot(4,1,2), plot((1:length(noisy_speech{i,4}))/fs,noisy_speech{i,4});
    title('Noisy Speech');
    xlabel('Time (s)');ylabel('Amplitude');
    subplot(4,1,3), plot((1:length(enhanced_wiener{i,4}))/fs,enhanced_wiener{i,4});
    title('Wiener Enhanced Speech');
    xlabel('Time (s)');ylabel('Amplitude');
    subplot(4,1,4), plot((1:length(enhanced_ss{i,4}))/fs,enhanced_ss{i,4});
    title('SS Enhanced Speech');
    xlabel('Time (s)');ylabel('Amplitude');
    %signal plot in frequency domain
    figure();
    subplot(4,1,1), specgram(clean_speech,160*2,fs,hamming(160),80);
    title('Clean Speech');
    xlabel('Time (s)');ylabel('Frequency (Hz)');
    subplot(4,1,2), specgram(noisy_speech{i,4},160*2,fs,hamming(160),80);
    title('Noisy Speech');
    xlabel('Time (s)');ylabel('Frequency (Hz)');
    subplot(4,1,3), specgram(enhanced_wiener{i,4},160*2,fs,hamming(160),80);
    title('Wiener Enhanced Speech');
    xlabel('Time (s)');ylabel('Frequency (Hz)');
    subplot(4,1,4), specgram(enhanced_ss{i,4},160*2,fs,hamming(160),80);
    title('SS Enhanced Speech');
    xlabel('Time (s)');ylabel('Frequency (Hz)');
end