% *** multi-robot assignment problem ***

global N R range

% the number of demands
N = 3; 

% the number of robots 
R = 8; 

%calculate the efficiency each-demand-each-robot 
%which is also the mean, the lambda of the Poisson distribution

efficiency = zeros(N, R); 
range = 20; 
for i = 1 : N
    for j = 1 : R
        efficiency(i, j) = range* rand(1); 
    end
end

%sampling time 
n_s = 500; 

%user-defined confidence level
%note that this guy can be cahnged later
alpha = 0.05; 

%the separation for tau
delta = 0.1; 

% cvar_greedy_approach
[cvar_gre_set, cvar_gre_hvalue, cvar_gre_uncertain] = CVaR_greedy(efficiency, alpha, delta, n_s);

% plot the uncertainty w.r.t. different value of alpha. 
