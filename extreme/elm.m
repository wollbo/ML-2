function [O_ensemble,w_ensemble] = elm(xTrain,tTrain)



for m = 1:5
    x = xTrain((m-1)*N+1:m*N,:);
    t = tTrain((m-1)*N+1:m*N,:);
    x = x';
    t = t';
    w = -1 + (2).*rand(neurons(l),P);

    z = w*x+B;
    y = sigmoid2(z);
    O = (y*y'+lambda*I)\(t*y')'; %lambda(l)
    O = O';
    out = O*sigmoid2(w*x+B);
    O_ensemble(:,:,m) = O;
    w_ensemble(:,:,m) = w;
end

