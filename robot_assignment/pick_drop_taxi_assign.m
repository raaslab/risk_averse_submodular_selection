%%% in this file, we first read the shortest_paths_len from pick_up locations
%%% from a txt file. 

% *** multi_pick_drop path assignment ***
global N R 

% read the txt file
short_path_len = dlmread('shortest_path_len.txt');

% the number of drop_offs N (goals)
% the number of pick_ups R (starts)
[N,R] = size(short_path_len);
N = floor(N/3); 
short_path_len = short_path_len(:, 1:N)';

% calculate the efficiency each-pick-each-drop 
% we assume the length is a poisson distribution

%sampling times
n_s = 10000;

short_path_sample = pickdrop_path_distribution(short_path_len, n_s); 
one_path_bound = round(max(short_path_sample(:)));
%%

%user-defined confidence level
%note that this guy can be cahnged later
%alpha = 0.05; 
delta = 10;

% define CVaR_set_dis
cvar_gre_dis_store ={};
cvar_gre_set_store = {}; 
cvar_gre_h_store = []; 
cvar_gre_tauh_store ={};
cvar_gre_hset_store = {};
cvar_gre_hbmax_store = [];
cvar_gre_hb_store ={};
cvar_gre_add_store =[];
cvar_gre_tau_store=[];
cvar_gre_curv_store=[]; 


%alpha_store = [0.001, 0.01, 0.03, 0.05, 0.08, 0.1, 0.2, 0.3, 0.4 0.5, 0.6, 0.7, 0.8,  0.9, 1]; 
alpha_store = [0.001, 0.01, 0.1, 0.3, 0.6, 0.9, 1]; 
%alpha_store = [0.1,1];

for i = 1 : length(alpha_store)
% cvar_greedy_approach, using compact vector for samples
alpha = alpha_store(i); 

[cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, cvar_gre_add,cvar_gre_tau,cvar_gre_curv, tau_hvalue, H_star_value, H_set, max_hstar_bound] = ...
    CVaR_greedy_matching(short_path_sample, alpha, delta, n_s, one_path_bound);

% % cvar_greedy_approach, using individual samples
% [cvar_gre_set, cvar_gre_dis, cvar_gre_hvalue, max_hstar_bound] = ...
%     CVaR_greedy_sample(efficiency, alpha, delta, n_s);

cvar_gre_h_store(i, :) = [alpha, cvar_gre_hvalue];
cvar_gre_add_store(i, :) =[alpha, cvar_gre_add];
cvar_gre_hbmax_store(i, :) = [alpha, max_hstar_bound]; 
cvar_gre_dis_store{i} = cvar_gre_dis;
cvar_gre_set_store{i} = cvar_gre_set; 
cvar_gre_tauh_store{i} = tau_hvalue; 
cvar_gre_hset_store{i} = H_set;
cvar_gre_hb_store{i} = H_star_value; 
cvar_gre_tau_store(i, :) = [alpha, cvar_gre_tau]; 
cvar_gre_curv_store(i, :) = [alpha, cvar_gre_curv]; 
end

% %hvalue and its bound plot
figure (1)
plot(cvar_gre_h_store(:,1), cvar_gre_h_store(:,2), 'r*'), hold on 
% %plot(cvar_gre_hbmax_store(:,1), cvar_gre_hbmax_store(:,2), 'bo'), hold on

figure (2)
plot(cvar_gre_add_store(:,1), cvar_gre_add_store(:,2), 'bo'), hold on
% %plot(cvar_gre_hbmax_store(:,1), cvar_gre_hbmax_store(:,2), 'bo'), hold on

figure (3)
plot(cvar_gre_tau_store(:,1), cvar_gre_tau_store(:,2), 'ro'), hold on

figure (4)
plot(cvar_gre_curv_store(:,1), cvar_gre_curv_store(:,2), 'b*'), hold on

%distribution plot
figure (5)
 nhist(cvar_gre_dis_store, 'legend', {'$$\alpha=0.001$$', '$$\alpha=0.01$$', ...
     '$$\alpha=0.01$$', '$$\alpha=0.3$$', ...
     '$$\alpha=0.6$$', '$$\alpha=0.9$$', '$$\alpha=1$$'}); 
%nhist(cvar_gre_dis_store, 'legend', {'alpha=0.1', 'alpha=1'})

% figure (4)
% for i = 1 : length(alpha_store)
%     plot(cvar_gre_tauh_store{i}(:,1), cvar_gre_tauh_store{i}(:,2)), hold on
% end
%%
% two extreme cases, fugure(4), figure(5), alpha = 0.001
figure (5)
plot(demands(:,1), demands(:,2), 'rx'), hold on
plot(robots(:,1), robots(:,2), 'ks'), hold on

for j = 1 : length(cvar_gre_set_store{1}) %different S_j
    for k = 1 : length(cvar_gre_set_store{1}{j}) % different robot 
        plot([demands(j,1), robots(cvar_gre_set_store{1}{j}(k), 1)],...
            [demands(j,2), robots(cvar_gre_set_store{1}{j}(k), 2)]), hold on
    end
end

figure (6) %alpha = 1
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