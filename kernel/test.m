% run from ml-2
% kernel

addpath datasets
folder = 'datasets/cifar';
load('/Users/Hilding/Documents/Repos/ML-2/datasets/cifar/data_batch_1.mat'); % loads data, labels

x = double(data);
x = x(1:1000,:);
x = x./max(max(x)) % normalize
targets = double(labels)+1; % for indexing
targets = targets(1:1000);
N = size(x,1);
dims = max(targets);
%t = (-1)*ones(N,dims);
t = zeros(N,dims);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
I = eye(N);
lambda = 0.2;
disp('done')

%%

K = zeros(N);
sigma = 10;
for i = 1:N
    for j = 1:N
        K(i,j) = gaussK(x(i,:),x(j,:),sigma); % so large data difference that exp(-k) rounds to zero
    end
end
disp('done')
%%
load('/Users/Hilding/Documents/Repos/ML-2/datasets/cifar/data_batch_2.mat');
M = 100;
testData = double(data);
testData = testData(1:M,:);
testTargets = double(labels)+1;
testTargets = testTargets(1:M);


dims = max(testTargets);
tt = (-1)*ones(M,dims);
for i = 1:M % create one hot
    tt(i,testTargets(i)) = 1;
end
% note: should only be used for verification NOT in predictor

disp('done')
%%

k = zeros(N,M);
sigma = 10; % to avoid rounding to zero on non diagonal elements
for n = 1:N
    for m = 1:M
        k(n,m) = gaussK(testData(m,:),x(n,:),sigma);
    end
end

disp('done')
%%

z = (k'/(K+lambda*I))*t;
[~,guess] = max(z,[],2); % only guesses class 1 or 2
error = guess(guess~=(testTargets));
rate = length(error)/M