%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function[W, R, Cor, nmiScore, elapsedTime] = runUtilityFunction(X, K, groundTruth, ops, utilityType)
% parsing parameters and setting default values
if ~isfield(ops, 'normThreshold')
    normThreshold = 0.15;
else
    normThreshold = ops.normThreshold;
end

if ~isfield(ops, 'rankApprox')
    rankApprox = 0.95;
else
    rankApprox = ops.rankApprox;
end
if ~isfield(ops, 'percentMissing')
    percentMissing = 10;
else
    percentMissing = ops.percentMissing;
end

% run particular utility function 
% Frobenius Norm    % 2-Norm            % Inf Norm
if utilityType == 1 || utilityType == 2 || utilityType == 3
    tic;
    [~, W] = aggregateOnNorm(X, normThreshold, utilityType);
    elapsedTime = toc;
end

% aggregation on rank
if utilityType == 4
    tic;
    [~, W] = aggregateOnRank(X, rankApprox);
    elapsedTime = toc;
end

% missing value prediciton 
if utilityType == 5
    tic;
    W = aggregateOnMVP(X, percentMissing, rankApprox);
    elapsedTime = toc;
end

% graph properties - Aggregate on degree
if utilityType == 6 
    tic;
    W = aggregateOnDegree(X, normThreshold);
    elapsedTime = toc;
end

% Aggregate on Connected Components
if utilityType == 7
    tic;
    [~, W]  = aggregateOnSCC(X);
    elapsedTime = toc;
end
% Aggregated Tensor
Y = ttm(X, W, 3);
% Rank and Corcondia
[R, Cor] = getRnC(Y, K);
% NMI Score
M = runCPALS(Y, R);
predicted = runKmeans(M.U{1}, K);
nmiScore = nmi(predicted, groundTruth);
end