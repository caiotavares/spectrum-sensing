function [H] = channel(M,N,d,a)

% Calculate the channel matrix (path-loss + fading)
%
% [H,P] = channel(M,N,d,a)
% M - Number of PUs
% N - Number of SUs
% d - Euclidean distance between each PU-SU pair
% a - Path-loss exponent
%
% H - Rayleigh channel matrix
% P - Amplitude path-loss

% H = sqrt(randn(M,N).^2 + randn(M,N).^2); % Rayleigh fading
H = ones(M,N);

H = H.*sqrt((1e3*d).^(-a)); % Include path-loss component

end