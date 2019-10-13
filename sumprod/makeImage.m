function imageMatrix = makeImage(imageChain,dim)
    % add if nargin > 1 ... nonsquare matrix
    L = sqrt(length(imageChain));
    if dim == 1
    for b = 2*L:2*L:L^2
        imageChain(((b-L)+1):b) = flip(imageChain(((b-L)+1):b));
    end
    imageMatrix = reshape(imageChain,[L L]);
    elseif dim == 2
    for h = 2*L:2*L:L^2
        imageChain(((h-L)+1):h) = flip(imageChain(((h-L)+1):h));
    end   
    imageMatrix = reshape(imageChain,[],L)';
    else
        disp('dim is 1 or 2')
    end
end