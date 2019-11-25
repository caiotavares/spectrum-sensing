function [Y,A,PU,n,Z,SNR] = MCS(scenario)

M = size(scenario.PU,1);                    % Number of PUs
N = size(scenario.SU,1);                    % Number of SUs
txPower = scenario.TXPower*ones(M,1);       % Transmission power
noisePower = scenario.NoisePower*ones(N,1); % Gaussian noise power
a = 4;                                      % Path-loss exponent
samples = round(2*scenario.T*scenario.w);   % Number of samples
realiz = scenario.realiz;                   % Number of Monte-Carlo realizations

if (scenario.fading)
    fading = 'ray';
else
    fading = '';
end

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

Y = zeros(realiz,N);                        % Power estimated
S = zeros(realiz,M);                        % Channel availability
PU = zeros(N,samples,realiz);               % PUs signal received at SU
n = zeros(N,samples,realiz);                % Noise received at SU
Z = zeros(N,samples,realiz);                % PU signal + noise received at SU
SNR = zeros(N,realiz);                      % PU SNR at the SU receiver

for k=1:realiz
    n(:,:,k) = gaussianNoise(samples,noisePower);       % Get the noise at SU receivers
    H = channel(M,N,d,a,fading);                        % Get the channel matrix
    [X, S(k,:)] = PUtx(M,samples,txPower, scenario.Pr); % Get the PU transmissions
    
    for i=1:N
        for t=1:samples
            for j=1:M
                PU(i,t,k) = PU(i,t,k) + H(j,i)*X(j,t);
            end
            Z(i,t,k) = PU(i,t,k) + n(i,t,k);
        end
        SNR(i,k) = mean(abs(PU(i,:,k)).^2)/noisePower(i);
        Y(k,i) = sum(abs(Z(i,:,k)).^2)/(noisePower(i)*samples); % Normalized by noise variance
    end
end

A = sum(S,2)>0; % Channel availability




