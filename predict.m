%% PU detection procedure

% Setup
Pfa_target = 0:1e-4:1-1e-4;
w = meanSNR';
Pd_post_ind = zeros(length(Pfa_target),length(meanSNR));
Pfa_post_ind = zeros(length(Pfa_target),length(meanSNR));

for i=1:length(Pfa_target)
    
    alpha = Pfa_target(i); % Regulates the Bayes Pfa
    
    % Calculate the lambda threshold value using the Incomplete Gamma function
    lambda = 2*gammaincinv(alpha,N/2,'upper')/N;
    
    % SS Ind
    A_ind = X>lambda;
    detected_ind = A & A_ind;
    misdetected_ind = logical(A - detected_ind);
    falseAlarm_ind = logical(A_ind - detected_ind);
    available_ind = ~A & ~A_ind;
    
    % SS Coop OR
    A_or = sum(X > lambda,2) > 0; % SU predictions on channel occupancy (OR rule)
    detected_or = A & A_or;
    misdetected_or = logical(A - detected_or);
    falseAlarm_or = logical(A_or - detected_or);
    available_or = ~A & ~A_or;
    
    % SS Coop AND
    A_and = sum(X > lambda,2) == size(X,2); % SU predictions on channel occupancy (AND rule)
    detected_and = A & A_and;
    misdetected_and = logical(A - detected_and);
    falseAlarm_and = logical(A_and - detected_and);
    available_and = ~A & ~A_and;
    
    % SS Coop Bayes
    A_bayes = (sum(P_H1_X0.*w,2)/sum(w))>(1-alpha);
    detected_bayes = A & A_bayes;
    misdetected_bayes = logical(A - detected_bayes);
    falseAlarm_bayes = logical(A_bayes - detected_bayes);
    available_bayes = ~A & ~A_bayes;
    
    % Metrics
%     Pd_priori_ind = gammainc(N*lambda./(2*(1+meanSNR)), N/2, 'upper');
    Pd_post_ind(i,:) = sum(detected_ind)/sum(A);
    Pd_post_or(i) = sum(detected_or)/sum(A);
    Pd_post_and(i) = sum(detected_and)/sum(A);
    Pd_post_bayes(i) = sum(detected_bayes)/sum(A);
    
    Pfa_post_ind(i,:) = sum(falseAlarm_ind)/(length(A)-sum(A));
    Pfa_post_or(i) = sum(falseAlarm_or)/(length(A)-sum(A));
    Pfa_post_and(i) = sum(falseAlarm_and)/(length(A)-sum(A));
    Pfa_post_bayes(i) = sum(falseAlarm_bayes)/(length(A)-sum(A));
    
end