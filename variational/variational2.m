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

%% general case
[conds,raw] = condHist(imageChain,K);
epochs = 1; % if too high, might cause some distributions to collapse
lambda0 = 0.0001; %lambda0 too large means that the mean gets searched for in a small area - too small to contain any samples!
a0 = 1;
b0 = 10000;
eTau = 0.0001; % needs to be small initially, often evaluates to 0 if lambda0 is too large! 
[~,mu0] = max(conds,[],2);
mu = zeros(K,1);
sigma = mu;
normpdfs = zeros(K); % tentative
for k = 1:K % cant get 256 different differences, only 255!
    %while sigma(k) < 1 % to prevent collapsed data
    [mu(k),sigma(k)] = uniGaussian(raw(k,:),conds(k,:),mu0(k),lambda0,a0,b0,eTau,epochs);
    disp(k)
    %end
    normpdfs(k,:) = normpdf(support,mu(k),sigma(k));
end

%%
f2 = figure('Name','figures/normpdfsSurfAbove')
surf(normpdfs(1:256,:)) % can replace histProbs in maxsum ! works!
%%
support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2);
end

%%
histProbs = condHist(imageChain,K);
span = 30:230;
histProbs(span,:) = normpdfs(span,:);
muXF = zeros(L,K);
muFX = zeros(L,1);
muPhi = log(priorProbs(imageChain(1),:)); % log necessary in larger images
muXF(1,:) = muPhi;
indX = zeros(L,1);
indX(1) = imageChain(1);
for l = 2:L % forward loop, only smoothes the picture without removing noise
    [muFX(l),indX(l)] = max(log(histProbs(imageChain(l),:)) + muXF(l-1,:));
    muXF(l,:) = muFX(l);%+log(priorProbs(imageChain(l),:));
end
disp('done')

%%
imageMatrix2 = uint8(makeImage(indX,1));
noisyMatrix = uint8(flippedMatrix);
imshow(imageMatrix2)
mse1 = mean(mean((double(imageMatrix2)-trueMatrix).^2));
mse2 = mean(mean((double(noisyMatrix)-trueMatrix).^2));


%%
f1 = figure('Name','figures/subplotCompareVariational')
subplot(1,2,1), imshow(noisyMatrix);
subplot(1,2,2), imshow(imageMatrix2);
suptitle(['MSE ratio = ' num2str(ratio)])
