%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [rank, cn] = condNumber(A, Approximation)
% Input: Matrix, rank approximation
% Output: rank and condition number corresponding to the approximation 
% B = gpuArray(A);
S = svd(A);
first = S(1);
n = length(S);
denominator = sum(S);
total = 0;
for i=1:n
    total =  total + S(i);
    if total/denominator >= Approximation
        cn = first/S(i);
        rank = i;
        break;
    end
end
% disp(rank);
end