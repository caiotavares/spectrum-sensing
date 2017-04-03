function [Y,A] = analytical_SS(scenario, txPower, T, w, noisePSD)

M = length(scenario.PU); % Number of PUs
N = length(scenario.SU); % Number of PUs
noisePower = (w*(10.^(noisePSD/10))*1e-3)*ones(1,N); % Noise power at each SU receiver
txPower = txPower*ones(1,M);
a = 4; % Path-loss exponent
samples = int32(T*w); % Number of samples

%% Compute the Euclidean distance for each PU-SU pair
d = zeros(M,N);

for j=1:M
    for i=1:N
        d(j,i) = norm(scenario.PU(j,:)-scenario.SU(i,:));
    end
end

%% Main Procedure

realiz = 5e2;
S = zeros(realiz,M); % Channel availability
muY = zeros(realiz,N); % Mean
sigmaY = zeros(realiz,N); % Standard Deviation
Y = zeros(realiz, N); % Sensed energy

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