%% Setup

clear
addpath('lib');
addpath('data');

% Scenario 1
scenario1.PU = [1.0 1.0]*1e3;
scenario1.SU = [0 1.0 ; 2.0 1.0; 1.0 0.5]*1e3;
scenario1.Pr = 0.5;
scenario1.TXPower = 0.1; % PU transmission power in W

% Scenario 2
scenario2.PU = [1.0 1.0]*1e3;
scenario2.SU = [0.5 1.0 ; 2.0 1.0; 1.0 0.5; 0.5 0.5]*1e3;
scenario2.Pr = 0.5;
scenario2.TXPower = 0.1; % PU transmission power in W

scenario = scenario2;
scenario.realiz = 1e4; % MCS realization
scenario.T = 5e-6; % SU spectrum sensing period
scenario.w = 5e6; % SU spectrum sensing bandwidth
scenario.NoisePSD_dBm = -152;%-147; % Noise PSD in dBm/Hz
scenario.NoisePower = (10^(scenario.NoisePSD_dBm/10)*1e-3)*scenario.w;          
               
%% Spectrum Sensing Procedure

[X,A,~,~,~,SNR] = SS_MCS(scenario);
meanSNR = mean(SNR(:,A==1),2);
meanSNRdB = 10*log10(meanSNR); 

%% Build models, predict the channel status and plot results

% Export SS file to R ML script
save('data/ss.mat','X','A','-v6');

models = buildModels(X, size(scenario.SU,1), meanSNR, scenario.Pr);
[Pd, Pfa] = predict(X, A, size(scenario.SU,1), models);
options.suppressIndividual = true;
plotResults(X,A,Pd,Pfa,options);
clear options