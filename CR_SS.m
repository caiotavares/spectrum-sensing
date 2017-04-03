%% Setup

T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sampling frequency
ts = 1/w; % Spectrum sampling period
noisePSD = -174; % Noise PSD in dBm/Hz
txPower = 0.1/T; % % PU transmission power in W

%% Distribute the SU and PU locations

% Scenarios of paper
scenario1 = struct('PU',[1 1;0.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.36 0.48 0.16]);
scenario2 = struct('PU',[1.5 0.5]*1e3, 'SU', [0.5 1; 1.5 1]*1e3,...
                   'PR',[0.5 0.5]);
%% Main Procedure

[Y,A] = analytical_SS(scenario1, txPower, T, w, noisePSD);
               
%% Gather the data

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
