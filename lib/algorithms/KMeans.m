function KMeans = KMeans(X,A,training)

trainingIndexes = sort(randperm(length(X), round(length(X)*training)))';
X_training = X(trainingIndexes,:);

testIndexes = setdiff(1:size(X,1),trainingIndexes)';
X_test = X(testIndexes,:);

[~,C] = kmeans(X_training,2); % Get clusters locations
[~,~,~,D] = kmeans(X_test,2,'MaxIter',1,'Start',C); 
[~,index] = sort(mean(C,2));
KMeans.P = 1-(D./sum(D,2)); % Normalizing the distance and complementing to reflect the probability
KMeans.A = A(testIndexes);
KMeans.positiveClass = index(end);
KMeans.model = C;
KMeans.name = 'K-Means';