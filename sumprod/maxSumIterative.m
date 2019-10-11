%% maxSum iterative
    % idea: add another loop with correlations laterally
    % cycle between vertical and horizontal chain!

addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = rgb2gray(imageMatrix);
trueMatrix = double(imageMatrix);
N = 256; %8bit
M = length(imageMatrix);
%% GF(2^k) noise

p = 0.05;
flipM=binornd(1,p*ones([M M]));
flipped = imageMatrix(flipM==1);
flipped = randi(N,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;
noisyMatrix = uint8(flippedMatrix);

mseNoisy = mean(mean((double(noisyMatrix)-trueMatrix).^2))
imshow(noisyMatrix)

%% Create image Chain

imageChain = makeChain(flippedMatrix);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%%

support = 1:256;
K = length(support);
priorProbs = 1/N * ones(K) + eye(K)*(1-p-1/N);

%% loop from here - does not obviously converge to a smaller value over time

for i = 1:1

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

muXF = zeros(L,K);
muFX = muXF;
muPhi = log(priorProbs(imageChain(1),:)); % log necessary in larger images
muXF(1,:) = muPhi;
indX = zeros(L,1);
indX(1) = imageChain(1);
for l = 2:L % sort of works with GF(2^K) noise
    [muFX(l),indX(l)] = max(log(histProbs(imageChain(l),:)) + muXF(l-1,:));
    muXF(l,:) = muFX(l);%+log(priorProbs(imageChain(l),:));
end
disp('done')

imageMatrixFiltered = uint8(makeImage(indX));
mseFiltered = mean(mean((double(imageMatrixFiltered)-trueMatrix).^2))
imshow(imageMatrixFiltered)
imageChain = makeChain(imageMatrixFiltered);
end