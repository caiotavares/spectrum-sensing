function KMeans = KMeans(train, test)

[~,C] = kmeans(train.X,2); % Get clusters locations
[~,~,~,D] = kmeans(test.X,2,'MaxIter',1,'Start',C); 
[~,index] = sort(mean(C,2));
KMeans.P = 1-(D./sum(D,2)); % Normalizing the distance and complementing to reflect the probability
KMeans.positiveClass = index(end);
KMeans.model = C;
KMeans.name = 'K-Means Clustering';