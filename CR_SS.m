%% Setup

clear
close all

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts= 1/w; % Spectrum sampling period
samples = int32(T*w); % Number of samples

noisePSD = -174; % Noise PSD in dBm/Hz
txPower = [0.2 0.2]; % PU transmission power in W
lambda = 1; % SS Decision threshold
a = 4; % Path-loss exponent

%% Distribute the SU and PU locations

scenario1 = struct('PU',[1000 1000;500 500],'SU',[500 1000;1500 1000],...
                   'PR',[0.5 0.5 0]);

scenario = scenario1;
M = size(scenario.PU,1); % Number of PUs
N = size(scenario.SU,1); % Number of SUs
noisePower = (w*(10.^(noisePSD/10))*1e-3)*ones(1,N);

%% Compute the Euclidean distance for each PU-SU pair

d = zeros(M,N);

for j=1:M
    for i=1:N
        d(j,i) = norm(scenario.PU(j,:)-scenario.SU(i,:));
    end
end

%% Main Procedure

realiz = 1e3;
Y = zeros(realiz,N); % Power estimated
S = zeros(realiz,M); % Channel availability

for k=1:realiz
    H = channel(M,N,d,a); % Power loss
    n = gaussianNoise(N,samples,noisePower); % Get the noise at SU receivers
    [X, S(k,:)] = PUtx(M,samples,txPower, scenario.PR); % Get the PU transmissions
    
    PU = zeros(M,1); % PU signal received at SU
    Z = zeros(N,samples); % PU signal + noise received at SU;
    
    for i=1:N
        for t=1:samples
            for j=1:M
                PU(j) = H(j,i)*X(j,t);
            end
            Z(i,t) = sum(PU) + n(i,t);
        end
        Y(k,i) = mean(abs(Z(i,:)).^2)/noisePower(i);
    end
end

A = sum(S,2)>0; % Channel availability

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
plot(Y(A==1,1),Y(A==1,2),'r+'), hold on
plot(Y(A==0,1),Y(A==0,2),'bo')
grid on
xlabel 'SU 1'
ylabel 'SU 2'

