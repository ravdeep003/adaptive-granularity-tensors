%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [normVals, W]= aggregateOnNorm(X, threshold, type)
% Input: 3 mode tensor, threshold for aggregation, type of matirx norm
% Different matrix norm supported: 1. Frobenius 2. 2-Norm 3.Infinity
% Output: Norm Vals at each index after aggregation and W aggregation

if type == 1
    normType = 'fro';
elseif type == 2
    normType = 2;
elseif type == 3
    normType = 'inf';
end
% if ~isa(X, 'double')
%     X = double(X);
% end
% To handle float operations
floatThreshold = 10^-6;
sz = size(X);
K = sz(3);
lookup = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
% G = gpuArray(X);
G = X;
% normValGPU = zeros(K, 1, 'gpuArray');
normValGPU = zeros(K, 1);
M = G(:,:,1);
% M = gpuArray(double(M));
M = double(M);
previousNorm = norm(M, normType);
normValGPU(1) = previousNorm;
% keep tracks of row number for W
rowNum = 1;
i = 1;
j = 2;
while j <= K
%     if mod(j, 100) == 0
%         disp(j);
%     end
    if nnz(G(:,:,j)) == 0
        j = j+ 1;
        if j > K
          lookup(rowNum) = [i, j-1];
          normValGPU(j-1) = previousNorm;
        end
        continue
    end
    % sum of slices along the third mode
    M = collapse(G(:,:,i:j), 3);
%     M = gpuArray(double(M));
    M = double(M);
    current = norm(M, normType);
    % Percentage change
    delta = (current - previousNorm)/previousNorm;
    % if change is smaller than threshold,
    % then new slice is not adding any significant information
    if abs(delta) < floatThreshold
        delta = 0;
    end
    if delta < 0
        disp('something is fishy!!!');
        disp(delta);
    end

    if delta ~= 0 && delta < threshold
        normValGPU(j-1) = previousNorm;
        lookup(rowNum) = [i, j-1];
        i = j;
        j = i+1;
        M = G(:,:,i);
%         M = gpuArray(double(M));
        M = double(M);
        previousNorm = norm(M, normType);
        rowNum = rowNum + 1;
        if j > K
            lookup(rowNum) = [i, j-1];
            normValGPU(j-1) = previousNorm;
        end
    else
        normValGPU(j-1) = previousNorm;
        previousNorm = current;
        j = j + 1;
        if j > K
            lookup(rowNum) = [i, j-1];
            normValGPU(j-1) = previousNorm;
        end
    end
end
normVals = gather(normValGPU);
W = findW(lookup, K);
clear G X normValGPU;
%gpuDevice(1);
end