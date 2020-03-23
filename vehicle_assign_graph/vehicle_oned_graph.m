%%% assign multiple vehicles to multiple demand locations

system('/usr/local/opt/python3/bin/python3 gps_path_test.py')
% after receive the data from gps_path_degree.py
%   load('nodes_gps_cell.mat');
  load('routes_length_cell.mat');
  load('routes_degree_cell.mat');
% after loading, we get routes_gps, routes_degree, robotes_length
% then we use create Gaussian random variables, mean: 1/robotes_length,
% variance: routes degree*10, we sample n_sample of it. 

%%
% n_goal demand locations
% n_robot robots
global n_goal n_robot

[n_goal, n_robot]=size(routes_length);

% presample these Gaussian random variables
% the number of samples for each efficiency
n_samp = 5000; 

% presample 
[routes_effi_samp] = presample_gaussian(routes_length,routes_degree, n_samp);

% plot the distribution first 
xaxis_left = min(routes_effi_samp(:));
xaxis_right = max(routes_effi_samp(:));

figure (1)

s(1) = subplot(3,1,1);
histogram(s(1), routes_effi_samp(:,:,1,1)), hold on
axis([xaxis_left xaxis_right 0 inf])
title('Route 11', 'fontsize', 14)

s(2) = subplot(3,1,2);
histogram(s(2), routes_effi_samp(:,:,1,2)), hold on
axis([xaxis_left xaxis_right 0 inf])
title('Route 12', 'fontsize', 14)

s(3) = subplot(3,1,3);
histogram(s(3), routes_effi_samp(:,:,1,3)), hold on
axis([xaxis_left xaxis_right 0 inf])
title('Route 13', 'fontsize', 14)

% s(4) = subplot(4,1,4);
% histogram(s(4), routes_effi_samp(:,:,1,4)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Paths 4', 'fontsize', 14)

routes_length
routes_degree
%%
% the upper bound for tau, because there are n_goal positions
% we need to sum up the n_goal positions
upper_bound = n_goal * (round(max(routes_effi_samp(:)))+1);

% user-defined risk levels
risk_levels = [0.01, 0.02, 0.03, 0.05, 0.1, 0.2, 0.3, 0.5, 0.8, 1.0];

% user-defined searching separation for tau
serh_sep = 0.01;

% store greedy set
cvar_greset_risks = cell(length(risk_levels),1);

% for each risk level
for i = 1 : length(risk_levels)

    risk_level = risk_levels(i); 

    % CVaR greedy assignment
    [cvar_set]...
        = CVaR_graph(routes_effi_samp, risk_level, serh_sep, n_samp, upper_bound); 

    % store {cvar_greset}
    cvar_greset_risks{i, 1} = cvar_set;
    cvar_greset_risks{i, 1}
end
    