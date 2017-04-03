function H = channel(M,N,d,a,type)

% Calculate the channel matrix (path-loss + fading)
%
% H = channel(M,N,d,a)
%
% M: Number of PUs
% N: Number of SUs
% d: Euclidean distance between each PU-SU pair
% a: Path-loss exponent

if (nargin > 4 && strcmp(type,'ray'))
    H = sqrt(randn(M,N).^2 + randn(M,N).^2); % Rayleigh fading
else
    H = ones(M,N);
end

H = H.*sqrt(d.^(-a)); % Fading + path-loss (amplitude loss)

end