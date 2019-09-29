% run from ml-2
% linear

addpath datasets
folder = 'datasets/cifar';
load('/Users/Hilding/Documents/Repos/ML-2/datasets/cifar/data_batch_1.mat'); % loads data, labels

x = double(data);
targets = double(labels);
targets = targets+1; % for indexing
N = length(x);
dims = max(targets);
t = (-1)*ones(N,dims);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
I = eye(size(x,2));

%%
lambda = 0.2;
w = (lambda*I+x'*x)\x'*t;

%%
load('/Users/Hilding/Documents/Repos/ML-2/datasets/cifar/data_batch_2.mat');
x = double(data);
targets = double(labels);
targets = targets+1; % for indexing
N = length(x);
dims = max(targets);
t = (-1)*ones(N,dims);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
I = eye(size(x,2));
z = (w'*x')';
[~,guess] = max(z,[],2);
error = guess(guess~=(targets));
rate = length(error)/length(x)