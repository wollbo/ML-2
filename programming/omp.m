%% init
%clear all

N = 40; % N<M
M = 50;
A = randn(N,M);
b = randn(N,1);
x = zeros(M,1);
x(1:5) = 1;

%%

alpha = 5; % a bit arbitrary
r = b-A*x;
S = [];
f = A;
epsilon = zeros(M,1);
rVec = zeros(N,1);
numSpace = 1:M;


%%

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
    %epsilon = 0;
end
x = rVec(S);

%AT  AAT ?1
%    x = (A*A')\A'*b %% subject to constraints??
%    r = b-A*x
%    cond = length(find(x));     