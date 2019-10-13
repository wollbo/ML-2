function eMu = expectationMu(x,mu0,lambda0,muN,lambdaN)
    
    support = 1:max(x); % represents mu support
    I = 0;
    probs = normpdf(support,muN,(1/lambdaN));
    for k = 1:length(support)
        I = probs(k)*sum((x-support(k)).^2+lambda0*(support(k)-mu0)) + I;
    end
    eMu = I;
end
