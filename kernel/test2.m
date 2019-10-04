%% diff test


addpath datasets
folder = 'datasets/cifar';


N = 1000;
K_ensemble = zeros(N,N,5,10);
diffx = zeros(N);
load([char(folder) '/data_batch_' num2str(1) '.mat'])
x = double(data);
x = x./max(max(x)); % normalize
    
x = x(1:N,:);
xmat = xDiff(x);
sigma = 10;
K = matGaussK(xmat);


%%

x = [(1:5)' randn(5,1)];

%xshift = zeros(size(x));
% function xmat = xDiff(x)
% N = size(x,2)
% xmat = zeros(N);
% for k = 1:N-1 % either try to do the diagonal approach or do column wise
%     %xshift = circshift(x,[k 0]);
%     xdiff = x(k+1:end,:)-x(k,:);
%     xmat(k+1:end, k) = vecnorm(xdiff,2,2);
% end
% xmat = xmat+xmat'