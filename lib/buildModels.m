function [models, test] = buildModels(X, A, N, meanSNR, Pr)
%% Machine Learning

% Setup
training = 0.7;
trainingIndexes = sort(randperm(length(X), round(length(X)*training)))';
testIndexes = setdiff(1:size(X,1),trainingIndexes)';
train.X = X(trainingIndexes,:);
train.Y = A(trainingIndexes,:);
test.X = X(testIndexes,:);
test.Y = A(testIndexes,:);

% Naive Bayes
models.ML.NB = NB(train,test);

% Gaussian Mixture Model
models.ML.GMM = GMM(train, test);

% K-Means Clustering
models.ML.KMeans = KMeans(train, test);

% Support Vector Machine
models.ML.SVM = SVM(train, test);

% Multilayer Perceptron
ML.train = train;
ML.test = test;
save('data/ss.mat','ML','-v6');
system('Rscript --vanilla lib/algorithms/MLP.r');
models.ML.MLP = load('MLP');
models.ML.MLP.positiveClass = 2;
models.ML.MLP.name = 'Multilayer Perceptron';

%% Analytical Models

% Weighted Naive Bayes
e = 1e-3;
shape = N/2;
scale = 2*ones(size(test.X,1),1).*(1+meanSNR)';
P_X0_H1 = gamcdf(N*(test.X+e),shape,scale) - gamcdf(N*(test.X-e),shape,scale);
P_X0_H0 = chi2cdf((test.X+e)*N,N) - chi2cdf((test.X-e)*N,N);
P_H1 = Pr;
P_H0 = 1-P_H1;
P_H1_X0 = P_X0_H1*P_H1./(P_X0_H0*P_H0 + P_X0_H1*P_H1);
P_H0_X1 = 1-P_H1_X0;
w = meanSNR';
models.analytical.WB.P = [sum(P_H0_X1.*w,2)/sum(w) sum(P_H1_X0.*w,2)/sum(w)];
models.analytical.WB.name = 'Weighted Bayesian';

% Gaussian Mixture Model
mu = [ones(1,length(meanSNR));
      ones(1,length(meanSNR)).*(1+meanSNR)'];
sigma = [ones(1,length(meanSNR))*(2*N/N^2);
         ones(1,length(meanSNR)).*(2*N*((1+meanSNR)'.^2)/N^2)];
Sigma(:,:,1) = sigma(1,:);
Sigma(:,:,2) = sigma(2,:);
mixing = [1-Pr Pr];
GM = gmdistribution(mu,Sigma,mixing);
[~,~,models.analytical.GMM.P] = cluster(GM,test.X);
models.analytical.GMM.model = GM;
models.analytical.GMM.name = 'Analytical Gaussian Mixture';
