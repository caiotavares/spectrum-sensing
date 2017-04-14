function [X,S] = PUtx(M,samples,txPower, Pr)

% Get the PU transmission
%
% PUtx(M,samples,txPower, Pr_1)
% M - Number of PUs
% samples - Number of transmission samples
% txPower - Average transmission power for each PU
% Pr - Active probability for each PU

if (length(Pr) ~= M)
    error('Erro in the probability vector')
end

S = zeros(1,M); % PU states
X = zeros(M,samples); % Signal at PU transmitters

for i=1:M
    p = rand(1);
    if (p <= Pr(i))
        S(i) = 1;
    end
end

if (sum(S)>0)
    X(S'==1,:) = normrnd(0,sqrt(txPower(S'==1)),sum(S),samples);
end

end