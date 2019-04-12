%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [F, cor]=getRnC(X, R)
    % Input: Tensor X and estimated rank R.
    % Output: Low rank of the tensor and corresponding corcondia score.
    n = 10;
    maxRank = 2 * R;
    allRank = zeros(n,1);
    allCor = zeros(n,1);
    parfor i=1:n
        [Fac ,c ,K] = AutoTen(X, maxRank, 1);
        allRank(i,1) = K;
        allCor(i,1) = c;
    end
    F = mode(allRank(:,1));
    inds = allRank(:,1)==F;
%     allCor = allRank(:,2);
    cor = max(allCor(inds));

end