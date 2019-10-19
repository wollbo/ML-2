clear all
addpath datasets
folder = 'datasets\cifar';

%%
neurons = 3000;
lambda = 100;
N = 10000;
M = 10000; % size of test set
dims = 3072;


for k = 1:10
for l = 1:length(neurons) % length(lambda)
    b1 = -1 + (2).*rand(neurons(l),1);
    b2 = -1 + (2).*rand(neurons(l),1);
    b3 = -1 + (2).*rand(neurons(l),1);
    B1 = zeros(neurons(l),N);
    B2 = B1;
    B3 = B2;
    for i = 1:N
    B1(:,i) = b1;
	B2(:,i) = b2;
    B3(:,i) = b3;
    end

[x, t] = readData(folder,N);
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
    w1 = -1 + (2).*rand(neurons(l),P);
    w2 = -1 + (2).*rand(neurons(l));
    w3 = -1 + (2).*rand(neurons(l));

    z1 = w1*x+B3;
    y1 = sigmoid2(z1);
    z2 = w2*y1+B3;
    y2 = sigmoid2(z2);
    z3 = w3*y2+B3;
    y3 = sigmoid2(z3);
    
    
    O = (y3*y3'+lambda*I)\(t*y3')'; %lambda(l)
    O = O';
    out = O*sigmoid2(w3*z3+B3);
    O_ensemble(:,:,m) = O;
    w_ensemble1(:,:,m) = w1;
    w_ensemble2(:,:,m) = w2;
    w_ensemble3(:,:,m) = w3;

end

% B_test = zeros(n,M);
% for j = 1:M
%     B_test(:,j) = b;
% end
%B_test = B;
ensemble = zeros(5,N);
x_test = xTest';
[~,targets] = max(tTest,[],2);
for m = 1:5 
    
    z1 = w_ensemble1(:,:,m)*x_test+B3;
    y1 = sigmoid2(z1);
    z2 = w_ensemble2(:,:,m)*y1+B3;
    y2 = sigmoid2(z2);
    out = O_ensemble(:,:,m)*sigmoid2(w_ensemble3(:,:,m)*y2+B3);
    [~,guess] = max(out);
    ensemble(m,:) = guess;
end
guess = mode(ensemble,1);
error(l,k) = length(targets(targets~=guess'))/M;
end
disp(k);
end

kFoldMean = mean(error,2)
