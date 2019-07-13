load('var_training/50.mat', 'models', 'test','time');
models50=models;
test50=test;
time50=time;
clear models test time

load('var_training/100.mat', 'models', 'test','time');
models100=models;
test100=test;
time100=time;
clear models test time

load('var_training/250.mat', 'models', 'test','time');
models250=models;
test250=test;
time250=time;
clear models test time

load('var_training/500.mat', 'models', 'test','time');
models500=models;
test500=test;
time500=time;
clear models test time

load('var_training/1000.mat', 'models', 'test','time');
models1000=models;
test1000=test;
time1000=time;
clear models test time

options = {'ROC', 'IndividualROC'};

aucNB=[models50.ML.NB.AUC, models100.ML.NB.AUC, models250.ML.NB.AUC, models500.ML.NB.AUC, models1000.ML.NB.AUC]
aucMLP=[models50.ML.MLP.AUC, models100.ML.MLP.AUC, models250.ML.MLP.AUC, models500.ML.MLP.AUC, models1000.ML.MLP.AUC]
aucLSVM=[models50.ML.LSVM.AUC, models100.ML.LSVM.AUC, models250.ML.LSVM.AUC, models500.ML.LSVM.AUC, models1000.ML.LSVM.AUC]
aucGSVM=[models50.ML.GSVM.AUC, models100.ML.GSVM.AUC, models250.ML.GSVM.AUC, models500.ML.GSVM.AUC, models1000.ML.GSVM.AUC]
training=[50, 100, 250, 500, 1000]

figure;
plot(training, aucNB, 'red',training, aucMLP, 'green', training, aucLSVM, 'blue', training, aucGSVM, 'cyan')
grid on
xlabel 'Training Samples'
ylabel 'Area Under the Curve (AuC)'
legend 'NB' 'MLP' 'Linear SVM' 'Gaussian SVM'

timeNB=[time50.NB.time, time100.NB.time, time250.NB.time, time500.NB.time, time1000.NB.time];
timeMLP=[0.02, 0.03, 0.04, 0.1, 0.2];
timeLSVM=[time50.LSVM.time, time100.LSVM.time, time250.LSVM.time, time500.LSVM.time, time1000.LSVM.time];
timeGSVM=[time50.GSVM.time, time100.GSVM.time, time250.GSVM.time, time500.GSVM.time, time1000.GSVM.time];

figure;
plot(training, timeNB, 'red', training, timeMLP, 'green', training, timeLSVM, 'blue', training, timeGSVM, 'cyan')
grid on
xlabel 'Training Samples'
ylabel 'Training Time [s]'
legend 'NB' 'MLP' 'Linear SVM' 'Gaussian SVM'