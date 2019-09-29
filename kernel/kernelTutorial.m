%% Kernel regression

% find y(x)

N = 100;

x = rand(4,N)';

t = [(x(:,1)+x(:,2)) (x(:,3)+x(:,4)).^2]; % q=4,

lambda = 0.00001;
%%
K = zeros(N);
for i = 1:N
    for j = 1:N
        K(i,j) = gaussK(x(i,:),x(j,:));
    end
end

%%
M = 50;
testData = rand(4,M)';
testTargets = [(testData(:,1)+testData(:,2)) (testData(:,3)+testData(:,4)).^2];

k = zeros(N,M);
for n = 1:N
    for m = 1:M
        k(n,m) = gaussK(testData(m,:),x(n,:));
    end
end

%%

pred1 = k'/(K+lambda*eye(N))*t(:,1);
pred2 = k'/(K+lambda*eye(N))*t(:,2);

%%

plot(pred1)
hold on
plot(testTargets(:,1))
hold off