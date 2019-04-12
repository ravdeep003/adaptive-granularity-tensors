%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [Z, n] = createNNZTensor(X)
% Input: 3 mode tensor
% Output: 3 mode tensor with every non zero value a slice and nnz
sz = size(X);
n = nnz(X);
sz(3) = n;
idxs = X.subs;
idxs(:,3) = 1:n;
Z = sptensor(idxs, 1, sz);
end