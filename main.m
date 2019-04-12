%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2019
%Computer Science and Engineering, University of California, Riverside

clear all;close all;clc

A1 = [1 0 0 1; 0 1 0 0 ; 0 1 1 0; 1 1 0 0 ; 0 1 1 1; 0 1 1 1];
A2 = [1 0 0 0; 1 1 0 0 ; 0 1 0 0 ; 1 0 0 0; 1 0 0 0; 1 0 0 0];

k = 2;

[p1,h1] = component_distribution(A1,k)
[p2,h2] = component_distribution(A2,k)
figure
subplot(2,1,1);bar(p1);title(sprintf('Entropy: %.4f',h1))
subplot(2,1,2);bar(p2);title(sprintf('Entropy: %.4f',h2))