function Q = qchi2(x,n)

% Calculates the right-tail probability for a chi-squared distribution with
% n degrees of freedom.

Q = 1-chi2cdf(x,n);

end