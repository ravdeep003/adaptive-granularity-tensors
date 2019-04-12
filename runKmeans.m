%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside
function result = runKmeans(A, k)
iter = 10;
results = cell(iter,1);
sse = zeros(iter,1);
for i=1:iter
    [results{i}, ~, sumd] = kmeans(A, k);
    sse(i) = sum(sumd.^2);
end
[~, index] = min(sse);
result = results{index};

end