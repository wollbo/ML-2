%% kernel test 

addpath datasets
folder = 'datasets/cifar';
% should be alright now
N = 1000;
M = 100;
K_ensemble = zeros(N,N,5);
lambda = 1;
I = eye(N);
[x, t] = readDataX(folder,N);
[xTrain,tTrain,xTest,tTest] = scramble(x,t,M);
tic
%%
sigma1 = 3000;
for n = 1:5
    K_ensemble(:,:,n) = matGaussK(xDiff(xTrain(1+(n-1)*N:n*N,:)),sigma1);
    disp(n)
end
%%
k_ensemble = zeros(M,N,5);
sigma2 = 3;
for m = 1:5
    testDiff = xDiff(x(1+(m-1)*N:N*m,:),xTest(1:M,:));
    k_ensemble(:,:,m) = matGaussK(testDiff,sigma2);
    disp(m)
end
%%
toc
ensemble = zeros(M,5);
for n = 1:5
    z = k_ensemble(:,:,n)*((K_ensemble(:,:,n)+lambda*I)\tTrain(1+(n-1)*N:n*N,:));
    [~,guess] = max(z,[],2);
    ensemble(:,n) = guess; % guess on whole vector
end

guess = mode(ensemble,2);
[~,testData] = max(tTest,[],2);
error = length(testData(testData~=guess))/M