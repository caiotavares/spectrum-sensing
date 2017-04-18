function [Y,A,PU,n,Z,SNR_dB] = SS_MCS(scenario, T, w, realiz)

M = size(scenario.PU,1); % Number of PUs
N = size(scenario.SU,1); % Number of SUs
txPower = scenario.TXPower*ones(1,M);
noisePower = scenario.NoisePSD*w*ones(N,1);
a = 4; % Path-loss exponent
samples = round(2*T*w); % Number of samples

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

Y = zeros(realiz,N); % Power estimated
S = zeros(realiz,M); % Channel availability
PU = zeros(N,samples,realiz); % PUs signal received at SU
n = zeros(N,samples,realiz); % Noise received at SU
Z = zeros(N,samples,realiz); % PU signal + noise received at SU
SNR_dB = zeros(N,realiz); % PU SNR at the SU receiver

for k=1:realiz
    n(:,:,k) = gaussianNoise(samples,noisePower); % Get the noise at SU receivers
    H = channel(M,N,d,a); % Power loss
    [X, S(k,:)] = PUtx(M,samples,txPower, scenario.Pr); % Get the PU transmissions
    
    for i=1:N
        for t=1:samples
            for j=1:M
                PU(i,t,k) = PU(i,t,k) + H(j,i)*X(j,t);
            end
            Z(i,t,k) = PU(i,t,k) + n(i,t,k);
        end
        if (sum(S(k,:))>0)
            SNR_dB(i,k) = 10*log10(mean(abs(PU(i,:,k)).^2)/noisePower(i));
        end
        Y(k,i) = sum(abs(Z(i,:,k)).^2)/(noisePower(i)); % Normalized by noise variance
    end
end

SNR_dB = mean(SNR_dB,2);
A = sum(S,2)>0; % Channel availability