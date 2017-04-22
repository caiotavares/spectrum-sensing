function [Y,GM] = GMM(X,K,start)

% Fit a Gaussian Mixture Model to the data in X, with K clusters.
%
% [Y,GM] = GMM(X,K,start)
% X - N x D matrix with data to fit.
% K - Scalar. Number of clusters to use.
% start - Initial conditions to use in the model.

% Fit the GM model
options = statset('Display','final');
if (nargin > 2)
    GM = fitgmdist(X,K,'Options',options,'Start',start);
else
    GM = fitgmdist(X,K,'Options',options);
end

% Apply GM model to cluster the data
Y = cluster(GM,X)-1;