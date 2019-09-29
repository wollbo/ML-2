%% Extreme Learning Machine tutorial / improvements: change activation function
clear all
addpath datasets
folder = 'datasets/cifar';
load('/Users/Hilding/Documents/Repos/ML-2/datasets/cifar/data_batch_1.mat')%

N = 8000;

x = double(data);
x = x(1:N,:);
x = x./max(max(x)); % normalize
P = size(x,2);
x = x';
n = 20; % number of neurons
targets = double(labels)+1; % for indexing
targets = targets(1:N);
q = max(targets);
t = (-1)*ones(N,q);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
t = t';
I = eye(n);
lambda = 0.2; % implement crossvalidation
disp('done')

%%

w = -1 + (2).*rand(n,P);
b = -1 + (2).*rand(n,1);
B = zeros(n,N);
for i = 1:N
    B(:,i) = b;
end
z = w*x+B;
y = sigmoid2(z);
O = (y*y'+lambda*I)\(t*y')';
O = O';
out = O*sigmoid2(w*x+B);

%% Gradient Method: Optional / doesn't work now, probably because of bad activation function
eta = 0.01;
mu = 0.01;
epochs = 10;
for i = 1:epochs
    dO = -(t-out)*(sigmoid2(w*x+B))';
    [~,dY] = sigmoid2(w*x+B);
    dw = -O'*(t-out).*dY*x';
    w = w-eta*dw;
    O = O-mu*dO;
    out = O*sigmoid2(w*x+B);
end

%% Create test dataset
M = 200;
x_test = double(data);
x_test = x_test(N+1:N+M,:);
x_test = x_test./(max(max(x_test)));
x_test = x_test';
targets = double(labels)+1; % for indexing
targets = targets(N+1:N+M);
t_test = (-1)*ones(M,q);
for i = 1:M % create one hot
    t_test(i,targets(i)) = 1;
end
t_test = t_test';
B_test = zeros(n,M);
for j = 1:M
    B_test(:,j) = b;
end
%%
out = O*sigmoid2(w*x_test+B_test);
[~,guess] = max(out);
error = length(targets(targets~=guess'))/M