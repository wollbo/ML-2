clear all
addpath datasets
folder = 'datasets\cifar';

%%
%neurons = 1000; %neurons
%neurons = [10 50 100 500 1000 5000 10000];
neurons = [1000 2000 3000 4000 5000 6000 7000 8000 9000 10000];
%lambda = [10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 1 10 100 1000 10000];
lambda = 100;
N = 10000;
M = 10000; % size of test set
dims = 3072;


for k = 1:10
for l = 1:length(neurons) % length(lambda)
    b = -1 + (2).*rand(neurons(l),1);
    B = zeros(neurons(l),N);
    for i = 1:N
    B(:,i) = b;
    end

[x, t] = readDataX(folder,N);
[xTrain,tTrain,xTest,tTest] = scramble(x,t,M);
I = eye(neurons(l));
P = size(xTrain,2);
O_ensemble = zeros(10,neurons(l),5);
w_ensemble = zeros(neurons(l),dims,5);
for m = 1:5
    x = xTrain((m-1)*N+1:m*N,:);
    t = tTrain((m-1)*N+1:m*N,:);
    x = x';
    t = t';
    w = -1 + (2).*rand(neurons(l),P);

    z = w*x+B;
    y = sigmoid2(z);
    O = (y*y'+lambda*I)\(t*y')'; %lambda(l)
    O = O';e
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
disp(k);
end

kFoldMean = mean(error,2)

%%

f1 = figure('Name','figures/errorExtremeLambdaCross')
plot(kFoldMean)
axis([1 length(lambda) 0 1])
set(gca, 'XTick', 1:length(lambda)); % Change x-axis ticks
set(gca, 'XTickLabel', lambda);
title('Error rate with respect to lambda')
xlabel('lambda')

%%

f1 = figure('Name','figures/errorExtremeNeuronCrossZoom')
plot(kFoldMean)
axis([1 length(neurons) 0.5 0.6])
set(gca, 'XTick', 1:length(neurons)); % Change x-axis ticks
set(gca, 'XTickLabel', neurons);
title('Error rate with respect to number of neurons in hidden layer')
xlabel('neurons')
