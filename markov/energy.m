function energy = energy(x,y,neighbors)
%ENERGY Generic energy function
%   Detailed explanation goes here
h = 0.5;beta = 0.3; gamma = 0.2;
energy = h*x+beta*(x-y).^2-gamma*(norm(x.*neighbors));


end

