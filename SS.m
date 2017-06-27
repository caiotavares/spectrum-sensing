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
scenario2.SU = [0 0.5 ; 0 0.75 ; 0 1; 0 0.5]*1e3;
scenario2.Pr = 0.5;
scenario2.TXPower = 0.1; % PU transmission power in W

scenario = scenario1;
scenario.realiz = 5e4; % MCS realization
scenario.T = 5e-6; % SU spectrum sensing period
scenario.w = 5e6; % SU spectrum sensing bandwidth
scenario.NoisePSD_dBm = -153;%-153; % Noise PSD in dBm/Hz
scenario.NoisePower = (10^(scenario.NoisePSD_dBm/10)*1e-3)*scenario.w;

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

%% Build models, predict the channel status and plot results

modelList.analytical = {'Gaussian Mixture Model' 
                        'Weighted Naive Bayes'
                        'Maximum Ratio Combining'};
modelList.ML = {'Naive Bayes'};

for i=1:epochs
    modelsHolder(i).models = buildModels(train(i), test, scenario, meanSNR, modelList);
    modelsHolder(i).models = predict(test, size(scenario.SU,1), modelsHolder(i).models);
end

models = modelsHolder(1).models;

for i=2:epochs
    models.ML.NB.Pd = models.ML.NB.Pd + modelsHolder(i).models.ML.NB.Pd;
    models.ML.NB.Pfa = models.ML.NB.Pfa + modelsHolder(i).models.ML.NB.Pfa;
    models.ML.NB.AUC = models.ML.NB.AUC + modelsHolder(i).models.ML.NB.AUC;
end

models.ML.NB.Pd = models.ML.NB.Pd./epochs;
models.ML.NB.Pfa = models.ML.NB.Pfa./epochs;
models.ML.NB.AUC = models.ML.NB.AUC./epochs;

options = {'ROC', 'IndividualROC'};
plotResults(test,models,options);

fprintf('NB AUC -> %3.3f\n', models.ML.NB.AUC)
