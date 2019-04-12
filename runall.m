%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

clear all; clc;
% Data path and result path
datasetPath = 'dataset/';
resultPath = 'result';
% parameter to run utility functions
ops.normThreshold = 0.15;
ops.rankApprox = 0.95;
ops.percentMissing = 10;
% This array is used to run the seven utility functions
% Each number corresponding to one utility function
utilityArray = [1 2 3 4 5 6 7];
fixedInterval = [10 100 1000];
utilityLen = length(utilityArray) + length(fixedInterval);
% Number of runs for a single data.
% It will generate equivalent number of result '.mat' files.
% For demo purposes, we use runs = 1. 
runs = 1;
% runs = 10;
% load the data file
a = load(datasetPath);
% Given tensor
X = a.X;
% Number of ground truth communities
K = a.K;
% Ground Truth Communities
C = a.C;

for z=1:runs
    count = 1;
    resultFile = sprintf('%s/demoResult_%d.mat',resultPath, z);
        
    Ws = cell(utilityLen, 1);
    Ranks = zeros(utilityLen, 1);
    Cors = zeros(utilityLen, 1);
    nmiScores = zeros(utilityLen, 1);
    elapsedTs = zeros(utilityLen, 1);
    
    for j=utilityArray
        [W, R, Cor, nmiScore, elapsedTime] = runUtilityFunction(X, K, C, ops, j);
        Ws{count} = W;
        Ranks(count) = R;
        Cors(count) = Cor;
        nmiScores(count) = nmiScore;
        elapsedTs(count) = elapsedTime;
        count = count + 1;
    end
    for l=fixedInterval
         Y = aggregateOnFixedInterval(X, l);
         % Rank and Corcondia
         [R, Cor] = getRnC(Y, K);
         % NMI Score
         M = runCPALS(Y, R);
         predicted = runKmeans(M.U{1}, K);
         nmiScore = nmi(predicted, C);
         Ws{count} = 0;
         Ranks(count) = R;
         Cors(count) = Cor;
         nmiScores(count) = nmiScore;
         elapsedTs(count) = elapsedTime;
         count = count + 1;
    end
    save(resultFile, 'Ws', 'Ranks', 'Cors', 'elapsedTs', 'nmiScores');
    clear Ws Ranks Cors elapsedTs nmiScores M 
end



