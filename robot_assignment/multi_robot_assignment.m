% *** multi-robot assignment problem ***
global N R 

% the number of demands
N = 5; 

% the number of robots 
R = 7; 

%calculate the efficiency each-demand-each-robot 
%which is also the mean, the lambda of the Poisson distribution

% %%%%
% robots = rand(R,2);
% demands = rand(N,2);
% 
% % robots = [.4, 0; 0.6, 0];
% % demands = [0,0; 1,0];
% 
% efficiency = zeros(N, R); 
% for i = 1 : N
%     for j = 1 : R
%         efficiency(i, j) = 1/norm(robots(j,:)-demands(i,:));
%     end
% end
%%%%
% 
efficiency = zeros(N, R); 

for i = 1 : N
    for j = 1 : R
        efficiency(i, j) = 15 * rand(1) +  15*(i-1); 
    end
end

%sampling times
n_s = 1000; 

robot_demand_sample = robot_demand_poisson(efficiency, n_s); 
one_demand_bound = round(max(robot_demand_sample(:)));

% %the separation for tau
% alpha = 0.7; 
% 
% %%% calculate the h function value for each tau
% h1 = [];
% h2 = [];
% for tau = 0: delta: N * one_demand_bound
%     h1_tmp = tau - 1/alpha * mean(max(tau*ones(1,n_s) - robot_demand_sample(:,:,1,1), zeros(1, n_s)));
%     h1 = [h1, h1_tmp];
%     h2_tmp = tau - 1/alpha * mean(max(tau*ones(1,n_s) - robot_demand_sample(:,:,2,1), zeros(1, n_s)));
%     h2 = [h2, h2_tmp];
% end
% %%%
% plot(h1, 'r*'), hold on 
% plot(h2, 'bo')
%%

%user-defined confidence level
%note that this guy can be cahnged later
%alpha = 0.05; 
delta = 1;

% define CVaR_set_dis
cvar_gre_dis_store ={};
cvar_gre_set_store = {}; 
cvar_gre_h_store = []; 
cvar_gre_tauh_store ={};
cvar_gre_hset_store = {};
cvar_gre_hbmax_store = [];
cvar_gre_hb_store ={};

cnt_alpha = 1; 

for alpha = 0.01 : 0.2 : 1
% cvar_greedy_approach, using compact vector for samples
[cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, tau_hvalue, H_star_value, H_set, max_hstar_bound] = ...
    CVaR_greedy_matching(robot_demand_sample, alpha, delta, n_s, one_demand_bound);

% % cvar_greedy_approach, using individual samples
% [cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, max_hstar_bound] = ...
%     CVaR_greedy_sample(efficiency, alpha, delta, n_s);

cvar_gre_h_store(cnt_alpha, :) = [alpha, cvar_gre_hvalue];
cvar_gre_hbmax_store(cnt_alpha, :) = [alpha, max_hstar_bound]; 
cvar_gre_dis_store{cnt_alpha} = cvar_gre_dis;
cvar_gre_set_store{cnt_alpha} = cvar_gre_set; 
cvar_gre_tauh_store{cnt_alpha} = tau_hvalue; 
cvar_gre_hset_store{cnt_alpha} = H_set;
cvar_gre_hb_store{cnt_alpha} = H_star_value; 

cnt_alpha = cnt_alpha + 1; 
end

%hvalue and its bound plot
figure (1)
plot(cvar_gre_h_store(:,1), cvar_gre_h_store(:,2), 'r*'), hold on 
plot(cvar_gre_hbmax_store(:,1), cvar_gre_hbmax_store(:,2), 'bo'), hold on

%distribution plot
figure (2)
nhist(cvar_gre_dis_store, 'legend', {'alpha=0.001', 'alpha=0.35', 'alpha=0.65', 'alpha=0.95'})
% %expectation plot
% figure (3)
% %real case illustration
% figure (4)