%% Setup

Pfa_target = 5e-3:5e-3:1;
Pd_priori_ind = zeros(length(Pfa_target),length(meanSNR));
Pd_post_ind = zeros(length(Pfa_target),length(meanSNR));
Pd_post_or = zeros(length(Pfa_target),1);
Pd_post_and = zeros(length(Pfa_target),1);
Pd_post_bayes = zeros(length(Pfa_target),1);
Pd_post_gmm = zeros(length(Pfa_target),1);
Pfa_post_ind = zeros(length(Pfa_target),length(meanSNR));
Pfa_post_or = zeros(length(Pfa_target),1);
Pfa_post_and = zeros(length(Pfa_target),1);
Pfa_post_bayes = zeros(length(Pfa_target),1);
Pfa_post_gmm = zeros(length(Pfa_target),1);

% Training Methodology

trainingPercent = 0.7;
truePositives = find(A==1);
trueNegatives = find(A==0);

positiveTrainingIndexes = truePositives(randperm(length(truePositives),round(length(truePositives)*trainingPercent)));
negativeTrainingIndexes = trueNegatives(randperm(length(trueNegatives),round(length(trueNegatives)*trainingPercent)));

trainingIndexes = sort([positiveTrainingIndexes;negativeTrainingIndexes]);
testIndexes = setdiff(1:size(X,1),trainingIndexes)';

X_training = X(trainingIndexes,:);
% X_test = X(testIndexes,:);
% A_test = A(testIndexes);
X_test = X;
A_test = A;
w = meanSNR';
 
%% ML

% Naive Bayes 
e = 1e-3;
P_X0_H1 = chi2cdf((X+e)*N./(1+meanSNR)',N) - chi2cdf((X-e)*N./(1+meanSNR)',N);
P_X0_H0 = chi2cdf((X+e)*N,N) - chi2cdf((X-e)*N,N);
P_H1 = scenario.Pr;
P_H0 = 1-P_H1;
P_H1_X0 = P_X0_H1*P_H1./(P_X0_H0*P_H0 + P_X0_H1*P_H1);
P_H0_X0 = 1-P_H1_X0;

% GMM
mu = [ones(1,length(meanSNR)); ones(1,length(meanSNR)).*(1+meanSNR)'];
sigma = [ones(1,length(meanSNR))*(2*N/N^2) ; ones(1,length(meanSNR)).*(2*N*((1+meanSNR)'.^2)/N^2)];
Sigma(:,:,1) = sigma(1,:);
Sigma(:,:,2) = sigma(2,:);
mixing = [1-scenario.Pr scenario.Pr];
startObj = struct('mu',mu,'Sigma',Sigma,'ComponentProportion',mixing);
options = statset('Display','final');
% GM = fitgmdist(X_training,2,'Start',startObj,'Options',options,'CovarianceType','diagonal');
GM = gmdistribution(mu,Sigma,mixing);
[~,~,P_gmm] = cluster(GM,X_test);

%% Metrics

for i=1:length(Pfa_target)
    
    alpha = Pfa_target(i); % Regulates the Bayes Pfa
    
    % Calculate the lambda threshold value using the Incomplete Gamma function
    lambda = 2*gammaincinv(alpha,N/2,'upper')/N;
    
    % SS Ind
    A_ind = X>=lambda;
    detected_ind = A & A_ind;
    misdetected_ind = logical(A - detected_ind);
    falseAlarm_ind = logical(A_ind - detected_ind);
    available_ind = ~A & ~A_ind;
    
    % SS Coop OR
    A_or = sum(X >= lambda,2) > 0; % SU predictions on channel occupancy (OR rule)
    detected_or = A & A_or;
    misdetected_or = logical(A - detected_or);
    falseAlarm_or = logical(A_or - detected_or);
    available_or = ~A & ~A_or;
    
    % SS Coop AND
    A_and = sum(X >= lambda,2) == size(X_test,2); % SU predictions on channel occupancy (AND rule)
    detected_and = A & A_and;
    misdetected_and = logical(A - detected_and);
    falseAlarm_and = logical(A_and - detected_and);
    available_and = ~A & ~A_and;
    
    % SS Coop Naive Bayes
    A_bayes = (sum(P_H1_X0.*w,2)/sum(w))>=(1-alpha);
    detected_bayes = A & A_bayes;
    misdetected_bayes = logical(A - detected_bayes);
    falseAlarm_bayes = logical(A_bayes - detected_bayes);
    available_bayes = ~A & ~A_bayes;
    
    % SS Coop GMM
    A_gmm = P_gmm(:,2)>=(1-alpha);
    detected_gmm = A_test & A_gmm;
    misdetected_gmm = logical(A_test - detected_gmm);
    falseAlarm_gmm = logical(A_gmm - detected_gmm);
    available_gmm = ~A_test & ~A_gmm;
    
    % Pd and Pfa to build the ROC curve
    Pd_priori_ind(i,:) = gammainc(N*lambda./(2*(1+meanSNR)), N/2, 'upper');
    Pd_post_ind(i,:) = sum(detected_ind)/sum(A);
    Pd_post_or(i) = sum(detected_or)/sum(A);
    Pd_post_and(i) = sum(detected_and)/sum(A);
    Pd_post_bayes(i) = sum(detected_bayes)/sum(A);
    Pd_post_gmm(i) = sum(detected_gmm)/sum(A_test);
    
    Pfa_post_ind(i,:) = sum(falseAlarm_ind)/(length(A)-sum(A));
    Pfa_post_or(i) = sum(falseAlarm_or)/(length(A)-sum(A));
    Pfa_post_and(i) = sum(falseAlarm_and)/(length(A)-sum(A));
    Pfa_post_bayes(i) = sum(falseAlarm_bayes)/(length(A)-sum(A));
    Pfa_post_gmm(i) = sum(falseAlarm_gmm)/(length(A_test)-sum(A_test));
    
end
