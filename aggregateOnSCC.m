%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [connComp, W]  = aggregateOnSCC(X)
% Input: 3 mode tensor
% Output: Connected components at each index and W aggregation matrix

% [I, J, K] = size(X);
numberOfNodes = 2;
sz = size(X);
K = sz(3);
lookup = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
connComp = zeros(K, 1);
M = X(:,:,1);
M = double(M);
pG = digraph(M);
bins = conncomp(pG);
counter = hist(bins, unique(bins));
previousComp = length(counter(counter>numberOfNodes));
connComp(1) = previousComp;
rowNum = 1;
i = 1;
j = 2;
while j<=K
    if nnz(X(:,:,j)) == 0
        j = j+ 1;
        if j > K
            lookup(rowNum) = [i, j-1];
            connComp(j-1) = previousComp;
        end
        continue
    end
%     M = sum(X(:,:,i:j), 3);
    M = collapse(X(:,:,i:j), 3);
    M = double(M);
    cG = digraph(M);
    bins = conncomp(cG);
    counter = hist(bins, unique(bins));
    currentComp = length(counter(counter>numberOfNodes));
%     delta = (currentComp - previousComp)/previousComp;
    if currentComp == previousComp
        connComp(j-1) = currentComp;
        j = j + 1;
        previousComp = currentComp;
        if j > K
            lookup(rowNum) = [i, j-1];
            connComp(j-1) = currentComp;
        end
    elseif currentComp > previousComp
        connComp(j-1) = currentComp;
        lookup(rowNum) = [i, j-1];
        i = j;
        j = j+1;
        rowNum = rowNum + 1;
        M = X(:,:,i);
        M = double(M);
        pG = digraph(M);
        bins = conncomp(pG);
        counter = hist(bins, unique(bins));
        previousComp = length(counter(counter>numberOfNodes));
        if j > K
            lookup(rowNum) = [i, j-1];
            connComp(j-1) = currentComp;
        end
    elseif previousComp > currentComp
        disp('Something is fishy!!!');
    end

end

W = findW(lookup, K);
end

