%% Setup

clear
close all

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts= 1/w; % Spectrum sampling period
samples = int32(T*w); % Number of samples

meanNoisePSD_dBm = -160; % Noise PSD in dBm/Hz
varNoisePSD_dBm = 1; % Noise PSD variance (non-static noise)
meanNoisePSD_W = 10^(meanNoisePSD_dBm/10)*1e-3; % Noise PSD in W/Hz
txPower = 0.1; % PU transmission power in W
lambda = 1; % SS Decision threshold
a = 4; % Path-loss exponent

%% Distribute the SU and PU locations

scenario1 = struct('PU',[1 1;0.5 0.5]*1e3,'SU',[0.5 1;1.5 1]*1e3,...
                   'PR',[0.5 0.5]);
scenario2 = struct('PU',[1 1; 0 1]*1e3,'SU',[0.5 1]*1e3,...
                   'PR',[0.5 0.5]);

scenario = scenario1;
M = size(scenario.PU,1); % Number of PUs
N = size(scenario.SU,1); % Number of SUs
txPower = txPower*ones(1,M);

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

%% Main Procedure

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
            x = 0;
            for j=1:M
                x = x + H(j,i)*X(j,t);
            end
            PU(i,t,k) = sum(x);
            Z(i,t,k) = PU(i,t,k) + n(i,t,k);
        end
        SNR(i,k) = 10*log10(mean(abs(PU(i,:,k)).^2)/noisePower(i,k));
        Y(k,i) = mean(abs(Z(i,:,k)).^2)/(w*meanNoisePSD_W);
    end
end

A = sum(S,2)>0; % Channel availability

%% Gather the results

t = ts:ts:T; % Time axis
index = find(sum(S,2)==N,1); % Get first occurrence of all PUs active

%% Received PU signal + noise in time
figure
plot(t,abs(reshape(PU(1,:,index),1,samples)),'b',...
     t,abs(reshape(n(1,:,index),1,samples)),'r');
grid on
legend('PUs','Noise')

%% PU and SU location
% figure
% plot(C_pu(:,1),C_pu(:,2),'k^','MarkerFaceColor','k','MarkerSize',8), hold on
% plot(C_su(:,1),C_su(:,2),'ro','MarkerFaceColor','r','MarkerSize',8);
% grid on
% legend('PU', 'SU')
% axis([0 2 0 2])

%% Sensed power for 1 SU
% figure
% plot(Y(A==1),Y(A==1),'r+'), hold on
% plot(Y(A==0),Y(A==0),'bo')
% grid on
% hold off

%% SU1 and SU2 sensed powers
if (N == 2)
    figure
    plot(Y(A==1,1),Y(A==1,2),'r+'), hold on
    plot(Y(A==0,1),Y(A==0,2),'bo')
    grid on
    hold off
    xlabel 'SU 1'
    ylabel 'SU 2'
end