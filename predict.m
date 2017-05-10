function [Pd, Pfa] = predict(X, A, N, models)

% Setup

Pfa_target = 5e-3:5e-3:1;
Pd.priori.ind = zeros(length(Pfa_target),N);
Pd.post.ind = zeros(length(Pfa_target),N);
Pd.post.or = zeros(length(Pfa_target),1);
Pd.post.and = zeros(length(Pfa_target),1);
Pd.post.bayes = zeros(length(Pfa_target),1);
Pd.post.gmm = zeros(length(Pfa_target),1);
Pd.post.mlp = zeros(length(Pfa_target),1);
Pfa.post.ind = zeros(length(Pfa_target),N);
Pfa.post.or = zeros(length(Pfa_target),1);
Pfa.post.and = zeros(length(Pfa_target),1);
Pfa.post.bayes = zeros(length(Pfa_target),1);
Pfa.post.gmm = zeros(length(Pfa_target),1);
Pfa.post.mlp = zeros(length(Pfa_target),1);

%% Analytical Estimators

P_gmm = models.GMM.P_gmm;
P_wb = models.WB.P_wb;
P_mlp = models.MLP.P_mlp;
A_mlp = models.MLP.A_mlp;

%% Metrics

for i=1:length(Pfa_target)
    
    % Regulates the Pfa for probability based models
    alpha = 1-Pfa_target(i);
    % Traditional ED threshold
    lambda = 2*gammaincinv(Pfa_target(i),N/2,'upper')/N;
    
    % SS Ind
    status_ind = X>=lambda;
    detected_ind = A & status_ind;
    falseAlarm_ind = logical(status_ind - detected_ind);
    
    % SS Coop OR
    status_or = sum(X >= lambda,2) > 0; % SU predictions on channel occupancy (OR rule)
    detected_or = A & status_or;
    falseAlarm_or = logical(status_or - detected_or);
    
    % SS Coop AND
    status_and = sum(X >= lambda,2) == size(X,2); % SU predictions on channel occupancy (AND rule)
    detected_and = A & status_and;
    falseAlarm_and = logical(status_and - detected_and);
    
    % SS Coop Bayesian
    status_bayes = P_wb(:,2)>=alpha;
    detected_bayes = A & status_bayes;
    falseAlarm_bayes = logical(status_bayes - detected_bayes);
    
    % SS Coop GMM
    status_gmm = P_gmm(:,2)>=alpha;
    detected_gmm = A & status_gmm;
    falseAlarm_gmm = logical(status_gmm - detected_gmm);
    
    % SS Coop MLP
    status_mlp = P_mlp(:,2)>=alpha;
    detected_mlp = A_mlp & status_mlp;
    falseAlarm_mlp = logical(status_mlp - detected_mlp);
    
    % Pd and Pfa to build the ROC curve
    %Pd.priori.ind(i,:) = gammainc(N*lambda./(2*(1+meanSNR)), N/2, 'upper');
    Pd.post.ind(i,:) = sum(detected_ind)/sum(A);
    Pd.post.or(i) = sum(detected_or)/sum(A);
    Pd.post.and(i) = sum(detected_and)/sum(A);
    Pd.post.bayes(i) = sum(detected_bayes)/sum(A);
    Pd.post.gmm(i) = sum(detected_gmm)/sum(A);
    Pd.post.mlp(i) = sum(detected_mlp)/sum(A_mlp);
    
    Pfa.post.ind(i,:) = sum(falseAlarm_ind)/(length(A)-sum(A));
    Pfa.post.or(i) = sum(falseAlarm_or)/(length(A)-sum(A));
    Pfa.post.and(i) = sum(falseAlarm_and)/(length(A)-sum(A));
    Pfa.post.bayes(i) = sum(falseAlarm_bayes)/(length(A)-sum(A));
    Pfa.post.gmm(i) = sum(falseAlarm_gmm)/(length(A)-sum(A));
    Pfa.post.mlp(i) = sum(falseAlarm_mlp)/(length(A_mlp)-sum(A_mlp));
end
