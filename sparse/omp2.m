%% init
%clear all

N = 40; % N<M
M = 100;
A = rand(N,M);
b = rand(N,1);
x = zeros(M,1);
indices = randperm(M,5);
x(indices) = rand(1,1);

%%

alpha = 5; % a bit arbitrary
r = b;
S = [];
f = A;
epsilon = zeros(M,1);
numSpace = 1:M;
k = 0;
k0 = 50;
rpast = r +1;
%%
for n = 1:M
%while (norm(r(:,k+1))<norm(r(:,k)) && k <k0)
    if (norm(r)<norm(rpast) && k<k0)
    k = k+1;
    [~,J1] = max(norm(A'*r));
    S = [S J1];
    alphaS = A(:,S)'*inv(A(:,S)*A(:,S)');
    xS = alphaS*b;
    rpast = r;
    r = b-A(:,S)*xS;
    else
        break
    end
end
 
%%

xhat = A(:,S)'*(A(:,S)*A(:,S)')\b;