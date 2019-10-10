% maxsum
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = rgb2gray(imageMatrix);
trueMatrix = imageMatrix;
N = 256; %8bit

%%

noiseMatrix = randn(512)*0.1;
flippedMatrix = round(double(imageMatrix) + noiseMatrix);
imageChain = makeChain(flippedMatrix);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%% p(y|x) assuming x uniformly distributed

support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2); % gaussian noise case
end

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
for l = 2:L % forward loop
    [muFX(l),indX(l)] = max(log(histProbs(imageChain(l),:)) + muXF(l-1,:));
    muXF(l,:) = muFX(l)*log(priorProbs(imageChain(1),:));
end
disp('done')
%%

imageMatrix2 = uint8(makeImage(indX));
imshow(imageMatrix2)
mean(mean((imageMatrix-trueMatrix).^2))