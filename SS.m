%% Setup

clear
addpath(genpath('lib'));
if (exist('data','dir') ~= 7)
    mkdir('data')
end
addpath('data');

% Scenario 1
scenario1.PU = [0 0]*1e3;
scenario1.SU = [0 0.5 ; 0 0.75 ; 0 1]*1e3;
scenario1.Pr = 0.5;
scenario1.TXPower = 0.1; % PU transmission power in W

% Scenario 2
scenario2.PU = [0 0]*1e3;
scenario2.SU = [0 0.5 ; 0 0.5 ; 0 0.75 ; 0 1]*1e3;
scenario2.Pr = 0.5;
scenario2.TXPower = 0.1; % PU transmission power in W

scenario = scenario2;
scenario.realiz = 5e4; % MCS realization
scenario.T = 5e-6; % SU spectrum sensing period
scenario.w = 5e6; % SU spectrum sensing bandwidth
scenario.NoisePSD_dBm = -153;%-153; % Noise PSD in dBm/Hz
scenario.NoisePower = (10^(scenario.NoisePSD_dBm/10)*1e-3)*scenario.w;
               
%% Spectrum Sensing Procedure

[X,Y,~,~,~,SNR] = MCS(scenario);
meanSNR = mean(SNR(:,Y==1),2);
meanSNRdB = 10*log10(meanSNR); 

%% Build models, predict the channel status and plot results

modelList.analytical = {'Gaussian Mixture Model' 
                        'Weighted Naive Bayes'
                        'Maximum Ratio Combining'};
modelList.ML = {'Naive Bayes'};
[models, test]= buildModels(X, Y, scenario, meanSNR, 0.0001, modelList);
models = predict(test.X, test.Y, size(scenario.SU,1), models);
options.suppressIndividual = false;
plotResults(X,Y,models,options);
