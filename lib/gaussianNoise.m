function [n] = gaussianNoise(N,samples,noisePower)

% Returns the Gaussian Noise with zero mean and unitary variance
% 
% gaussianNoise(N,samples,noisePower)
% N - Number of SUs
% samples - Number of noise samples 
% noisePower - Noise power for each SU

n = zeros(N,samples);

for i=1:N
    n(i,:) = normrnd(0,real(sqrt(noisePower(i))),1,samples);
end

end