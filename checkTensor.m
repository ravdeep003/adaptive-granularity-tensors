%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function Y = checkTensor(X)
% Input: 3 mode tensor
% Output: 3 mode tensor without any zero slices
K = size(X,3);
count = 1;
Y = sptensor;
for i=1:K
    if nnz(X(:,:,i)) ~= 0
        Y(:,:, count) = X(:,:,i);
        count = count + 1;
    end
end
disp(count - 1);
end

