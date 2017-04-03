%% Setup

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts= 1/w; % Spectrum sampling period
meanNoisePSD_dBm = -160; % Noise PSD in dBm/Hz
varNoisePSD_dBm = 1; % Noise PSD variance (non-static noise)
txPower = 0.1; % PU transmission power in W

%% Distribute the SU and PU locations

% Scenarios of paper
scenario1 = struct('PU',[1 1;0.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.36 0.48 0.16]);
scenario2 = struct('PU',[1.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.5 0.5]);
%% Main Procedure

[Y,A,PU,n,Z,SNR] = MCS(scenario1,txPower, T, w, meanNoisePSD_dBm, varNoisePSD_dBm);
[Y,A] = analytical_SS(scenario1, txPower, T, w, noisePSD);
               
% t = ts:ts:T; % Time axis
% index = find(sum(S,2)==N,1); % Get first occurrence of all PUs active

%% Received PU signal + noise in time
% figure
% plot(t,abs(reshape(PU(1,:,index),1,samples)),'b',...
%      t,abs(reshape(n(1,:,index),1,samples)),'r');
% grid on
% legend('PUs','Noise')

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
figure
plot(Y(A==1,1),Y(A==1,2),'r+'), hold on
plot(Y(A==0,1),Y(A==0,2),'bo')
grid on
hold off
xlabel 'Energy level of SU 1'
ylabel 'Energy level of SU 2'