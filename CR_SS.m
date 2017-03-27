%% Setup

clear
close all

M = 1; % Number of PUs
N = 2; % Number of SUs

Pr = [0.36 0.48 0.16]; % Pr[0 1 2]

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts = 1/w; % Spectrum sampling period
samples = int32(T*w); % Number of samples

noisePSD = [-174 -174]; % Noise PSD in dBm/Hz
noisePower = w*(10.^(noisePSD/10))*1e-3; % Noise power at each SU receiver
txPower = [0.1 0.1]; % PU transmission power in W
lambda = 1; % SS Decision threshold
a = 4; % Path-loss exponent


%% Distribute the SU and PU locations

% Scenario I of paper
% C_pu(1,:) = [1 1];
% C_pu(2,:) = [0.5 0.5];
% C_su(1,:) = [0.5 1];
% C_su(2,:) = [1.5 1];

% Scenario II of paper
C_pu(1,:) = [1.5 0.5];
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

realiz = 5e2;
S = zeros(realiz,M); % Channel availability

muY = zeros(realiz,N); % Mean
sigmaY = zeros(realiz,N); % Standard Deviation

for k=1:realiz
    H = channel(M,N,d,a); % Get the channel matrix
    G = H.^2; % Power loss
    [~, S(k,:)] = PUtx(M,samples,txPower, Pr); % Get the PU transmissions
    
    %% Gaussian Approximation
   
    for i=1:N
        summation = 0;
        for j=1:M
            summation = summation + S(k,j)*G(j,i)*txPower(j);
        end
        muY(k,i) = 2*w*T + (2*T/noisePower(i))*summation;
        sigmaY(k,i) = sqrt(4*w*T + (8*T/noisePower(i))*summation);
    end
    
end

Y = normrnd(muY,sigmaY);
A = sum(S,2)>0; % Channel availability
Y = [Y A]; % Last column for labels

%% Gather the results

t = ts:ts:T; % Time axis

% PU and SU location
figure
plot(C_pu(:,1),C_pu(:,2),'k^','MarkerFaceColor','k','MarkerSize',8), hold on
plot(C_su(:,1),C_su(:,2),'ro','MarkerFaceColor','r','MarkerSize',8);
grid on
legend('PU', 'SU')
axis([0 2 0 2])

% SU1 and SU2 sensed powers
figure
plot(Y(Y(:,3)==1,1),Y(Y(:,3)==1,2),'r+'), hold on
plot(Y(Y(:,3)==0,1),Y(Y(:,3)==0,2),'bo')
grid on
axis([800 1400 800 1400])
xlabel 'Energy level of SU 1'
ylabel 'Energy level of SU 2'

