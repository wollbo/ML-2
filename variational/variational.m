% maxsum
addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');
imageMatrix = double(rgb2gray(imageMatrix));
trueMatrix = double(imageMatrix);
N = 256; %8bit
M = length(imageMatrix);

%% GF(2^k) noise

p = 0.1;
flipM=binornd(1,p*ones([M M]));
flipped = imageMatrix(flipM==1);
flipped = randi(N,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;
flippedMatrix = imageMatrix;

%%

imageChain = makeChain(flippedMatrix,1);
decodedChain = zeros(size(imageChain));
L = length(imageChain);

%%

support = 1:256;
K = length(support);
priorProbs = zeros(K);
for k = 1:K
    priorProbs(k,:) = normpdf(support,support(k),2);
end

%% Perhaps try to implement a gaussian distribution over p(x_k|x_k-1 instead
M = 10;
%gm = fitgmdist(imageChain,M); % should perhaps be initialized on uniform distribution

%
x = imageChain./max(imageChain);
alpha0 = ones(M,1);
alpha = alpha0;
beta0 = ones(M,1);
beta = beta0;
m0 = ones(M,1);
m = m0;
ny0 = ones(M,1);
ny = ny0;
gammaP0 = ones(M,1);
gammaP = gammaP0;


%%

for i = 1:1
    for k = 1:M
   
        %first update q(z)
        mixing(k) = psi(alpha(k)) - psi(sum(alpha));
        eGammaP(k) = psi(ny(k)/2)+log(2)+log(gammaP(k));
        emuGamma(k) = 1/beta(k)+ny(k)*(x-m(k))'*gammaP(k)*(x-m(k));
    
        rho(:,k) = mixing(k) + 1/2 * eGammaP(k) - 1/2 * emuGamma(:,k);
        r(:,k) = rho(:,k)/sum(rho(:,:));

        N(k) = sum(r(:,k));
        xbar(k) = 1/N(k) * sum(r(:,k).*x); % sample mean
        S(k) = 1/N(k) * sum(r(:,k)*(x-xbar(k)).^2); % (x-xbar(k))*(x-xbar(k))' not reasonable!

        %second update q(pi,mu,sigma) = q(pi)*prod(q(mu_k),sigma_k))
        alpha(k) = alpha0(k) + N(k);
        beta(k) = beta0(k) + N(k);
        m(k) = 1/(beta(k))*(beta0(k)*m0(k)+N(k)*xbar(k));
        gammaP(k) = gammaP0(k) + N(k)*S(k) + beta0(k)*N(k)*(xbar(k)-m0(k))*(xbar(k)-m0(k))'/(beta0(k)+N(k)); % inverse?
        ny(k) = ny0(k)+N(k)+1;
    end
end

%dirirch = gamrnd(alpha,1);
%qPi = dirirch/sum(dirirch);

