addpath datasets
folder = 'datasets/cifar';
N = 10000;

lambda = [10^-4 10^-3 10^-2 10^-1 1 10 100 1000 10000 100000];

for l = 1:length(lambda)
w = zeros(3072,10,5);
for k = 1:5
    load([char(folder) '/data_batch_' num2str(k) '.mat'])
    x = double(data);
    x = x./max(max(x)); % normalize
    targets = double(labels)+1; % for indexing
    %targets = targets(1:N);
    dims = max(targets);
    %t = (-1)*ones(N,dims);
    t = zeros(N,dims);
    for i = 1:N % create one hot
    t(i,targets(i)) = 1;
    end
    disp(k) 

    I = eye(size(x,2));
    w(:,:,k) = (lambda(l)*I+x'*x)\x'*t;
end
load([char(folder) '/test_batch.mat']);
x = double(data);
targets = double(labels);
targets = targets+1; % for indexing
N = length(x);
dims = max(targets);
t = (-1)*ones(N,dims);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
for k = 1:5
    z(:,:,k) = (x*w(:,:,k));
end

[~,guess] = max(z,[],2);
guess = mode(squeeze(guess),2);
error = guess(guess~=(targets));
rate(l) = length(error)/length(x);
end


%%
f1 = figure('Name','figures/errorLinearLambda')
plot(rate)
axis([1 length(lambda) 0 1])
set(gca, 'XTick', 1:length(lambda)); % Change x-axis ticks
set(gca, 'XTickLabel', lambda);
title('Error rate with respect to lambda')