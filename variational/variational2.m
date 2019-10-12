%% variational2

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

imageChain = makeChain(flippedMatrix);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%%
support = 0:255;
K = length(support);
conds = condHist(imageChain,K);
%%

% prior p(mu|tau) = N(mu|mu_0, (gamma_0 * tau)^-1
% p(tau) = Gam(tau|a0,b0) = 1/gamma(a0)*b0^a0 * tau^(a0-1) * exp(-b0 * tau)


