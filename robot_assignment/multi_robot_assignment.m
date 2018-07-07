% *** multi-robot assignment problem ***

global N R range

% the number of demands
N = 4; 

% the number of robots 
R = 10; 

%calculate the efficiency each-demand-each-robot 
%which is also the mean, the lambda of the Poisson distribution

efficiency = zeros(N, R); 
range = 10; 
for i = 1 : N
    for j = 1 : R
        efficiency(i, j) = range * rand(1); 
    end
end
%sampling time 
n_s = 1000; 
%robot_demand_sample = robot_demand_poisson(efficiency, n_s); 
%one_demand_bound = round(max(robot_demand_sample(:))); 
%%

%the separation for tau
delta = 1;

%user-defined confidence level
%note that this guy can be cahnged later
%alpha = 0.05; 

% define CVaR_set_dis
cvar_gre_dis_store ={};
cvar_gre_set_store = {}; 
cvar_gre_h_store = []; 
cvar_gre_hb_store = [];

cnt_alpha = 1; 
for alpha = 0.05 : 0.3 : 1
% cvar_greedy_approach
[cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, max_hstar_bound] = ...
    CVaR_greedy(efficiency, alpha, delta, n_s, one_demand_bound);

cvar_gre_h_store(cnt_alpha, :) = [alpha, cvar_gre_hvalue];
cvar_gre_hb_store(cnt_alpha, :) = [alpha, max_hstar_bound]; 
cvar_gre_dis_store{cnt_alpha} = cvar_gre_dis;
cvar_gre_set_store{cnt_alpha} = cvar_gre_set; 

cnt_alpha = cnt_alpha + 1; 
end

%hvalue and its bound plot
figure (1)
plot(cvar_gre_h_store(:,1), cvar_gre_h_store(:,2), 'r*'), hold on 
plot(cvar_gre_hb_store(:,1), cvar_gre_hb_store(:,2), 'bo')
%distribution plot
%figure (2)
nhist(cvar_gre_dis_store, 'legend', {'alpha=0.05', 'alpha=0.35', 'alpha=0.65', 'alpha=0.95'})
% %expectation plot
% figure (3)
% %real case illustration
% figure (4)