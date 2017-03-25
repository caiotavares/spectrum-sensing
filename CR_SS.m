%% Setup

clear
close all

M = 2; % Number of PUs
N = 2; % Number of SUs

% Pr = [0.36 0.48 0.16]; % Pr[0 1 2]
Pr = [0.9 0.05 0.05]; % Pr[0 1 2]

T = 100e-6; % SU spectrum sensing period
fs = 5e6; % SU spectrum sampling frequency
ts= 1/fs; % Spectrum sampling period
samples = int32(T*fs); % Number of samples

noisePSD = [-174 -174]; % Noise PSD in dBm/Hz
noisePower = fs*(10.^(noisePSD/10))*1e-3; % Noise power at each SU receiver
txPower = [0.2*T 0.2*T]; % PU transmission power in W
lambda = 1; % SS Decision threshold
a = 4; % Path-loss exponent


%% Distribute the SU and PU locations

% Considering (1,1) as the center of the 2D plane

% C_pu = 2*rand(M,2);
% C_su = 2*rand(N,2);

% Scenario I of paper
C_pu(1,:) = [1 1];
C_pu(2,:) = [0.5 0.5];
C_su(1,:) = [0.5 1];
C_su(2,:) = [1.5 1];

%% Compute the Euclidean distance for each PU-SU pair

d = zeros(M,N);

for j=1:M
    for i=1:N
        d(j,i) = norm(C_pu(j,:)-C_su(i,:));
    end
end

%% Main Procedure

realiz = 1e3;
Y = zeros(realiz,N); % Power estimated
S = zeros(realiz,M); % Channel availability

for k=1:realiz
    H = channel(M,N,d,a); % Get the channel matrix
    n = gaussianNoise(N,samples,noisePower); % Get the noise at SU receivers
    [X, S(k,:)] = PUtx(M,samples,txPower, Pr); % Get the PU transmissions
    
    PU = zeros(M,1); % PU signal received at SU
    Z = zeros(N,samples); % PU signal + noise received at SU;
    
    for i=1:N
        for t=1:samples
            for j=1:M
                PU(j) = H(j,i)*X(j,t);
            end
            Z(i,t) = sum(PU) + n(i,t);
        end
        Y(k,i) = (sum(abs(Z(i,:)).^2))*2/noisePower(i);
    end
end

A = sum(S,2)>0; % Channel availability
Y = [Y A]; % Last column for labels

%% Gather the results

t = ts:ts:T; % Time axis

% PU and SU location
% figure
% plot(C_pu(:,1),C_pu(:,2),'k^','MarkerFaceColor','k','MarkerSize',8), hold on
% plot(C_su(:,1),C_su(:,2),'ro','MarkerFaceColor','r','MarkerSize',8);
% grid on
% legend('PU', 'SU')
% axis([0 2 0 2])

% SU1 and SU2 sensed powers
figure
plot(Y(Y(:,3)==1,1),Y(Y(:,3)==1,2),'r+'), hold on
plot(Y(Y(:,3)==0,1),Y(Y(:,3)==0,2),'bo')
grid on
xlabel 'SU 1'
ylabel 'SU 2'

