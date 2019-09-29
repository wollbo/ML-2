%% construct binary image
% philosophical reasoning: shouldn't use trueMatrix to estimate imageMatrix
clear all
y = [1 1 0]'; % corresponds to 2
b = [0 0.3 1]'; % corresponds to 1
colours = [b y];

%create image tensor
M = 5; % base pixel unit
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

p = 0.1;
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
for i=1:B-2 % corresponds to pixels on top and bottom from x=2:B-1
    neighborsT(i,:,:) = [i 1; i+1 2; i+2 1];
    neighborsB(i,:,:) = [i B; i+1 B-1; i+2 B];
end
for j=1:H-2
    neighborsL(j,:,:) = [1 j; 2 j+1; 1 j+2];
    neighborsR(j,:,:) = [H j; H-1 j+1; H j+2];
end
neighborsC(1,:,:) = [2 1; 1 2]; %11
neighborsC(2,:,:) = [H-1 1; H 2]; %B1
neighborsC(3,:,:) = [2 B; 1 B-1]; %1H
neighborsC(4,:,:) = [H-1 B; H B-1]; %BH

for n = 1:H-2
    for m = 1:B-2
        neighbors(n,m,:,:) = [n+1 m ;n m+1; n+1  m+2; n+2  m+1];
    end
end

% here we go again
neighbors = squeeze(reshape(neighbors, [(B-2)*(H-2) 1 4 2])); % needs to maintain structure after evaluation

%%

% ICMevaluate: function for evaluating neighborflip energies, returns flipped
% imageMatrix
C = [1 1;H 1; 1 B; H B]; % can be constructed intelligently for border \ corner + middle
idxC = sub2ind(size(imageMatrix), C(:,1), C(:,2));
imageMatrix(idxC); % �ber haxx god
for j = 1:size(neighborsC, 2)
    idx2 = sub2ind(size(imageMatrix), neighborsC(:,j,1), neighborsC(:,j,2));
    neighborMatrixC(:,j) = imageMatrix(idx2);
end
imageMatrix(idxC) = ICMevaluate(neighborMatrixC, trueMatrix(idxC), imageMatrix(idxC)); % evaluates energy of corners, and flips accordingly

borderL = [(2:H-1)' ones(H-2,1)];
borderR = [(2:H-1)' B.*ones(H-2,1)];
borderT = [ones(B-2,1) (2:B-1)'];
borderB = [H.*ones(B-2,1) (2:B-1)'];

%%
idxL = sub2ind(size(imageMatrix), borderL(:,1), borderL(:,2));
for j = 1:size(neighborsL, 2)
    idx2 = sub2ind(size(imageMatrix), neighborsL(:,j,1), neighborsL(:,j,2));
    neighborMatrixL(:,j) = imageMatrix(idx2);
end
imageMatrix(idxL) = ICMevaluate(neighborMatrixL, trueMatrix(idxL), imageMatrix(idxL));

%%
inner = [];
for n = 1+1:H-1
    inner = [inner; n*ones(B-2,1) (2:B-1)'];
end

idx = sub2ind(size(imageMatrix), inner(:,1), inner(:,2));
for j = 1:size(neighbors, 2) 
    idx2 = sub2ind(size(imageMatrix), neighbors(:,j,1), neighbors(:,j,2)); 
    neighborMatrix(:,j) = imageMatrix(idx2);
end
imageMatrix(idx) = ICMevaluate(neighborMatrix, trueMatrix(idx), imageMatrix(idx));

%%
for i = 1:H
    for j = 1:B
        flame(i,j,:) = colours(:,imageMatrix(i,j));
    end
end
image(flame)