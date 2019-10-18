clear all
addpath datasets
folder = 'datasets\cifar';

%%
n = 1000; %neurons
lambda = [10^-4 10^-3 10^-2 10^-1 1 10 100 1000 10000 100000];
N = 10000;
M = 10000; % size of test set
b = -1 + (2).*rand(n,1);
B = zeros(n,N);
for i = 1:N
    B(:,i) = b;
end
for k = 1:10
for l = 1:length(lambda)

[x, t] = readData(folder,N);
[xTrain,tTrain,xTest,tTest] = scramble(x,t,M);
I = eye(n);
P = size(xTrain,2);

for m = 1:5
    x = xTrain((m-1)*N+1:m*N,:);
    t = tTrain((m-1)*N+1:m*N,:);
    x = x';
    t = t';
    w = -1 + (2).*rand(n,P);

    z = w*x+B;
    y = sigmoid2(z);
    O = (y*y'+lambda(l)*I)\(t*y')';
    O = O';
    out = O*sigmoid2(w*x+B);
    O_ensemble(:,:,m) = O;
    w_ensemble(:,:,m) = w;
end
% B_test = zeros(n,M);
% for j = 1:M
%     B_test(:,j) = b;
% end
B_test = B;
ensemble = zeros(5,N);
x_test = xTest';
[~,targets] = max(tTest,[],2);
for m = 1:5 
    out = O_ensemble(:,:,m)*sigmoid2(w_ensemble(:,:,m)*x_test+B_test);
    [~,guess] = max(out);
    ensemble(m,:) = guess;
end
guess = mode(ensemble,1);
error(l,k) = length(targets(targets~=guess'))/M;
end
end

kFoldMean = mean(error,[],2)

%%

f1 = figure('Name','figures/errorExtremeLambdaCross')
plot(kFoldMean)
axis([1 length(lambda) 0 1])
set(gca, 'XTick', 1:length(lambda)); % Change x-axis ticks
set(gca, 'XTickLabel', lambda);
title('Error rate with respect to lambda')
xlabel('lambda')