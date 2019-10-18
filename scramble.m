function [data, labels, testData, testLabels] = scramble(data,labels,M)

L = length(data);
indexL = randperm(L,L-M);
indexM = 1:L;
indexM(indexL) = [];

testData = data(indexM,:);
testLabels = labels(indexM,:);
data = data(indexL,:);
labels = labels(indexL,:);

end

