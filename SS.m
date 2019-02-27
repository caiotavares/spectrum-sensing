%% Setup

clear
addpath(genpath('lib'));
if (exist('data','dir') ~= 7)
    mkdir('data')
end
addpath('data');

% Scenario 1
scenario.PU = [0 0]*1e3;
scenario.SU = [0 0.5 ; 0 0.75 ; 0 1]*1e3;
scenario.Pr = 0.5;
scenario.TXPower = 0.1; % PU transmission power in W
scenario.realiz = 5e4; % MCS realization
scenario.T = 5e-6; % SU spectrum sensing period
scenario.w = 5e6; % SU spectrum sensing bandwidth
scenario.NoisePSD_dBm = -153;%-153; % Noise PSD in dBm/Hz
scenario.NoisePower = (10^(scenario.NoisePSD_dBm/10)*1e-3)*scenario.w;
scenario.fading = false;

trainingScenario = scenario;
trainingScenario.realiz = 500;

train = struct();
modelsHolder = struct();
epochs = 20;

%% Spectrum Sensing Procedure

[test.X,test.Y,~,~,~,SNR] = MCS(scenario);
for i=1:epochs
    [train(i).X, train(i).Y,~,~,~,~] = MCS(trainingScenario);
end
meanSNR = mean(SNR(:,test.Y==1),2);
meanSNRdB = 10*log10(meanSNR); 

%% Build models and predict the channel status

manifest.analytical.MRC = true;
manifest.analytical.WB = false;
manifest.analytical.GMM = false;
manifest.ML.NB = true;
manifest.ML.LSVM = true;
manifest.ML.GSVM = true;
manifest.ML.MLP = true;
manifest.ML.KMeans = false;
manifest.ML.GMM = false;

for i=1:epochs
    profile on;
    modelsHolder(i).models = buildModels(train(i), test, scenario, meanSNR, SNR, manifest);
    profile off;
    info(i) = profile('info');
    modelsHolder(i).models = predict(test, size(scenario.SU,1), modelsHolder(i).models);
end

%% Average machine learning models for the trained epochs
models = normalize(modelsHolder,epochs, manifest);
time = profs(info, manifest);

%% Plot the results
options = {'ROC', 'IndividualROC'};
plotResults(test,models,options);
