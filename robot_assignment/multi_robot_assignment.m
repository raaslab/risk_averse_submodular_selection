% *** multi-robot assignment problem ***
global N R 

% the number of demands
N = 4; 

% the number of robots 
R = 6; 

%calculate the efficiency each-demand-each-robot 
%which is also the mean, the lambda of the Poisson distribution

% %%%%
robots = 10*rand(R,2);
demands = 10*rand(N,2);
% 
% % robots = [.4, 0; 0.6, 0];
% % demands = [0,0; 1,0];
% 
efficiency = zeros(N, R); 
for i = 1 : N
    for j = 1 : R
        efficiency(i, j) = 10/norm(robots(j,:)-demands(i,:));
    end
end
%%%%
% 
% efficiency = zeros(N, R); 
% 
% for i = 1 : N
%     for j = 1 : R
%         efficiency(i, j) = 10 * rand(1) +  40*(i-1); 
%     end
% end

%sampling times
n_s = 10000; 

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
delta = N;

% define CVaR_set_dis
cvar_gre_dis_store ={};
cvar_gre_set_store = {}; 
cvar_gre_h_store = []; 
cvar_gre_tauh_store ={};
cvar_gre_hset_store = {};
cvar_gre_hbmax_store = [];
cvar_gre_hb_store ={};


%alpha_store = [0.001, 0.01, 0.03, 0.05, 0.08, 0.1, 0.2, 0.3, 0.4 0.5, 0.6, 0.7, 0.8,  0.9, 1]; 
alpha_store = [0.001,1];
for i = 1 : length(alpha_store)
% cvar_greedy_approach, using compact vector for samples
alpha = alpha_store(i); 

[cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, tau_hvalue, H_star_value, H_set, max_hstar_bound] = ...
    CVaR_greedy_matching(robot_demand_sample, alpha, delta, n_s, one_demand_bound);

% % cvar_greedy_approach, using individual samples
% [cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, max_hstar_bound] = ...
%     CVaR_greedy_sample(efficiency, alpha, delta, n_s);

cvar_gre_h_store(i, :) = [alpha, cvar_gre_hvalue];
cvar_gre_hbmax_store(i, :) = [alpha, max_hstar_bound]; 
cvar_gre_dis_store{i} = cvar_gre_dis;
cvar_gre_set_store{i} = cvar_gre_set; 
cvar_gre_tauh_store{i} = tau_hvalue; 
cvar_gre_hset_store{i} = H_set;
cvar_gre_hb_store{i} = H_star_value; 

end

% %hvalue and its bound plot
% figure (1)
% plot(cvar_gre_h_store(:,1), cvar_gre_h_store(:,2), 'r*'), hold on 
% %plot(cvar_gre_hbmax_store(:,1), cvar_gre_hbmax_store(:,2), 'bo'), hold on

%distribution plot
figure (2)
% nhist(cvar_gre_dis_store, 'legend', {'alpha=0.001', 'alpha=0.1', 'alpha=0.3', ...
%     'alpha=0.6', 'alpha=0.9'})
nhist(cvar_gre_dis_store, 'legend', {'alpha=0.001', 'alpha=1'})

% figure (3)
% for i = 1 : length(alpha_store)
%     plot(cvar_gre_tauh_store{i}(:,1), cvar_gre_tauh_store{i}(:,2)), hold on
% end

% two extreme cases, fugure(4), figure(5), alpha = 0.001
figure (4)
plot(demands(:,1), demands(:,2), 'rx'), hold on
plot(robots(:,1), robots(:,2), 'ks'), hold on

for j = 1 : length(cvar_gre_set_store{1}) %different S_j
    for k = 1 : length(cvar_gre_set_store{1}{j}) % different robot 
        plot([demands(j,1), robots(cvar_gre_set_store{1}{j}(k), 1)],...
            [demands(j,2), robots(cvar_gre_set_store{1}{j}(k), 2)]), hold on
    end
end

figure (5) %alpha = 1
plot(demands(:,1), demands(:,2), 'rx'), hold on
plot(robots(:,1), robots(:,2), 'ks'), hold on

for j = 1 : length(cvar_gre_set_store{2}) %different S_j
    for k = 1 : length(cvar_gre_set_store{2}{j}) % different robot 
        plot([demands(j,1), robots(cvar_gre_set_store{2}{j}(k), 1)],...
            [demands(j,2), robots(cvar_gre_set_store{2}{j}(k), 2)])
    end
end


% %expectation plot
% figure (3)
% %real case illustration
% figure (4)