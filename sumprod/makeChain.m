function imageChain = makeChain(mat,dim)
[H,B] = size(mat);

if dim == 1
    imageChain = mat(:);
    for b = 2:2:B
        imageChain((H*(b-1)+1):H*b) = flip(imageChain((H*(b-1)+1):H*b));
    end
elseif dim ==2
    imageChain = reshape(mat.',1,[]);
    for h = 2:2:B
        imageChain((B*(h-1)+1):B*h) = flip(imageChain((B*(h-1)+1):B*h));
    end
else
    disp('dim takes 1 or 2')
end
