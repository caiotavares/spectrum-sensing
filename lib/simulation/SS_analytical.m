function [Y,A,muY,sigmaY] = SS_analytical(scenario, txPower, T, w, noisePSD_dBm,realiz)

M = size(scenario.PU,1); % Number of PUs
N = size(scenario.SU,1); % Number of PUs
noisePSD_W = (10.^(noisePSD_dBm/10))*1e-3;
noisePower = w*noisePSD_W*ones(1,N); % Noise power at each SU receiver
txPower = txPower*ones(1,M);
a = 4; % Path-loss exponent
samples = 2*T*w; % Number of samples

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

Y = zeros(realiz, N); % Sensed energy
S = zeros(realiz,M); % Channel availability
muY = zeros(realiz,N); % Mean
sigmaY = zeros(realiz,N); % Standard Deviation

for k=1:realiz
    H = channel(M,N,d,a); % Get the channel matrix
    G = H.^2; % Power loss
    [~, S(k,:)] = PUtx(M,samples,txPower, scenario.PR); % Get the PU states
    
    % Multivariate Gaussian Approximation
    for i=1:N
        summation = 0;
        for j=1:M
            summation = summation + S(k,j)*G(j,i)*txPower(j);
        end
        muY(k,i) = 2*w*T + ((2*T)/noisePower(i))*summation;
        sigmaY(k,i) = 4*w*T + ((8*T)/noisePower(i))*summation;
    end
    SIGMAy = diag(sigmaY(k,:));
    Y(k,:) = mvnrnd(muY(k,:),SIGMAy)/1e3;
end

A = sum(S,2)>0; % Channel availability labels