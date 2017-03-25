function [x] = randisc(pmf, acc, p, N)

% Returns a random number for the given pmf

if (nargin == 1)
    if (sum(pmf) ~= 1)
        error('Error in provided pmf.');
    end
    p = rand(1);
    acc = pmf(1);
    N = 1;
end

if (p<=acc)
    x = N;
else
    N = N+1;
    acc = acc + pmf(N);
    x = randisc(pmf,acc,p,N);
end
