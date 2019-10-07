function energy = energy2(x,y,neighbors)
N = 256;
h = 0;beta = 1; eta = 2.1;
energy = h*x-beta*sum(cos((x-neighbors)./N))-eta*(cos((x-y)./N));