%% Setup

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts = 1/w; % Spectrum sampling period
samples = int32(T*w); % Number of samples
noisePSD = -174; % Noise PSD in dBm/Hz
txPower = 0.1/T; % % PU transmission power in W
lambda = 1; % SS Decision threshold
a = 4; % Path-loss exponent

%% Distribute the SU and PU locations

% Scenarios of paper
scenario1 = struct('PU',[1 1;0.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.36 0.48 0.16]);
scenario2 = struct('PU',[1.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.5 0.5]);

scenario = scenario1;
M = length(scenario.PU); % Number of PUs
N = length(scenario.SU); % Number of PUs
noisePower = (w*(10.^(noisePSD/10))*1e-3)*ones(1,N); % Noise power at each SU receiver
txPower = txPower*ones(1,M);

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
    
    %% Multivariate Gaussian Approximation
   
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

%% Gather the data

A = sum(S,2)>0; % Channel availability labels

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
axis([0.8 1.4 0.8 1.4])
xlabel 'Energy level of SU 1'
ylabel 'Energy level of SU 2'
