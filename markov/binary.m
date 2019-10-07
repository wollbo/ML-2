%% construct binary image
% error in neighborMatrix construction. remember how indexing relates to
% dimensions!!
%clear all
y = [1 1 0]'; % corresponds to 2
b = [0 0.3 1]'; % corresponds to 1
colours = [b y];

%create image tensor
M = 10; % base pixel unit
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
image(flame);
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
    neighborsT(i,:,:) = [1 i; 2 i+1; 1 i+2];
    neighborsB(i,:,:) = [H i; H-1 i+1; H i+2];
end
for j=1:H-2
    neighborsL(j,:,:) = [j 1; j+1 2; j+2 1];
    neighborsR(j,:,:) = [j H; j+1 H-1; j+2 H];
end
neighborsC(1,:,:) = [2 1; 1 2]; %11
neighborsC(2,:,:) = [H-1 1; H 2]; %B1
neighborsC(3,:,:) = [2 B; 1 B-1]; %1H
neighborsC(4,:,:) = [H-1 B; H B-1]; %BH

clear neighbors
for n = 1:H-2
    for m = 1:B-2
        neighbors(n,m,:,:) = [n m+1 ;n+1 m; n+1  m+2; n+2  m+1; n m; n+2 m; n+2 m+2; n m+2]; % add corners
    end
end

% here we go again
neighbors = squeeze(reshape(neighbors, [(B-2)*(H-2) 1 size(neighbors,3) 2])); % needs to maintain structure after evaluation


% ICMevaluate: function for evaluating neighborflip energies, returns flipped
% imageMatrix
borderC = [1 1;H 1; 1 B; H B]; % can be constructed intelligently for border \ corner + middle
borderL = [(2:H-1)' ones(H-2,1)];
borderR = [(2:H-1)' B.*ones(H-2,1)];
borderT = [ones(B-2,1) (2:B-1)'];
borderB = [H.*ones(B-2,1) (2:B-1)'];
inner = [];
for m = 2:B-1
    inner = [inner; (2:H-1)' m*ones(H-2,1)];
end

%%
for k = 1:10
% best to do inner loop first since
[neighborMatrix, idx] = indexToNeighbor(imageMatrix,inner,neighbors);
imageMatrix(idx) = ICMevaluate(neighborMatrix, imageMatrix(idx));
    
% evaluates energy of corners, and flips accordingly
[neighborMatrixC, idxC] = indexToNeighbor(imageMatrix,borderC,neighborsC);
imageMatrix(idxC) = ICMevaluate(neighborMatrixC, imageMatrix(idxC));

%
[neighborMatrixL, idxL] = indexToNeighbor(imageMatrix,borderL,neighborsL);
imageMatrix(idxL) = ICMevaluate(neighborMatrixL, imageMatrix(idxL));
%
[neighborMatrixR, idxR] = indexToNeighbor(imageMatrix,borderR,neighborsR);
imageMatrix(idxR) = ICMevaluate(neighborMatrixR, imageMatrix(idxR));

%
[neighborMatrixT, idxT] = indexToNeighbor(imageMatrix,borderT,neighborsT);
imageMatrix(idxT) = ICMevaluate(neighborMatrixT, imageMatrix(idxT));

end
% idx = sub2ind(size(imageMatrix), inner(:,1), inner(:,2));
% for j = 1:size(neighbors, 2) 
%     idx2 = sub2ind(size(imageMatrix), neighbors(:,j,1), neighbors(:,j,2)); 
%     neighborMatrix(:,j) = imageMatrix(idx2);
% end
% imageMatrix(idx) = ICMevaluate(neighborMatrix, imageMatrix(idx));


%%
for i = 1:H
    for j = 1:B
        flame(i,j,:) = colours(:,imageMatrix(i,j));
    end
end
image(flame)

%%

% idxC = sub2ind(size(imageMatrix), C(:,1), C(:,2));
% imageMatrix(idxC);
% for j = 1:size(neighborsC, 2)
%     idx2 = sub2ind(size(imageMatrix), neighborsC(:,j,1), neighborsC(:,j,2));
%     neighborMatrixC(:,j) = imageMatrix(idx2);
% end
% imageMatrix(idxC) = ICMevaluate(neighborMatrixC, imageMatrix(idxC)); 