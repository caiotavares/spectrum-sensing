function models = buildModels(X, A, N, meanSNR, Pr)

% Weighted Bayes
e = 1e-3;
shape = N/2;
scale = 2*ones(size(X,1),1).*(1+meanSNR)';
P_X0_H1 = gamcdf(N*(X+e),shape,scale) - gamcdf(N*(X-e),shape,scale);
P_X0_H0 = chi2cdf((X+e)*N,N) - chi2cdf((X-e)*N,N);
P_H1 = Pr;
P_H0 = 1-P_H1;
P_H1_X0 = P_X0_H1*P_H1./(P_X0_H0*P_H0 + P_X0_H1*P_H1);
P_H0_X1 = 1-P_H1_X0;
w = meanSNR';
models.WB.P = [sum(P_H0_X1.*w,2)/sum(w) sum(P_H1_X0.*w,2)/sum(w)];

% Analytical Gaussian Mixture Model
mu = [ones(1,length(meanSNR)); ones(1,length(meanSNR)).*(1+meanSNR)'];
sigma = [ones(1,length(meanSNR))*(2*N/N^2) ; ones(1,length(meanSNR)).*(2*N*((1+meanSNR)'.^2)/N^2)];
Sigma(:,:,1) = sigma(1,:);
Sigma(:,:,2) = sigma(2,:);
mixing = [1-Pr Pr];
GM = gmdistribution(mu,Sigma,mixing);
[~,~,models.GMM.analytical.P] = cluster(GM,X);
models.GMM.analytical.model = GM;

% Learned Gaussian Mixture Model
models.GMM.learned = GMM(X,A,0.7);

% Multilayer Perceptron
system('Rscript --vanilla R/ML.r')
models.MLP = load('MLP'); % Loads P and A_mlp
models.MLP.A = logical(models.MLP.A);