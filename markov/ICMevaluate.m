function imageMatrix = ICMevaluate(neighbors, trueMatrix, imageMatrix)
% evaluation step of ICM
y = imageMatrix;
x = trueMatrix;
K = length(neighbors);
yflipped = y;
yflipped(y==1) = 2;
yflipped(y==2) = 1;

for k= 1:K
    unflipped(k) = exp(-energy(x(k),y(k),neighbors(k,:)));
    flipped(k) = exp(-energy(x(k),yflipped(k),neighbors(k,:)));
end

evaluated = min(unflipped,flipped); % corresponds to new y
imageMatrix(evaluated==unflipped) = y(evaluated==unflipped); % needs to be accessed through imageMatrix(idx)
imageMatrix(evaluated==flipped) = yflipped(evaluated==flipped);

end