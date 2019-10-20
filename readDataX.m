function [xVec,tVec] = readDataX(folder,N)
nData = 5;
%xVec = zeros((nData+1)*N,3072);
%tVec = zeros((nData+1)*N,10);
xVec = [];
tVec = [];
for k = 1:nData
    load([char(folder) '/data_batch_' num2str(k) '.mat'])
    x = double(data);
    x = x(1:N,:);
    x = x./max(max(x));
    xVec = [xVec; x];
    
    targets = double(labels)+1; % for indexing
    targets = targets(1:N);
    q = max(targets);
    t = (-1)*ones(N,q);
    for i = 1:N % create one hot
        t(i,targets(i)) = 1;
    end
    tVec = [tVec; t];
    disp(k)
end
load([char(folder) '/test_batch.mat'])
x = double(data);
x = x(1:N,:);
x = x./max(max(x));
xVec = [xVec; x];
targets = double(labels)+1; % for indexing
targets = targets(1:N);
q = max(targets);
t = (-1)*ones(N,q);
for i = 1:N % create one hot
    t(i,targets(i)) = 1;
end
tVec = [tVec; t];