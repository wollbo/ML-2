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

imageChain = makeChain(flippedMatrix);

%%

hists = histogram(imageChain, 256,'Normalization','probability'); % consider modifying bins to 0:255 even though it will have some zero elements
hists.Values; % probabilities
hists.BinEdges; % corresponding support - not all pixel values 0:255 are represented, bins cover ~3 pixels

%%

% basically, naive viterbi
% try to find most probable pixel value given that we know: flip
% probability p (p(y\x)) and p(x\x-1) from histogram. How to relate x in
% each term to maximization ? 

decision = zeros(L^2,1);
[~,decision(1)] = max(hists.Values);
support = 0:255;
for k = 2:L^2
    [~,decision(k)] = max((1-p)*hists.Values(imageChain(k))*hists.Values(decision(k-1))); % important part 
    imageChain(k) = support(decision(k));
end

%%

imageMatrix2 = makeImage(imageChain)
