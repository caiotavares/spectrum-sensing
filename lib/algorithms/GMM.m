function GMM = GMM(X, A, training)

trainingIndexes = sort(randperm(length(X), round(length(X)*training)))';
X_training = X(trainingIndexes,:);

testIndexes = setdiff(1:size(X,1),trainingIndexes)';
X_test = X(testIndexes,:);

model = fitgmdist(X_training,2,'Options',statset('Display','final'));
[~,~,P] = cluster(model,X_test);
[~,index] = sort(mean(model.mu,2));
GMM.P = P;
GMM.A = A(testIndexes);
GMM.positiveClass = index(end);
GMM.model = model;
GMM.name = 'Learned Gaussian Mixture';