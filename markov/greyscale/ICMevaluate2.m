function imageMatrix = ICMevaluate2(neighbors,imageMatrix,N)
% seems to map to largest x not true x
x = 1:N;
K = length(neighbors);
y = double(imageMatrix+1); %map from 0:256 to 1:2
tentx = zeros(1,length(x));

for k = 1:K % check if parallellizable
    for j = 1:length(x)
        tentx(j) = exp(-energy2(x(j),y(k),double(neighbors(k,:))));
    end
    [~,idx] = max(tentx);
    imageMatrix(k) = uint8(idx);
end