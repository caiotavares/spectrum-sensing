function models = predict(X, Y, N, models)
%% Setup

Pfa_target = 5e-3:5e-3:1;

models.basic.Ind.Pd = zeros(length(Pfa_target),N);
models.basic.Ind.Pfa = zeros(length(Pfa_target),N);
models.basic.OR.Pd = zeros(length(Pfa_target),1);
models.basic.OR.Pfa = zeros(length(Pfa_target),1);
models.basic.AND.Pd = zeros(length(Pfa_target),1);
models.basic.AND.Pfa = zeros(length(Pfa_target),1);

modelList = struct();
if (isfield(models,'analytical'))
    modelList.analytical = struct2cell(structfun(@(x) (x.name), models.analytical, 'UniformOutput', false));
    models.analytical = structfun(@(x) (initialize(x, length(Pfa_target))), models.analytical,'UniformOutput', false);
else
    modelList.analytical = {};
end

if (isfield(models,'ML'))
    modelList.ML = struct2cell(structfun(@(x) (x.name), models.ML, 'UniformOutput', false));
    models.ML = structfun(@(x) (initialize(x, length(Pfa_target))), models.ML,'UniformOutput', false);
else
    modelList.ML = {};
end

    function model = initialize(model, length)
        model.Pd = zeros(length,1);
        model.Pfa = zeros(length,1);
    end

