% maxsum
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = rgb2gray(imageMatrix);
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

%% Create image Chain

imageChain = makeChain(flippedMatrix,1);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%% p(y|x) assuming x uniformly distributed, gaussian noise case

support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2);
end
%% %% p(x(k)|x(k-1), x(k+1)) from histogram

kminusCounts = zeros(K,K,K);
for l = 2:L-1
kminusCounts(imageChain(l),imageChain(l-1),imageChain(l+1)) = kminusCounts(imageChain(l),imageChain(l-1),imageChain(l+1)) + 1;
end
histProbs = kminusCounts;
for k = 1:K
    for j = 1:K
        if sum(histProbs(k,j,:))>0
        histProbs(k,j,:) = histProbs(k,j,:)./sum(histProbs(k,j,:));% represents p(x_k = i | x_k-1 = j, x_k+1 = l) in matrix form K_ijl
        end 
    end
end

%%
muXF = zeros(L,K);
muFX = zeros(L,1);
muPhi = log(priorProbs(imageChain(1),:)); % log necessary in larger images
muXF(1,:) = muPhi;
indX = zeros(L,1);
indX(1) = imageChain(1);
for l = 2:L-1 % forward loop, only smoothes the picture without removing noise
    [muFX(l),indX(l)] = max(log(histProbs(imageChain(l),:,imageChain(l-1))) + muXF(l-1,:));
    muXF(l,:) = muFX(l);%+log(priorProbs(imageChain(l),:));
end
disp('done')

%%

imageMatrix2 = uint8(makeImage(indX,1));
noisyMatrix = uint8(flippedMatrix);
imshow(imageMatrix2)
mse1 = mean(mean((double(imageMatrix2)-trueMatrix).^2));
mse2 = mean(mean((double(noisyMatrix)-trueMatrix).^2));

ratio = mse1/mse2
