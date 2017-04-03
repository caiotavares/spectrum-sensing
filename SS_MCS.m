function [Y,A,PU,n,Z,SNR] = SS_MCS(scenario,txPower, T, w, meanNoisePSD_dBm, varNoisePSD_dBm)

M = size(scenario.PU,1); % Number of PUs
N = size(scenario.SU,1); % Number of SUs
meanNoisePSD_W = 10^(meanNoisePSD_dBm/10)*1e-3; % Noise PSD in W/Hz
txPower = txPower*ones(1,M);
a = 4; % Path-loss exponent
samples = T*w; % Number of samples

%% Compute the Euclidean distance for each PU-SU pair
d = zeros(M,N);

for j=1:M
    for i=1:N
        d(j,i) = norm(scenario.PU(j,:)-scenario.SU(i,:));
        if (d(j,i) == 0)
            d(j,i) = 1;
        end
    end
end

%% Main

realiz = 1e3;
Y = zeros(realiz,N); % Power estimated
S = zeros(realiz,M); % Channel availability
PU = zeros(N,samples,realiz); % PUs signal received at SU
n = zeros(N,samples,realiz); % Noise received at SU
Z = zeros(N,samples,realiz); % PU signal + noise received at SU
SNR = zeros(N,realiz); % PU SNR at the SU receiver
noisePower = zeros(N,realiz);

for k=1:realiz
    noisePower(:,k) = w*(10.^(normrnd(meanNoisePSD_dBm,varNoisePSD_dBm,N,1)/10)*1e-3);
    H = channel(M,N,d,a); % Power loss
    n(:,:,k) = gaussianNoise(N,samples,noisePower(:,k)); % Get the noise at SU receivers
    [X, S(k,:)] = PUtx(M,samples,txPower, scenario.PR); % Get the PU transmissions
    
    for i=1:N
        for t=1:samples
            for j=1:M
                PU(i,t,k) = PU(i,t,k) + H(j,i)*X(j,t);
            end
            Z(i,t,k) = PU(i,t,k) + n(i,t,k);
        end
        SNR(i,k) = 10*log10(mean(abs(PU(i,:,k)).^2)/noisePower(i,k));
        Y(k,i) = sum(abs(Z(i,:,k)).^2)/(w*meanNoisePSD_W*samples);
    end
end

A = sum(S,2)>0; % Channel availability