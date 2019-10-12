function histProbs = condHist(imageChain,K)

kminusCounts = zeros(K);
L = length(imageChain);
for l = 2:L
kminusCounts(imageChain(l),imageChain(l-1)) = kminusCounts(imageChain(l),imageChain(l-1)) + 1;
end
histProbs = kminusCounts;
for k = 1:K
    if sum(histProbs(k,:))>0
        histProbs(k,:) = histProbs(k,:)./sum(histProbs(k,:));% represents p(x_k = i | x_k-1 = j) in matrix form K_ij
    end 
end
end