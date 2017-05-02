%% Training Methodology (not operational)

trainingPercent = 0.7;
truePositives = find(A==1);
trueNegatives = find(A==0);
positiveTrainingIndexes = truePositives(randperm(length(truePositives),round(length(truePositives)*trainingPercent)));
negativeTrainingIndexes = trueNegatives(randperm(length(trueNegatives),round(length(trueNegatives)*trainingPercent)));
trainingIndexes = sort([positiveTrainingIndexes;negativeTrainingIndexes]);
testIndexes = setdiff(1:size(X,1),trainingIndexes)';
X_training = X(trainingIndexes,:);
X_test = X(testIndexes,:);
A_test = A(testIndexes);

% GM = fitgmdist(X_training,2,'Start',startObj,'Options',options,'CovarianceType','diagonal');