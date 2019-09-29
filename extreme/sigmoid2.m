function [activation, derivative] = sigmoid2(x)
%Sigmoid2 activation funciton used in lab
activation = 2./(1+exp(-x))-1;
derivative = (1+activation).*(1-activation)/2;
end

