% run from ml-2
% kernel

addpath datasets
folder = 'datasets/cifar';


N = 1000;
K_ensemble = zeros(N,N,5,10);
for k = 1:5
    load([char(folder) '/data_batch_' num2str(k) '.mat'])
    x = double(data);
    x = x./max(max(x)); % normalize
    targets = double(labels)+1; % for indexing
    
    targets = targets(1:N);
    dims = max(targets);
    %t = (-1)*ones(N,dims);
    t = zeros(N,dims);
    for i = 1:N % create one hot
        t(i,targets(i)) = 1;
    end
    I = eye(N);
    lambda = 0.2;

    K = zeros(N);
    sigma = 10;
    for n = 1:10
        for i = 1:N
            for j = 1:N
            K(i,j) = gaussK(x(i+N*(n-1),:),x(j+N*(n-1),:),sigma); % so large data difference that exp(-k) rounds to zero
            end
        end
        K_ensemble(:,:,k,n) = K;
    end
    
disp(k)    
end


%%
load('D:\MATLAB\Repos\ML-2\datasets\cifar\test_batch.mat');
M = 1000;
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

k_ensemble = zeros(M,N,5,10);
for l = 1:5
k = zeros(N,M);
load([char(folder) '/data_batch_' num2str(l) '.mat'])
x = double(data);
x = x./max(max(x));
sigma = 10; % to avoid rounding to zero on non diagonal elements
for j = 1:10
    for n = 1:N
        for m = 1:M
            k(n,m) = gaussK(testData(m,:),x(n+N*(j-1),:),sigma);
        end
    end
    k_ensemble(:,:,l,j) = k;
end
disp(l)
end
disp('done')
%%
ensemble = zeros(5,N);
for n = 1:5 
    for m = 1:10
        z = k_ensemble(:,:,n,m)'*(K_ensemble(:,:,n,m)+lambda*I)\t;
        [~,guess] = max(z,[],2);
    end
    ensemble(n,m,:) = guess;
end
guess = mode(ensemble,1);
error = length(targets(targets~=guess'))/M


z = k'*(K+lambda*I)\t;
[~,guess] = max(z,[],2); % only guesses class 1 or 2
error = guess(guess~=(testTargets));
rate = length(error)/M