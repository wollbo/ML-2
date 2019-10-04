addpath datasets
folder = 'datasets/cifar';
% error in k_ensemble
% everything else looks good

N = 1000;
K_ensemble = zeros(N,N,5,10);
for k = 1:5
    load([char(folder) '/data_batch_' num2str(k) '.mat'])
    x = double(data);
    x = x./max(max(x)); % normalize
    targets = double(labels)+1; % for indexing
    %targets = targets(1:N);
    dims = max(targets);
    %t = (-1)*ones(N,dims);
    t = zeros(N,dims,10,5);
    for j = 1:10
        for i = 1:N % create one hot
        t(i,targets(i+(j-1)*N),j,k) = 1;
        end
    end
    sigma = 10;
    for n = 1:10
        K_ensemble(:,:,k,n) = matGaussK(xDiff(x(1+(n-1)*N:n*N,:)),sigma);
    end
disp(k)    
end

%% only on windows
%load('D:\MATLAB\Repos\ML-2\datasets\cifar\test_batch.mat');
load([char(folder) '/test_batch.mat'])
%% 
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

%%

I = eye(N);
lambda = 0.2;
M = 100;
k_ensemble = zeros(M,N,5,10);
for l = 1:5
load([char(folder) '/data_batch_' num2str(l) '.mat'])
x = double(data);
x = x./max(max(x));
sigma = 10; % to avoid rounding to zero on non diagonal elements
for j = 1:10
    testDiff = xDiff(x(1+(j-1)*N:N*j,:),testData(1:M,:)); % wrong. all elements large, bottom row zeroes
    k_ensemble(:,:,l,j) = matGaussK(testDiff,sigma);
end
disp(l)
end
disp('done')

%%

ensemble = zeros(5,10,M);
for n = 1:5 
    for m = 1:10
        z = k_ensemble(:,:,n,m)*((K_ensemble(:,:,n,m)+lambda*I)\t(:,:,m,n).*100);
        [~,guess] = max(z,[],2);
        ensemble(n,m,:) = guess;
    end
end
guess = squeeze(squeeze(mode(mode(ensemble,2),1)));
error = length(testTargets(testTargets~=guess))/M