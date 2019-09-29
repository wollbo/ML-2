% min x ||x||_2 s.t. Ax = b

N = 10;
M = 5;
A = ones(N,M);
b = ones(N,1);
x = ones(M,1);
%%
u = zeros(size(x));
v = u;
u(x>0) = x(x>0);
v(x<0) = -x(x<0);
z = [u' v']';
I = ones(2*M,1);
%%
L = [A,-A];
z = linprog(I,L,b)

