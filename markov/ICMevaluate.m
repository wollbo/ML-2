function imageMatrix = ICMevaluate(neighbors, imageMatrix)
% evaluation step of ICM
y = imageMatrix;
x = imageMatrix;
K = length(neighbors);
xflipped = y;
xflipped(y==1) = 2;
xflipped(y==2) = 1;

for k= 1:K % jmf formula: max or min? this is p(x,y)
    unflipped(k) = exp(-energy(x(k),y(k),neighbors(k,:)));
    flipped(k) = exp(-energy(xflipped(k),y(k),neighbors(k,:)));
end

evaluated = max(unflipped,flipped); % corresponds to new y
imageMatrix(evaluated==unflipped) = y(evaluated==unflipped); % needs to be accessed through imageMatrix(idx)
imageMatrix(evaluated==flipped) = xflipped(evaluated==flipped);

end