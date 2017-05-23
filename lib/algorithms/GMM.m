function GMM = GMM(train, test)

GMM.model = fitgmdist(train.X,2,'Options',statset('Display','final'));
[~,~,GMM.P] = cluster(GMM.model,test.X);
[~,index] = sort(mean(GMM.model.mu,2));
GMM.positiveClass = index(end);
GMM.name = 'Learned Gaussian Mixture';