function models = buildModels(train, test, scenario, meanSNR, SNR, manifest)
%% Machine Learning

% Setup
N = size(scenario.SU,1);
Pr = scenario.Pr;

% Naive Bayes
if (manifest.ML.NB) 
    models.ML.NB = NB(train,test);
end

% Gaussian Mixture Model
if (manifest.ML.GMM) 
    models.ML.GMM = GMM(train, test);
end

% K-Means Clustering
if (manifest.ML.KMeans) 
    models.ML.KMeans = KMeans(train, test);
end

% Linear Support Vector Machine
if (manifest.ML.LSVM)
    models.ML.LSVM = SVM(train, test, 'linear');
    models.ML.LSVM.name = 'Linear SVM';
end

% Gaussian Support Vector Machine
if (manifest.ML.GSVM)
    models.ML.GSVM = SVM(train, test, 'gaussian');
    models.ML.GSVM.name = 'Gaussian SVM';
end

% Multilayer Perceptron
if (manifest.ML.MLP)
    ML.train = train;
    ML.test = test;
    save('data/ss.mat','ML','-v6');
    clear ML;
    system('Rscript --vanilla lib/algorithms/MLP.r');
    models.ML.MLP.model = load('MLP');
    models.ML.MLP.positiveClass = 2;
    models.ML.MLP.name = 'MLP';
    models.ML.MLP.model.activationFunc = @(x) 1./(1+exp(-x)); % Logistic
    models.ML.MLP.P = MLP(test.X, models.ML.MLP.model, N);
end

%% Analytical Models

% Weighted Naive Bayes
if (manifest.analytical.WB)
    shape = N/2;
    scale = 2*ones(size(test.X,1),1).*(1+meanSNR)';
    P_X0_H1 = gampdf(N*test.X,shape,scale);
    P_X0_H0 = chi2pdf(N*test.X,N);
    P_H1 = Pr;
    P_H0 = 1-P_H1;
    P_H1_X0 = P_X0_H1*P_H1./(P_X0_H0*P_H0 + P_X0_H1*P_H1);
    P_H0_X0 = 1-P_H1_X0;
    w = meanSNR';
    models.analytical.WB.P = [sum(P_H0_X0.*w,2)/sum(w) sum(P_H1_X0.*w,2)/sum(w)];
    models.analytical.WB.name = 'Weighted Naive Bayes';
end

% Gaussian Mixture Model
if (manifest.analytical.GMM)
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
    models.analytical.GMM.name = 'Gaussian Mixture Model';
end

% MRC
if (manifest.analytical.MRC)
    w = meanSNR;
    models.analytical.MRC.E = test.X*w./sum(w); % Energy level
    models.analytical.MRC.P = models.analytical.MRC.E./max(models.analytical.MRC.E);
    models.analytical.MRC.P = [models.analytical.MRC.P 1-models.analytical.MRC.P];
    models.analytical.MRC.name = 'MRC';
end
