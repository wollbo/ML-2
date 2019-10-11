% maxsum
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = rgb2gray(imageMatrix);
trueMatrix = double(imageMatrix);
N = 256; %8bit
M = length(imageMatrix);

%% Gaussian noise

noiseMatrix = randn(M)*40;
flippedMatrix = round(double(imageMatrix) + noiseMatrix);
flippedMatrix(flippedMatrix<1) = 1;
flippedMatrix(flippedMatrix>256) = 256;

%% GF(2^k) noise

p = 0.1;
flipM=binornd(1,p*ones([M M]));
flipped = imageMatrix(flipM==1);
flipped = randi(N,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;

%% Create image Chain

imageChain = makeChain(flippedMatrix);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%% p(y|x) assuming x uniformly distributed, gaussian noise case

support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2);
end

%% p(y|x) assuming x uniformly distributed, GF(2^K) noise case

support = 1:256;
K = length(support);
priorProbs = 1/N * ones(K) + eye(K)*(1-p-1/N);

%% p(x(k)|x(k-1)) from histogram

kminusCounts = zeros(K);
for l = 2:L
kminusCounts(imageChain(l),imageChain(l-1)) = kminusCounts(imageChain(l),imageChain(l-1)) + 1;
end
histProbs = kminusCounts;
for k = 1:K
    if sum(histProbs(k,:))>0
        histProbs(k,:) = histProbs(k,:)./sum(histProbs(k,:));% represents p(x_k = i | x_k-1 = j) in matrix form K_ij
    end 
end
%surf(kminusCounts)
%%

muXF = zeros(L,K);
muFX = muXF;
muPhi = log(priorProbs(imageChain(1),:)); % log necessary in larger images
muXF(1,:) = muPhi;
indX = zeros(L,1);
indX(1) = imageChain(1);
for l = 2:L % forward loop, only smoothes the picture without removing noise
    [muFX(l),indX(l)] = max(log(histProbs(imageChain(l),:)) + muXF(l-1,:));
    muXF(l,:) = muFX(l);%+log(priorProbs(imageChain(l),:));
end
disp('done')

%% could use a backward loop to update indX as x(n-1) | x(n) from x(N) to x(1)



%%

imageMatrix2 = uint8(makeImage(indX));
noisyMatrix = uint8(flippedMatrix);
imshow(imageMatrix2)
imshow(noisyMatrix)
mse1 = mean(mean((double(imageMatrix2)-trueMatrix).^2))
mse2 = mean(mean((double(noisyMatrix)-trueMatrix).^2))