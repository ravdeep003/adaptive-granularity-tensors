%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function Fac = matrixFactorizationSGD(A, R)
% Input: Matrix A and rank R
% Output: Factor matrices.
iters = 300;
alpha = 0.001;
lambda = 0.001;
tol = 1e-2;

[m,n] = size(A);
% [Inan, Jnan] = find(isnan(A));
[I, J] = find(A>0);
[Iz, Jz] = find(A == 0);
l = length(I);
nz = length(Iz);
perm = randperm(nz);
I = [I Iz(perm(1:l))];
J = [J Jz(perm(1:l))];

newN = length(I);

U = rand(m, R);
V = rand(R, n);
% [U, S, V] = svd(A);
% U = U(:,1:R) * S(1:R, 1:R);
% V = V(:,1:R)';
disp('start');disp(calRmse(A, U, V, I, J));
% Total number of non-missing value in A

delta = zeros(iters,1);
for j=1:iters
    perm = randperm(newN);
    previous = calRmse(A, U, V, I, J);
    for i=perm
        r = U(I(i), :)*V(:,J(i));
        val = A(I(i), J(i));
        deltaU = -2 * V(:,J(i))' * (val - r ) + 2*lambda*U(I(i),:);
    %     deltaU = -2 * V(:,J(i))' * (val - r ) ;
    %     deltaV = -2 * U(I(i),:)' * (val - r);
        deltaV = -2 * U(I(i),:)' * (val - r) + 2*lambda*V(:,J(i));
        U(I(i),:) = U(I(i),:) - alpha * deltaU;
        V(:,J(i)) = V(:,J(i)) - alpha * deltaV;
    end
    if mod(i, 500) == 0
        alpha = alpha/10;
    end
    current = calRmse(A, U, V, I, J);
    delta(j) = abs(current-previous);
    if delta(j) < tol
        break;
    end

end
disp('end');disp(delta(j));
Fac{1} = U;
Fac{2} = V';
end

function rmse = calRmse(A, U,V, I, J)
% [I, J] = find();
n = length(I);
total = 0;
for i=1:n
    total = total + (A(I(i), J(i)) -  U(I(i), :)*V(:,J(i)))^2;
end
rmse = sqrt(total/n);
end