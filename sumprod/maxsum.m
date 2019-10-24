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

pVec = 0.1:0.1:0.7;
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

% % p(y|x) assuming x uniformly distributed, GF(2^K) noise case
% 
% support = 1:256;
% K = length(support);
% priorProbs = 1/N * ones(K) + eye(K)*(1-pVec(p)-1/N);

% p(x(k)|x(k-1)) from histogram

histProbs = condHist(imageChain,K);

%

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
%[~,xN] = max(log(histProbs(imageChain(l),:)) + muXF(l-1,:))

   
%

imageMatrix2 = uint8(makeImage(indX,1));
noisyMatrix = uint8(flippedMatrix);
mse1 = mean(mean((double(imageMatrix2)-trueMatrix).^2));
mse2 = mean(mean((double(noisyMatrix)-trueMatrix).^2));

trueMean = mean(mean(double(trueMatrix)));
filtMean = mean(mean(double(imageMatrix2)));
nmseVec(p) = mean(mean((double(imageMatrix)-double(trueMatrix)).^2))/(trueMean*filtMean);

ratio(p) = mse1/mse2;
mseVec(p) = mse1;

end
%%

f1 = figure('Name','figures/subplotCompareMaxSum')

subplot(1,2,1), imshow(noisyMatrix);
subplot(1,2,2), imshow(imageMatrix2);
suptitle(['MSE ratio = ' num2str(ratio)])
