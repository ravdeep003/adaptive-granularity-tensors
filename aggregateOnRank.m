%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [rank, W]= aggregateOnRank(X, approx)
% Input: 3 mode tensor, rank approximation
% Output: W aggregation matrix
approximation = approx;

% if ~isa(X, 'double')
%     X = double(X);
% end
% [I, J, K] = size(X);
sz = size(X);
K = sz(3);
lookup = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
% G = gpuArray(X);
G = X;
% rankGPU = zeros(K, 1, 'gpuArray');
rankGPU = zeros(K, 1);
M = G(:,:,1);
% M = gpuArray(double(M));
M = double(M);
[pRank, ~] = condNumber(M, approximation);
rankGPU(1) = pRank;
% keep tracks of row number for W
rowNum = 1;
i = 1;
j = 2;
while j <= K
     if nnz(G(:,:,j)) == 0
        j = j+ 1;
        if j > K
          lookup(rowNum) = [i, j-1];
        end
        continue
    end
    % sum of slices along the third mode
    M = collapse(G(:,:,i:j), 3);
%     M = gpuArray(double(M));
    M = double(M);
%     M = sum(G(:,:,i:j), 3);
    [cRank, ~] = condNumber(M, approximation);
    if cRank >= pRank
        rankGPU(j-1) = pRank;
        j = j + 1;
        pRank = cRank;
        if j > K
            rankGPU(j-1) = pRank;
            lookup(rowNum) = [i, j-1];
        end
    elseif cRank < pRank
        rankGPU(j-1) = pRank;
        lookup(rowNum) = [i, j-1];
        i = j;
        j = j+1;
        rowNum = rowNum + 1;
        M = G(:,:,i);
%         M = gpuArray(double(M));
        M = double(M);
        [pRank, ~] = condNumber(M, approximation);
        if j > K
            rankGPU(j-1) = pRank;
            lookup(rowNum) = [i, j-1];
        end
    end
end
rank = gather(rankGPU);
W = findW(lookup, K);
clear G X rankGPU;
end