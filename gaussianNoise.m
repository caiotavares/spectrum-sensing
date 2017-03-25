function [n] = gaussianNoise(N,samples,noisePower)

% Returns the Gaussian Noise with zero mean and unitary variance
% 
% gaussianNoise(N,samples,noisePower)
% N - Number of SUs
% samples - Number of noise samples 
% noisePower - Noise power for each SU

n = randn(N,samples); % Gaussian noise

for i=1:N
    n(i,:) = n(i,:)/rms(n(i,:)); % Normalized noise power
    n(i,:) = n(i,:)*sqrt(noisePower(i));
end

end