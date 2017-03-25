function [X,S] = PUtx(M,samples,txPower, Pr)

% Get the PU transmission
%
% PUtx(M,samples,txPower, Pr_1)
% M - Number of PUs
% samples - Number of transmission samples
% txPower - Average transmission power for each PU
% Pr_1 - Active probability

% S = zeros(1,M); % PU states
% X = zeros(M,samples); % Signal at PU transmitters

p = randisc(Pr);

if (p==1) % None active
    S = zeros(1,M);
    X = zeros(M,samples);
elseif (p==length(Pr)) % All active
    S = ones(1,M);
    X = randn(M,samples);    
else
    S = zeros(1,M);
    activePUs = p-1;
    perm = randperm(M);
    S(perm(1:activePUs)) = 1;
    X = zeros(M,samples);
    X(perm(1:activePUs),:) = randn(activePUs,samples);
end
    

for j=1:M
    power = rms(X(j,:));
    if (power>0)
        X(j,:) = X(j,:)/power; % Normalized power
    end
    X(j,:) = X(j,:)*sqrt(txPower(j));
end



end