%% Setup

clear
close all
addpath('lib');

realiz = 1e4;
T = 1e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sensing bandwidth
N = round(2*w*T); % Number of samples
NoisePSD_dBm = -152;%-147; % Noise PSD in dBm/Hz
NoiseVariance = (10^(NoisePSD_dBm/10)*1e-3)*w;

%% Distribute the SU and PU locations and active probability
               
% Scenario 1
scenario1.PU = [1.0 1.0]*1e3;
scenario1.SU = [0 1.0 ; 2.0 1.0; 1.0 0.5]*1e3;
scenario1.Pr = 0.5;
scenario1.NoisePower = NoiseVariance;
scenario1.TXPower = 0.1; % PU transmission power in W

% Scenario 2
scenario2.PU = [1.0 1.0]*1e3;
scenario2.SU = [0.5 1.0 ; 2.0 1.0; 1.0 0.5; 0.5 0.5]*1e3;
scenario2.Pr = 0.5;
scenario2.NoisePower = NoiseVariance;
scenario2.TXPower = 0.1; % PU transmission power in W
               
%% Spectrum Sensing Procedure

scenario = scenario2;
[X,A,PU,n,Z,SNR] = SS_MCS(scenario, T, w,realiz);

meanSNR = mean(SNR(:,A==1),2);
meanSNRdB = 10*log10(meanSNR); 

%% Call scripts to predict and plot results

predict
% plotResults

exportX = [X A];
save('R/ss.mat','exportX','-v6');
clear exportX;