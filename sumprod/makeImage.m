function imageMatrix = makeImage(imageChain)
    % add if nargin > 1 ... nonsquare matrix
    L = sqrt(length(imageChain));
    for b = 2*L:2*L:L^2
        imageChain(((b-L)+1):b) = flip(imageChain(((b-L)+1):b));
    end
    imageMatrix = reshape(imageChain,[L L]);
end