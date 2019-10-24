%% init
clear all

N = 40; % N<M
M = 100;
A = randn(N,M);
b = randn(N,1);
x = zeros(M,1);
indices = randperm(M,5);
x(indices) = rand(1,1);

alpha = 5; % a bit arbitrary
r = b-A*x;
S = [];
f = A;
epsilon = zeros(M,1);
rVec = zeros(N,1);
numSpace = 1:M;


%%
k = 1;
while (norm(r)>alpha && length(numSpace) > 1)
    for j = 1:size(A,2)
        z(j) = A(:,j)'*r/norm(A(:,j)).^2; epsilon(j) = norm(A(:,j)*z(j)-r).^2;
    end
    [~,J1] = min(epsilon(numSpace));
    J0 = numSpace(J1);
    S = [S J0];
    numSpace(J1) = [];
    rVec(S) = A(:,S)'*((A(:,S)*A(:,S)')\b);
    r = b-A(:,S)*rVec(S);
    k = k+1;
    %epsilon = 0;
    disp(norm(r))
end
xRec = rVec(S);

%AT  AAT ?1
%    x = (A*A')\A'*b %% subject to constraints??
%    r = b-A*x
%    cond = length(find(x));     

%%
xhat = zeros(N,1);
xhat(S) = xRec
