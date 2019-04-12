%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

function [p,h] = component_distribution(A,k)
%Inputs: 1) A: the factor matrix , 2) k: the number of top elements of the
%rows in A per component
%Outputs: 1) p: the normalized empirical propability distribution of
%elements of rows of A, 2) h: the entropy of that distribution
top_per_component = zeros(size(A,2),k);
%get top-k per component
for i = 1:size(A,2)
   a = A(:,i);
   [~,idx] = sort(a,'descend');
   top_per_component(i,:) = idx(1:k);
end

component_count = zeros(size(A,1),1);
for i = 1:length(component_count)
   component_count(i) = sum(top_per_component(:) == i);
end
p = component_count;p = p /sum(p);
pnew = p; pnew(pnew==0) = [];
h = -sum(pnew.*log2(pnew));
end
