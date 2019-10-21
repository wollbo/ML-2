%% Tutorial

N = 100;

x = -pi/2 + pi.*rand(N,1);

phi = [sin(x) (x-10).^2];
w = [2;1];
beta = 10;

y = phi*w;

K = zeros(N);
for i = 1:N
    for j = 1:N
        K(i,j) = gaussK(x(i,:),x(j,:),1);
    end
end

C = K+beta*eye(N);


%%
M = 100;
x_test = -pi/2 + pi.*rand(M,1);
mu = zeros(M,1);
sigma = zeros(M,1);
phi_test = [sin(x_test) (x_test-10).^2];
y_test = phi_test*w;


%%

for i = 1:M
    for n = 1:N
        k(n) = gaussK(x_test(i),x(n),1);
    end
    mu(i) = y_test(i)-k*(C\y);
    sigma(i) = (gaussK(x_test(i),x_test(i),1) + beta)-k*(C\k');
    plot(mu)
    pause(0.01)
    drawnow
end

%%

x = (1:M)';
y = mu;
dy = sigma;
fill([x;flipud(x)],[y-dy;flipud(y+dy)],[.8 .4 .4],'linestyle','none')
hold on
line(x,y)
hold off