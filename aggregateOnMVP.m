%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function W = aggregateOnMVP(X, percentMissing, rankApprox)
% Input: 3 mode tensor, percent of non zero missing for MF-SGD and
% reconstruction rank
% Output: W aggregation matrix

p = percentMissing/100;
% [I, J, K] = size(X);
sz = size(X);
K = sz(3);
lookup = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
i = 1;
j = 2;
rowNum = 1;
flag = false;
if nnz(X(:,:,i)) < percentMissing
    j = j + 1;
    while nnz(collapse(X(:,:,i:j-1),3)) < percentMissing
        j = j+1;
    end
    M = collapse(X(:,:,i:j-1),3);
    M = double(M);
else
    M = double(X(:,:,i));
end
% [~, pRmse] = evaluateMissingValue(M, p, rankApprox);
[~, pRmse] = evaluateMissingValueSGD(M, p, rankApprox);
% try
while j <= K
    if nnz(X(:,:,j)) == 0
        j = j+ 1;
        if j > K
            lookup(rowNum) = [i, j-1];
        end
        continue
    end
    M = collapse(X(:,:,i:j),3);
    M = double(M);
%     [~, cRmse] = evaluateMissingValue(M, p, rankApprox);
    [~, cRmse] = evaluateMissingValueSGD(M, p, rankApprox);
    if pRmse < cRmse
        lookup(rowNum) = [i, j-1];
        i = j;
        j = j+1;
        rowNum = rowNum + 1;
        % To deal with edge case if every slice has only one nnz value
        if nnz(X(:,:,i)) < percentMissing
            j = j + 1;
            while nnz(collapse(X(:,:,i:j-1),3)) < percentMissing
                j = j+1;
                if j > K
                    j = K+1;
                    lookup(rowNum) = [i, j-1];
                    flag = true;
                    break;
                end
            end
            if flag
                break;
            end
            M = collapse(X(:,:,i:j-1),3);
            M = double(M);
        else
            M = double(X(:,:,i));
        end

%         M = collapse(X(:,:,i:j-1),3);
%         M = double(M);
%         [~, pRmse] = evaluateMissingValue(M, p, rankApprox);
         [~, pRmse] = evaluateMissingValueSGD(M, p, rankApprox);
    elseif pRmse >= cRmse
        j = j +1;
        pRmse = cRmse;
    end
    if j > K
        lookup(rowNum) = [i, j-1];
    end
    fprintf('I am here: %d', j);
end
% catch
%     disp(i);disp(j);
% end
W = findW(lookup, K);

end