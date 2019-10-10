addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');

L = length(imageMatrix);
imageMatrix = rgb2gray(imageMatrix);
trueMatrix = imageMatrix;
N = 256; %8bit
%N = 8;

%%

p = 0.1;
flipM=binornd(1,p*ones([L L]));
flipped = imageMatrix(flipM==1);
flipped = randi(255,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;

%%

noiseMatrix = randn(512)*0.1;
gaussianMatrix = round(double(imageMatrix) + noiseMatrix);

%%

imageChain = makeChain(flippedMatrix);
decodedChain = zeros(size(imageChain));

%% get prior probability p(y|x): should perhaps not be gaussian but 0.9:1/N
support = 0:255;
K = length(support);
%hists = histogram(imageChain, 256,'Normalization','probability'); % consider modifying bins to 0:255 even though it will have some zero elements
priorProb = zeros(K);
for k = 1:K
    priorProb(k,:) = normpdf(support,support(k),2); % gaussian noise case
end
%priorProb(:,:) = 1/K;
%priorProb = priorProb + eye(N)*(1-p-1/K);

%% p(x(k)|x(k-1)) from histogram

kminusCounts = zeros(K);
for l = 2:L^2
kminusCounts(imageChain(l),imageChain(l-1)) = kminusCounts(imageChain(l),imageChain(l-1)) + 1;
end
histProbs = kminusCounts;
for k = 1:K
    if sum(histProbs(k,:))>0
        histProbs(k,:) = histProbs(k,:)./sum(histProbs(k,:));% represents p(x_k = i | x_k-1 = j) in matrix form K_ij
    end 
end

%% SP-implementation

decision = zeros(L^2,1);
decision(1) = imageChain(1);
support = 0:255;
for k = 2:L^2
    [~,decision(k)] = max(priorProb(imageChain(k),:).*histProbs(:,decision(k-1))'); % important part 
    decodedChain(k) = support(decision(k));
end

%%

imageMatrix2 = uint8(makeImage(decodedChain));
imshow(imageMatrix2)
mean(mean((imageMatrix-trueMatrix).^2))