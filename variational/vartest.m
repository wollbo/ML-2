%% variational2
clear all
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = double(rgb2gray(imageMatrix));
trueMatrix = double(imageMatrix);
N = 256; %8bit
M = length(imageMatrix);

%% GF(2^k) noise

p = 0.1;
flipM=binornd(1,p*ones([M M]));
flipped = imageMatrix(flipM==1);
flipped = randi(N,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;

%%

imageChain = makeChain(flippedMatrix,1);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%%
support = 1:256;
K = length(support);
[conds,raw] = condHist(imageChain,K); % to be modeled term wise as a gaussian!


%%

% prior p(mu|tau) = N(mu|mu_0, (gamma_0 * tau)^-1
% p(tau) = Gam(tau|a0,b0) = 1/gamma(a0)*b0^a0 * tau^(a0-1) * exp(-b0 * tau)

probs = conds(128,:);
rawdata = raw(128,:);
rawz = []; %preallocate through sum(rawdata)
for k = 1:length(rawdata)
    for l = 1:rawdata(k)
        rawz = [rawz k];
    end
end
x = rawz;
%% n = 128
epochs = 1000;
[~,mu0] = max(probs); 
N = length(x);
lambda0 = 0.001; %lambda0 too large means that the mean gets searched for in a small area - too small to contain any samples!
a0 = 1;
b0 = 1;
eTau = 0.00001; % needs to be small initially, often evaluates to 0 if lambda0 is too large! 
for k = 1:epochs
muN = (sum(x) + lambda0*mu0)/(N+lambda0);
lambdaN = eTau*(N+lambda0);
eMu = expectationMu(x,mu0,lambda0,muN,lambdaN);
aN = a0 + (N+1)/2;
bN = b0 + 1/2 * eMu;
%eTau = N / sum((x-mean(x)).^2);
eTau = aN/bN; % unstable, but ought to be used.
end

%%
f1 = figure('Name', 'figures/oneCond')
plot(conds(128,:))
hold on
plot(normpdf(support,muN,sqrt(1/eTau)))
hold off