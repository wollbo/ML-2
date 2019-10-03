function energy = energy(x,y,neighbors)
%ENERGY Generic energy function
%   Detailed explanation goes here
h = 0;beta = 1; eta = 2.1;
y(y==1) = -1;
y(y==2) = 1;
x(x==1) = -1;
x(x==2) = 1;
neighbors(neighbors==1) = -1;
neighbors(neighbors==2) = 1;
energy = h*x-beta*sum(x.*neighbors)-eta*(x*y);
%energy = length(neighbors(x~=neighbors));


end