for i=1:length(Pfa_target)
    alpha = 1-Pfa_target(i); % Probability models
    lambda = 2*gammaincinv(Pfa_target(i),N/2,'upper')/N; % Energy models
    % For comparison and/or validation
    %Pd.priori.ind(i,:) = gammainc(N*lambda./(2*(1+meanSNR)), N/2, 'upper');
    
    %% Basic Detectors
    
    % SS Ind
    status_ind = X>=lambda;
    detected_ind = Y & status_ind;
    falseAlarm_ind = logical(status_ind - detected_ind);
    models.basic.Ind.Pd(i,:) = sum(detected_ind)/sum(Y);
    models.basic.Ind.Pfa(i,:) = sum(falseAlarm_ind)/(length(Y)-sum(Y));
    
    % SS Coop OR
    status_or = sum(X >= lambda,2) > 0;
    detected_or = Y & status_or;
    falseAlarm_or = logical(status_or - detected_or);
    models.basic.OR.Pd(i) = sum(detected_or)/sum(Y);
    models.basic.OR.Pfa(i) = sum(falseAlarm_or)/(length(Y)-sum(Y));
    
    % SS Coop AND
    status_and = sum(X >= lambda,2) == size(X,2);
    detected_and = Y & status_and;
    falseAlarm_and = logical(status_and - detected_and);
    models.basic.AND.Pd(i) = sum(detected_and)/sum(Y);
    models.basic.AND.Pfa(i) = sum(falseAlarm_and)/(length(Y)-sum(Y));
    
    
    %% Analytical Models
    
    % SS Coop Bayesian
    if (ismember('Weighted Naive Bayes', modelList.analytical))
        status_bayes = models.analytical.WB.P(:,2)>=alpha;
        detected_bayes = Y & status_bayes;
        falseAlarm_bayes = logical(status_bayes - detected_bayes);
        models.analytical.WB.Pd(i) = sum(detected_bayes)/sum(Y);
        models.analytical.WB.Pfa(i) = sum(falseAlarm_bayes)/(length(Y)-sum(Y));
    end
    
    % SS Coop GMM
    if (ismember('Gaussian Mixture Model', modelList.analytical))
        status_gmm = models.analytical.GMM.P(:,2)>=alpha;
        detected_gmm = Y & status_gmm;
        falseAlarm_gmm = logical(status_gmm - detected_gmm);
        models.analytical.GMM.Pd(i) = sum(detected_gmm)/sum(Y);
        models.analytical.GMM.Pfa(i) = sum(falseAlarm_gmm)/(length(Y)-sum(Y));
    end
    
    % SS Coop MRC
    if (ismember('Maximum Ratio Combining', modelList.analytical))
        status_mrc = models.analytical.MRC.E>=lambda;
        detected_mrc = Y & status_mrc;
        falseAlarm_mrc = logical(status_mrc - detected_mrc);
        models.analytical.MRC.Pd(i) = sum(detected_mrc)/sum(Y);
        models.analytical.MRC.Pfa(i) = sum(falseAlarm_mrc)/(length(Y)-sum(Y));
    end
    
    %% Machine Learning Models
    
    % SS Coop GMM
    if (ismember('Gaussian Mixture Model', modelList.ML))
        status_lgmm = models.ML.GMM.P(:,models.ML.GMM.positiveClass)>=alpha;
        detected_lgmm = Y & status_lgmm;
        falseAlarm_lgmm = logical(status_lgmm - detected_lgmm);
        models.ML.GMM.Pd(i) = sum(detected_lgmm)/sum(Y);
        models.ML.GMM.Pfa(i) = sum(falseAlarm_lgmm)/(length(Y)-sum(Y));
    end
    
    % SS Coop MLP
    if (ismember('Multilayer Perceptron', modelList.ML))
        status_mlp = models.ML.MLP.P(:,models.ML.MLP.positiveClass)>=alpha;
        detected_mlp = Y & status_mlp;
        falseAlarm_mlp = logical(status_mlp - detected_mlp);
        models.ML.MLP.Pd(i) = sum(detected_mlp)/sum(Y);
        models.ML.MLP.Pfa(i) = sum(falseAlarm_mlp)/(length(Y)-sum(Y));
    end
    
    % SS Coop K-Means
    if (ismember('K-Means Clustering', modelList.ML))
        status_kmeans = models.ML.KMeans.P(:,models.ML.KMeans.positiveClass)>=alpha;
        detected_kmeans = Y & status_kmeans;
        falseAlarm_kmeans = logical(status_kmeans - detected_kmeans);
        models.ML.KMeans.Pd(i) = sum(detected_kmeans)/sum(Y);
        models.ML.KMeans.Pfa(i) = sum(falseAlarm_kmeans)/(length(Y)-sum(Y));
    end
    
    % SS Coop SVM
    if (ismember('Support Vector Machine', modelList.ML))
        status_svm = models.ML.SVM.P(:,models.ML.SVM.positiveClass)>=alpha;
        detected_svm = Y & status_svm;
        falseAlarm_svm = logical(status_svm - detected_svm);
        models.ML.SVM.Pd(i) = sum(detected_svm)/sum(Y);
        models.ML.SVM.Pfa(i) = sum(falseAlarm_svm)/(length(Y)-sum(Y));
    end
    
    % SS Coop NB
    if (ismember('Naive Bayes', modelList.ML))
        status_nb = models.ML.NB.P(:,models.ML.NB.positiveClass)>=alpha;
        detected_nb = Y & status_nb;
        falseAlarm_nb = logical(status_nb - detected_nb);
        models.ML.NB.Pd(i) = sum(detected_nb)/sum(Y);
        models.ML.NB.Pfa(i) = sum(falseAlarm_nb)/(length(Y)-sum(Y));
    end
    
end

%% AUC

for i=1:N
    models.basic.Ind.AUC(i) = trapz(models.basic.Ind.Pfa(:,i),models.basic.Ind.Pd(:,i));
end
models.basic.OR.AUC = trapz(models.basic.OR.Pfa, models.basic.OR.Pd);
models.basic.AND.AUC = trapz(models.basic.AND.Pfa, models.basic.AND.Pd);

if (isfield(models,'analytical'))
    models.analytical = structfun(@(x) (AUC(x)), models.analytical , 'UniformOutput', false);
end
if (isfield(models,'ML'))
    models.ML = structfun(@(x) (AUC(x)), models.ML , 'UniformOutput', false);
end

    function model = AUC(model)
        model.AUC = trapz(model.Pfa,model.Pd);
    end

end