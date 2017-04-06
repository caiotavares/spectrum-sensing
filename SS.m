%% Setup

clear
close all
addpath('lib');

realiz = 1e3;
T = 100e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sensing bandwidth
meanNoisePSD_dBm = -167; % Noise PSD in dBm/Hz
varNoisePSD_dBm = 1; % Noise PSD variance (non-static noise)
txPower = 0.1; % PU transmission power in W

%% Distribute the SU and PU locations and active probability

% Scenarios of paper
scenario1 = struct('PU',[1.0 1.0 ; 0.5 0.5]*1e3,'SU',[0.5 1.0 ; 1.5 1.0]*1e3,...
                   'PR',[0.5 0.5]);
scenario2 = struct('PU',[1.5 0.5]*1e3,'SU',[0.5 1.0 ; 1.5 1.0]*1e3,...
                   'PR',[0.5 0.5]);
               
myScenario = struct();
myScenario.PU = [1.0 1.0]*1e3;
myScenario.SU = [0.0 1.0 ; 2.0 1.0]*1e3;
myScenario.PR = 0.5;
               
%% Spectrum Sensing Procedure

[X_mcs,A_mcs,PU,n,Z,SNR_dB] = SS_MCS(myScenario,txPower, T, w, meanNoisePSD_dBm, varNoisePSD_dBm,realiz);
% [X_art,A_art,muY,sigmaY] = SS_analytical(myScenario, txPower/T, T, w, meanNoisePSD_dBm, realiz);

X = X_mcs;
A = A_mcs;

%% GMM 

% % start = struct('mu',[1 1],'Sigma',diag(sigmaY),'ComponentProportion',[0.25 0.75]);
% start = A+1;
% [Y,GM] = GMM(X,2,start);
% 
% % Get the performance metrics
% temp = (A+1)==Y;
% correct = length(temp(temp==1));
% incorrect = length(A)-correct;
% acc = correct/length(A);

%% Plot results

% Define the axis limits
m1 = mean(X(:,1));
d1 = std(X(:,1));
m2 = mean(X(:,2));
d2 = std(X(:,2));
axisLimits = round([m1-(3*d1) m1+(3*d1) m2-(3*d2) m2+(3*d2)],2);

% GMM Predicted Channel Status
% figure;
% gscatter(X(:,1),X(:,2),Y,'br','o+');
% axis(axisLimits)
% grid on
% hold on
% fcontour(@(x,y)pdf(GM,[x y]),axisLimits);
% title('Predicted Scatter Plot and GMM Contour')
% legend('Channel available','Channel unavailable','Location','NorthWest');
% xlabel 'Energy level of SU 1'
% ylabel 'Energy level of SU 2'
% hold off

% Received PU signal + noise in time
% t = ts:ts:T; % Time axis
% index = find(sum(S,2)==N,1); % Get first occurrence of all PUs active
% figure
% plot(t,abs(reshape(PU(1,:,index),1,samples)),'b',...
%      t,abs(reshape(n(1,:,index),1,samples)),'r');
% grid on
% legend('PUs','Noise')

% PU and SU location
% figure
% plot(C_pu(:,1),C_pu(:,2),'k^','MarkerFaceColor','k','MarkerSize',8), hold on
% plot(C_su(:,1),C_su(:,2),'ro','MarkerFaceColor','r','MarkerSize',8);
% grid on
% legend('PU', 'SU')
% axis([0 2 0 2])

% Sensed power for 1 SU
% figure
% plot(X(A==1),X(A==1),'r+'), hold on
% plot(X(A==0),X(A==0),'bo')
% grid on
% hold off

% SU1 and SU2 sensed powers
figure
plot(X(A==1,1),X(A==1,2),'r+'), hold on
plot(X(A==0,1),X(A==0,2),'bo')
axis(axisLimits)
grid on
title('Channel States')
legend('Channel available','Channel unavailable','Location','NorthWest');
xlabel 'Normalized energy level of SU 1'
ylabel 'Normalized energy level of SU 2'
hold off
