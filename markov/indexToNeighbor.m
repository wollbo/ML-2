function [neighborMatrix,idx] = indexToNeighbor(imageMatrix,border,neighbors)
%INDEXTONEIGHBOR takes imageMatrix, border and indices of neighbors and
%produces the pixel values of the neighbors in neighborMatrix
idx = sub2ind(size(imageMatrix), border(:,1), border(:,2));
for j = 1:size(neighbors, 2)
    idx2 = sub2ind(size(imageMatrix), neighbors(:,j,1), neighbors(:,j,2));
    neighborMatrix(:,j) = imageMatrix(idx2);
end
end

