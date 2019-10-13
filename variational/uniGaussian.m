function [mu,sigma] = uniGaussian(data,probabilities,mu0,lambda0,a0,b0,eTau,epochs)

rawz = []; %preallocate through sum(rawdata)
for k = 1:length(data)
    for l = 1:data(k)
        rawz = [rawz k];
    end
end
x = rawz;
%%
N = length(x);

for k = 1:epochs
muN = (sum(x) + lambda0*mu0)/(N+lambda0);
lambdaN = eTau*(N+lambda0);
eMu = expectationMu(x,mu0,lambda0,muN,lambdaN);
aN = a0 + (N+1)/2;
bN = b0 + 1/2 * eMu;
%eTau = N / sum((x-mean(x)).^2);
eTau = aN/bN; % unstable, but ought to be used.
end
mu = muN;
sigma = sqrt(1/eTau);
