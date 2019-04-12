%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [X, idx, R] = createNewDatasets(I, J, R)
newC = zeros(100,5);
batch = [5, 20, 10, 5, 10];
start = 1;
last = 0;
for i=batch
    last = last + 2 *i;
    [A, B, C, IR] = createDatasetGeneric(I, J, 2*i, R, i);
    newC(start:last, :) = C;
    start = last+1;
end

newA = zeros(size(A));
[v, idx] = max(A, [], 2);
for i=1:size(A,1)
    newA(i,idx(i)) = v(i);
end
newB = newA;
X = sptensor(tensor(ktensor(ones(R,1), newA, newB, newC)));
end