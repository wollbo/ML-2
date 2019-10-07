%% modify ICMevaluate and energy to take greyscale vector

addpath datasets/image
folder = 'datasets/image';
imageMatrix = imread([folder '/lena_std'],'tif');

L = length(imageMatrix);
imageMatrix = rgb2gray(imageMatrix);
N = 256; %8bit
%N = 8;

%%


p = 0.1;
flipM=binornd(1,p*ones([L L]));
flipped = imageMatrix(flipM==1);
flipped = randi(255,length(flipped),1,'uint8');
imageMatrix(flipM==1) = flipped;

% neighborspaghetti from binary

%% ICM-algorithm

% get neighbors
% only edge points need special treatment
for i=1:L-2 % corresponds to pixels on top and bottom from x=2:L-1
    neighborsT(i,:,:) = [1 i; 2 i+1; 1 i+2];
    neighborsB(i,:,:) = [L i; L-1 i+1; L i+2];
end
for j=1:L-2
    neighborsL(j,:,:) = [j 1; j+1 2; j+2 1];
    neighborsR(j,:,:) = [j L; j+1 L-1; j+2 L];
end
neighborsC(1,:,:) = [2 1; 1 2]; %11
neighborsC(2,:,:) = [L-1 1; L 2]; %B1
neighborsC(3,:,:) = [2 L; 1 L-1]; %1H
neighborsC(4,:,:) = [L-1 L; L L-1]; %BH

clear neighbors
for n = 1:L-2
    for m = 1:L-2
        neighbors(n,m,:,:) = [n m+1 ;n+1 m; n+1  m+2; n+2  m+1; n m; n+2 m; n+2 m+2; n m+2]; % add corners
    end
end

% here we go again
neighbors = squeeze(reshape(neighbors, [(L-2)*(L-2) 1 size(neighbors,3) 2])); % needs to maintain structure after evaluation

% ICMevaluate: function for evaluating neighborflip energies, returns flipped
% imageMatrix
borderC = [1 1;L 1; 1 L; L L]; % can be constructed intelligently for border \ corner + middle
borderL = [(2:L-1)' ones(L-2,1)];
borderR = [(2:L-1)' L.*ones(L-2,1)];
borderT = [ones(L-2,1) (2:L-1)'];
borderB = [L.*ones(L-2,1) (2:L-1)'];

inner = [];
for m = 2:L-1
    inner = [inner; (2:L-1)' m*ones(L-2,1)];
end

%% might take too much time with N=256. Then, quantize s.t. we get 8 values uniformly between 1:256
for k = 1:10
% best to do inner loop first 
[neighborMatrix, idx] = indexToNeighbor(imageMatrix,inner,neighbors);
imageMatrix(idx) = ICMevaluate2(neighborMatrix, imageMatrix(idx),N); 
% evaluates energy of corners, and flips accordingly
[neighborMatrixC, idxC] = indexToNeighbor(imageMatrix,borderC,neighborsC);
imageMatrix(idxC) = ICMevaluate2(neighborMatrixC, imageMatrix(idxC),N);
%
[neighborMatrixL, idxL] = indexToNeighbor(imageMatrix,borderL,neighborsL);
imageMatrix(idxL) = ICMevaluate2(neighborMatrixL, imageMatrix(idxL),N);
%
[neighborMatrixR, idxR] = indexToNeighbor(imageMatrix,borderR,neighborsR);
imageMatrix(idxR) = ICMevaluate2(neighborMatrixR, imageMatrix(idxR),N);
%
[neighborMatrixT, idxT] = indexToNeighbor(imageMatrix,borderT,neighborsT);
imageMatrix(idxT) = ICMevaluate2(neighborMatrixT, imageMatrix(idxT),N);
%
[neighborMatrixB, idxB] = indexToNeighbor(imageMatrix,borderB,neighborsB);
imageMatrix(idxB) = ICMevaluate2(neighborMatrixB, imageMatrix(idxB),N);

imshow(imageMatrix)
end


