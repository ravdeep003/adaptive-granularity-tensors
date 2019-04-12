%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function G = createBipartiteGraph(A)
% Input: matrix
% Output: bipartite Graph
[m, n] = size(A);
% symmetric (M+N)x(M+N) matrix
B = [zeros(m,m), A;
     A', zeros(n,n)];
G = graph(B);
end