function nmse = ompGen(x,y,A,k0)

r = b;
S = [];
f = A;
epsilon = zeros(M,1);
numSpace = 1:M;
k = 0;
k0 = 10;
rpast = r+1;
numSpace = 1:M;


for n = 1:M
    k = k+1;
    %[~,J1] = max(A'*r);
    projs = (A'*r).^2;
    [~,idx] = max(projs(numSpace));
    S = [S numSpace(idx)];
    numSpace(idx) = [];
    if k<N
        alphaS = (A(:,S)'*A(:,S))\A(:,S)';
    elseif k==N
        alphaS = inv(A(:,S));
    else
        alphaS = A(:,S)'*inv(A(:,S)*A(:,S)');
    end
    xS = alphaS*b;
    rpast = r;
    r = b-A(:,S)*xS;
    if (norm(r)>norm(rpast) || k>k0)
        r = rpast;
        S = S(1:end-1);
        break
    else
        
    end
end
 
%% ?
xhat = zeros(M,1);
xhat(S) = A(:,S)'*((A(:,S)*A(:,S)')\b);

nmse = mean((xhat-x).^2)/(mean(xhat)*mean(x))