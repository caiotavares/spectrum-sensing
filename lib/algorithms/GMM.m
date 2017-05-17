function GMM = GMM(X, A, trainingPercent)

% truePositives = find(A==1);
% trueNegatives = find(A==0);
% positiveTrainingIndexes = truePositives(randperm(length(truePositives),round(length(truePositives)*trainingPercent)));
% negativeTrainingIndexes = trueNegatives(randperm(length(trueNegatives),round(length(trueNegatives)*trainingPercent)));
% trainingIndexes = sort([positiveTrainingIndexes;negativeTrainingIndexes]);

trainingIndexes = sort(randperm(length(X), round(length(X)*trainingPercent)))';
X_training = X(trainingIndexes,:);
testIndexes = setdiff(1:size(X,1),trainingIndexes)';
X_test = X(testIndexes,:);

options = statset('Display','final');
model = fitgmdist(X_training,2,'Options',options);
[~,~,P] = cluster(model,X_test);
[~,index] = sort(mean(model.mu,2));
GMM.P = P;
GMM.A = A(testIndexes);
GMM.positiveClass = index(end);
GMM.model = model;