%%gaussIm

% maxsum
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = rgb2gray(imageMatrix);
trueMatrix = double(imageMatrix);
N = 256; %8bit
M = length(imageMatrix);



% Gaussian noise
% 
% noiseMatrix = randn(M)*30;
% flippedMatrix = round(double(imageMatrix) + noiseMatrix);
% flippedMatrix(flippedMatrix<1) = 1;
% flippedMatrix(flippedMatrix>256) = 256;

% GF(2^k) noise

pVec = 0.1;
P = length(pVec);
for p = 1:P
imageMatrix = trueMatrix;
flipM=binornd(1,pVec(p)*ones([M M]));
flipped = imageMatrix(flipM==1);
flipped = randi(N,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;

% Create image Chain

imageChain = makeChain(flippedMatrix,1);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

% p(y|x) assuming x uniformly distributed, gaussian noise case

support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2);
end

% p(x(k)|x(k-1)) from histogram
beta = 1;
histProbs = condHist(imageChain,K);
Kern = zeros(sqrt(L),sqrt(L),sqrt(L));
for l = 1:sqrt(L)
    Kern(:,:,l) = matGaussK(xDiff(imageChain(1+(l-1)*sqrt(L):l*sqrt(L))),1);
    C = Kern+beta*eye(sqrt(L));
end
indX = zeros(L,1);
indX(1) = imageChain(1);

%%
for l = 2:L-1 % forward loop, only smoothes the picture without removing noise
    k(l) = matGaussK(xDiff(imageChain(1+(l-1)*sqrt(L):l*sqrt(L)),imageChain(l)),1);
end
disp('done')
   
%

imageMatrix2 = uint8(makeImage(indX,1));
noisyMatrix = uint8(flippedMatrix);
mse1 = mean(mean((double(imageMatrix2)-trueMatrix).^2));
mse2 = mean(mean((double(noisyMatrix)-trueMatrix).^2));

ratio(p) = mse1/mse2;
mseVec(p) = mse1;

end