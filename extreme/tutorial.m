%% Extreme Learning Machine tutorial / improvements: change activation function
clear all
addpath datasets
folder = 'datasets\cifar';

%~0.577 with n=1000 and 5 ensemble


%%
n = 1000; % number of neurons
O_ensemble = zeros(10,n,5);
w_ensemble = zeros(n,3072,5);

for k = 1:5
    load([char(folder) '/data_batch_' num2str(k) '.mat'])
    N = 10000;
    x = double(data);
    x = x(1:N,:);
    x = x./max(max(x)); % normalize
    P = size(x,2);
    x = x';
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
    O_ensemble(:,:,k) = O;
    w_ensemble(:,:,k) = w;
end

%% Create test dataset
M = 10000;
load([char(folder) '\test_batch.mat'])
x_test = double(data);
x_test = x_test./(max(max(x_test))); % normalization
x_test = x_test';
targets = double(labels)+1; % for indexing
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
ensemble = zeros(5,N);
for k = 1:5 
    out = O_ensemble(:,:,k)*sigmoid2(w_ensemble(:,:,k)*x_test+B_test);
    [~,guess] = max(out);
    ensemble(k,:) = guess;
end
guess = mode(ensemble,1);
error = length(targets(targets~=guess'))/M


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