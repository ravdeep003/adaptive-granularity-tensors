%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [allRmse, rmse] = evaluateMissingValueSGD(A, P, rankApprox)
% Input: matrix A, percent value matrix factorization tries to predict, 
% rank approximation 
% Output: Rmse of all the iterations and mean of the Rmse
maxIters = 5;
allRmse = zeros(maxIters, 1);
% Options(5) = NaN;
[r, ~] = condNumber(A, rankApprox);
idx = find(A~=0);
n = ceil(P * length(idx));
if n == 0 || n >= length(idx)
    fprintf('Value of n doesnot meet the condition: %d', n);
    return
end
for i=1:maxIters
    missVal = datasample(idx, n);
    X = A;
    X(missVal) = NaN;
    Fac = matrixFactorizationSGD(X, r);
    Y = Fac{1} * Fac{2}';
    allRmse(i,1) = sqrt(mean((Y(missVal) - A(missVal)).^2));
end
%disp(allRmse)
rmse = mean(allRmse);
end