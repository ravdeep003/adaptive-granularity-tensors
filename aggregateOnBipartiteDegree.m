%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function W = aggregateOnBipartiteDegree(X, threshold)
% Input: 3 mode tensor, threshold for aggregation
% Output: W aggregation matrix


% To handle float operations
floatThreshold = 10^-6;
 
% [I, J, K] = size(X);
sz = size(X);
K = sz(3); 
lookup = containers.Map('KeyType', 'uint32', 'ValueType', 'any');

M = X(:,:,1);
M = double(M);
pG = createBipartiteGraph(M);
previousDegree = mean(pG.degree);
rowNum = 1;
i = 1;
j = 2;
while j<=K
    if nnz(X(:,:,j)) == 0
        j = j+ 1;
        if j > K
          lookup(rowNum) = [i, j-1];
        end
        continue
    end
%     M = sum(X(:,:,i:j), 3);
    M = collapse(X(:,:,i:j), 3);
    M = double(M);
    cG = createBipartiteGraph(M);
    currentDegree = mean(cG.degree);
    delta = (currentDegree - previousDegree)/previousDegree;
  
    if abs(delta) < floatThreshold
        delta = 0;
    end
     if delta < 0
        disp('something is fishy!!!');
        disp(delta);
    end
    % if change is smaller than threshold,
    % then new slice is not adding any significant information
    if delta ~= 0 && delta < threshold 
        lookup(rowNum) = [i, j-1];
        i = j;
        j = i+1;
        M = X(:,:,i);
        M = double(M);
        pG = createBipartiteGraph(M);
        previousDegree = mean(pG.degree);
        rowNum = rowNum + 1;
        if j > K
            lookup(rowNum) = [i, j-1];
        end
    else 
        previousDegree = currentDegree;
        j = j + 1;
        if j > K
            lookup(rowNum) = [i, j-1];
          
        end
    end
end

W = findW(lookup, K);
end