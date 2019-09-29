%% construct binary image
clear all
y = [1 1 0]'; % corresponds to 2
b = [0 0.3 1]'; % corresponds to 1
colours = [b y];

%create image tensor
M = 100; % base pixel unit
B = 16*M;
H = 10*M;

imageMatrix = zeros([H B 1]);
for i = 1:H
    for j = 1:B
        imageMatrix(i,j,:) = 1;
    end
    for j = 5*M:7*M
        imageMatrix(i,j,:) = 2;
    end
end
 for i = 4*M+1:6*M-1
     for j = 1:B
         imageMatrix(i,j,:) = 2;
     end
 end
% note: imageMatrix and the flame matrix that is plotted is kept separate
% to simplify implementation
flame = zeros([H B 3]);
for i = 1:H
    for j = 1:B
        flame(i,j,:) = colours(:,imageMatrix(i,j));
    end
end

trueMatrix = imageMatrix; % corresponding to X

%% random bit flip matrix

p = 0.05;
flipM=binornd(1,p*ones([H B]));
%imageMatrix(flipM==1 && imageMatrix==b) = y; 'compact, abstract formulation'
%imageMatrix(flipM==1 && imageMatrix==y) = b; 
for i = 1:H
    for j = 1:B
        if flipM(i,j) == 1
            if (imageMatrix(i,j) == 1) % imageMatrix(i,j,:) == b concise but not possible
                imageMatrix(i,j,:) = 2;
            else
                imageMatrix(i,j,:) = 1;
            end
        end
    end
end
% imageMatrix now corresponds to noisy measurement Y = X + E

for i = 1:H
    for j = 1:B
        flame(i,j,:) = colours(:,imageMatrix(i,j));
    end
end
image(flame)
%% ICM-algorithm

% get neighbors
% only edge points need special treatment
for i=1+1:B-1
    neighboursT(i,:,:) = [i-1 1; i 2; i+1 1];
    neighboursB(i,:,:) = [i-1 H; i H-1; i+1 H];
end
for j=1+1:H-1
    neighborsL(j,:,:) = [1 j-1; 2 j; 1 j+1];
    neighborsR(j,:,:) = [B j-1; B-1 j; B j+1];
end
neighborsC(1,:,:) = [2 1; 1 2]; %11
neighborsC(2,:,:) = [B-1 1; B 2]; %B1
neighborsC(3,:,:) = [2 H; 1 H-1]; %1H
neighborsC(4,:,:) = [B-1 H; B H-1]; %BH

for n = 1+1:H-1
    for m = 1+1:B-1
        neighbors(n,m,:,:) = [m-1 n; m n-1; m+1 n; m n+1];
    end
end


%%




