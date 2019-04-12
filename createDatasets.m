%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [X, idx, R] = createDatasets(I, J, K, R, batch)
[A, B, C, IR] = createDatasetGeneric(I, J, K, R, batch);
newA = zeros(size(A));
[v, idx] = max(A, [], 2);
for i=1:size(A,1)
    newA(i,idx(i)) = v(i);
end
newB = newA;
X = sptensor(tensor(ktensor(ones(R,1), newA, newB, C)));
end