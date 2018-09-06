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

manifest.analytical.MRC = true;
manifest.analytical.WB = false;
manifest.analytical.GMM = false;
manifest.ML.NB = true;
manifest.ML.SVM = true;
manifest.ML.MLP = true;
manifest.ML.KMeans = true;
manifest.ML.GMM = true;

for i=1:epochs
    modelsHolder(i).models = buildModels(train(i), test, scenario, meanSNR, manifest);
    modelsHolder(i).models = predict(test, size(scenario.SU,1), modelsHolder(i).models);
end

models.Pd.NB = zeros(length(modelsHolder(1).models.ML.NB.Pd),1);
models.Pd.GMM = zeros(length(modelsHolder(1).models.ML.GMM.Pd),1);
models.Pd.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.Pd),1);
models.Pd.SVM = zeros(length(modelsHolder(1).models.ML.SVM.Pd),1);
models.Pd.MLP = zeros(length(modelsHolder(1).models.ML.MLP.Pd),1);

models.Pfa.NB = zeros(length(modelsHolder(1).models.ML.NB.Pfa),1);
models.Pfa.GMM = zeros(length(modelsHolder(1).models.ML.GMM.Pfa),1);
models.Pfa.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.Pfa),1);
models.Pfa.SVM = zeros(length(modelsHolder(1).models.ML.SVM.Pfa),1);
models.Pfa.MLP = zeros(length(modelsHolder(1).models.ML.MLP.Pfa),1);

models.AUC.NB = zeros(length(modelsHolder(1).models.ML.NB.AUC),1);
models.AUC.GMM = zeros(length(modelsHolder(1).models.ML.GMM.AUC),1);
models.AUC.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.AUC),1);
models.AUC.SVM = zeros(length(modelsHolder(1).models.ML.SVM.AUC),1);
models.AUC.MLP = zeros(length(modelsHolder(1).models.ML.MLP.AUC),1);

for i=1:epochs
    models.Pd = sumstructs(structfun( @(m) (m.Pd) , modelsHolder(i).models.ML, 'UniformOutput', false), models.Pd);
    models.Pfa = sumstructs(structfun( @(m) (m.Pfa) , modelsHolder(i).models.ML, 'UniformOutput', false), models.Pfa);
    models.AUC = sumstructs(structfun( @(m) (m.AUC) , modelsHolder(i).models.ML, 'UniformOutput', false), models.AUC);
end

models.Pd = structfun( @(m) (m./epochs), models.Pd,'UniformOutput',false);
models.Pfa = structfun( @(m) (m./epochs), models.Pfa,'UniformOutput',false);
models.AUC = structfun( @(m) (m./epochs), models.AUC,'UniformOutput',false);

resultModels = modelsHolder(1).models;

modelNames = fieldnames(resultModels.ML);
fieldNames = fieldnames(models);

for j=1:length(modelNames)
    m = modelNames(j);
    for k=1:length(fieldNames)
        f = fieldNames(k);
        resultModels.ML.(m{:}).(f{:}) = models.(f{:}).(m{:});
    end
end

options = {'ROC', 'IndividualROC'};
plotResults(test,resultModels,options);
