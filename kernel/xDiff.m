function xmat = xDiff(x,y)
% to be used as argument to GaussK: add nArgin statement in GaussK
if nargin == 1 % for K-matrix
N = size(x,1);
xmat = zeros(N);
for k = 1:N-1
    xdiff = x(k+1:end,:)-x(k,:);
    xmat(k+1:end, k) = vecnorm(xdiff,2,2);
end
xmat = xmat+xmat';
else
N = size(x,1);
M = size(y,1);
xmat = zeros(M,N);
for m = 1:M
    xdiff = x-y(m,:);
    xmat(m,:) = vecnorm(xdiff,2,2)';
end
end
