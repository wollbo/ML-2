%% diff test


addpath datasets
folder = 'datasets/cifar';


N = 1000;
K_ensemble = zeros(N,N,5,10);
diffx = zeros(N);
load([char(folder) '/data_batch_' num2str(1) '.mat'])
x = double(data);
x = x./max(max(x)); % normalize
    
%x = x(1:N,:);

%%

x = [(1:5)' randn(5,1)];
N = length(x)
xshift = zeros(size(x));
xmat = zeros(N);
for k = 1:N-1 % either try to do the diagonal approach or do column wise
    xshift = circshift(x,[k 0]);
    xmat(k+1:end, 
end