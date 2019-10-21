function kernel = matGaussK(X,sigma)

kernel = exp(-X./(2*sigma));