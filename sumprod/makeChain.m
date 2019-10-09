function imageChain = makeChain(mat)
[H,B] = size(mat);
imageChain = mat(:);
for b = 2:2:B
    imageChain((H*(b-1)+1):H*b) = flip(imageChain((H*(b-1)+1):H*b));
end