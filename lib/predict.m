function [Pd, Pfa, AUC] = predict(X, Y, N, models)
%% Setup

Pfa_target = 5e-3:5e-3:1;

Pd.ind = zeros(length(Pfa_target),N);
Pd.or = zeros(length(Pfa_target),1);
Pd.and = zeros(length(Pfa_target),1);
Pd.bayes = zeros(length(Pfa_target),1);
Pd.gmm = zeros(length(Pfa_target),1);
Pd.lgmm = zeros(length(Pfa_target),1);
Pd.mlp = zeros(length(Pfa_target),1);
Pd.kmeans = zeros(length(Pfa_target),1);
Pd.svm = zeros(length(Pfa_target),1);
Pd.nb = zeros(length(Pfa_target),1);

Pfa.ind = zeros(length(Pfa_target),N);
Pfa.or = zeros(length(Pfa_target),1);
Pfa.and = zeros(length(Pfa_target),1);
Pfa.bayes = zeros(length(Pfa_target),1);
Pfa.gmm = zeros(length(Pfa_target),1);
Pfa.lgmm = zeros(length(Pfa_target),1);
Pfa.mlp = zeros(length(Pfa_target),1);
Pfa.kmeans = zeros(length(Pfa_target),1);
Pfa.svm = zeros(length(Pfa_target),1);
Pfa.nb = zeros(length(Pfa_target),1);

%% Estimators

P_gmm = models.analytical.GMM.P;
P_wb = models.analytical.WB.P;

P_lgmm = models.ML.GMM.P;
P_mlp = models.ML.MLP.P;
P_kmeans = models.ML.KMeans.P;
P_svm = models.ML.SVM.P;
P_nb = models.ML.NB.P;

for i=1:length(Pfa_target)
    % Regulates the Pfa for probability based models
    alpha = 1-Pfa_target(i);
    % Traditional ED threshold
    lambda = 2*gammaincinv(Pfa_target(i),N/2,'upper')/N;
    % For comparison and/or validation
    %Pd.priori.ind(i,:) = gammainc(N*lambda./(2*(1+meanSNR)), N/2, 'upper');
    
    %% Analytical Models
    
    % SS Ind
    status_ind = X>=lambda;
    detected_ind = Y & status_ind;
    falseAlarm_ind = logical(status_ind - detected_ind);
    
    % SS Coop OR
    status_or = sum(X >= lambda,2) > 0; % SU predictions on channel occupancy (OR rule)
    detected_or = Y & status_or;
    falseAlarm_or = logical(status_or - detected_or);
    
    % SS Coop AND
    status_and = sum(X >= lambda,2) == size(X,2); % SU predictions on channel occupancy (AND rule)
    detected_and = Y & status_and;
    falseAlarm_and = logical(status_and - detected_and);
    
    % SS Coop Bayesian
    status_bayes = P_wb(:,2)>=alpha;
    detected_bayes = Y & status_bayes;
    falseAlarm_bayes = logical(status_bayes - detected_bayes);
    
    % SS Coop GMM
    status_gmm = P_gmm(:,2)>=alpha;
    detected_gmm = Y & status_gmm;
    falseAlarm_gmm = logical(status_gmm - detected_gmm);
    
    %% Machine Learning Models
    
    % SS Coop GMM
    status_lgmm = P_lgmm(:,models.ML.GMM.positiveClass)>=alpha;
    detected_lgmm = Y & status_lgmm;
    falseAlarm_lgmm = logical(status_lgmm - detected_lgmm);
    
    % SS Coop MLP
    status_mlp = P_mlp(:,models.ML.MLP.positiveClass)>=alpha;
    detected_mlp = Y & status_mlp;
    falseAlarm_mlp = logical(status_mlp - detected_mlp);
    
    % SS Coop K-Means
    status_kmeans = P_kmeans(:,models.ML.KMeans.positiveClass)>=alpha;
    detected_kmeans = Y & status_kmeans;
    falseAlarm_kmeans = logical(status_kmeans - detected_kmeans);
    
    % SS Coop SVM
    status_svm = P_svm(:,models.ML.SVM.positiveClass)>=alpha;
    detected_svm = Y & status_svm;
    falseAlarm_svm = logical(status_svm - detected_svm);
    
    % SS Coop NB
    status_nb = P_nb(:,models.ML.NB.positiveClass)>=alpha;
    detected_nb = Y & status_nb;
    falseAlarm_nb = logical(status_nb - detected_nb);
    
    %% Pd and Pfa
    
    Pd.ind(i,:) = sum(detected_ind)/sum(Y);
    Pd.or(i) = sum(detected_or)/sum(Y);
    Pd.and(i) = sum(detected_and)/sum(Y);
    Pd.bayes(i) = sum(detected_bayes)/sum(Y);
    Pd.gmm(i) = sum(detected_gmm)/sum(Y);
    Pd.lgmm(i) = sum(detected_lgmm)/sum(Y);
    Pd.mlp(i) = sum(detected_mlp)/sum(Y);
    Pd.kmeans(i) = sum(detected_kmeans)/sum(Y);
    Pd.svm(i) = sum(detected_svm)/sum(Y);
    Pd.nb(i) = sum(detected_nb)/sum(Y);
    
    Pfa.ind(i,:) = sum(falseAlarm_ind)/(length(Y)-sum(Y));
    Pfa.or(i) = sum(falseAlarm_or)/(length(Y)-sum(Y));
    Pfa.and(i) = sum(falseAlarm_and)/(length(Y)-sum(Y));
    Pfa.bayes(i) = sum(falseAlarm_bayes)/(length(Y)-sum(Y));
    Pfa.gmm(i) = sum(falseAlarm_gmm)/(length(Y)-sum(Y));
    Pfa.lgmm(i) = sum(falseAlarm_lgmm)/(length(Y)-sum(Y));
    Pfa.mlp(i) = sum(falseAlarm_mlp)/(length(Y)-sum(Y));
    Pfa.kmeans(i) = sum(falseAlarm_kmeans)/(length(Y)-sum(Y));
    Pfa.svm(i) = sum(falseAlarm_svm)/(length(Y)-sum(Y));
    Pfa.nb(i) = sum(falseAlarm_nb)/(length(Y)-sum(Y));
end

%% AUC

for i=1:N
    AUC.ind(i) = trapz(Pfa.ind(:,i),Pd.ind(:,i));
end
AUC.or = trapz(Pfa.or,Pd.or);
AUC.and = trapz(Pfa.and,Pd.and);
AUC.bayes = trapz(Pfa.bayes,Pd.bayes);
AUC.gmm = trapz(Pfa.gmm,Pd.gmm);
AUC.lgmm = trapz(Pfa.lgmm,Pd.lgmm);
AUC.mlp = trapz(Pfa.mlp,Pd.mlp);
AUC.kmeans = trapz(Pfa.kmeans,Pd.kmeans);
AUC.svm = trapz(Pfa.svm,Pd.svm);
AUC.nb = trapz(Pfa.nb,Pd.nb);
