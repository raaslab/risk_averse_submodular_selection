%%% assign multiple vehicles to multiple demand locations

% n_goal demand locations
% n_robot robots
global n_goal n_robot

n_goal = 2;
n_robot =3;

% presample these Gaussian random variables
% the number of samples for each efficiency
n_samp = 5000; 

n_trial = 1; 

%23 46 72 94

nodes_gps = gps_trial{94,1};
routes_length= routes_length_trial{94,1};
routes_degree= routes_degree_trial{94,1}; 
% 

% presample 
[routes_effi_samp] = presample_gaussian(routes_length,routes_degree, n_samp);

% % plot the distribution first 
% xaxis_left = min(routes_effi_samp(:));
% xaxis_right = max(routes_effi_samp(:));
% 
% figure (1)
% 
% s(1) = subplot(2,1,1);
% histogram(s(1), routes_effi_samp(:,:,1,2)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 12', 'fontsize', 14)
% 
% s(2) = subplot(2,1,2);
% histogram(s(2), routes_effi_samp(:,:,2,2)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 22', 'fontsize', 14)

% s(3) = subplot(3,1,3);
% histogram(s(3), routes_effi_samp(:,:,1,3)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 13', 'fontsize', 14)
% 
% figure (2)
% 
% s(1) = subplot(2,1,1);
% histogram(s(1), routes_effi_samp(:,:,2,3)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 23', 'fontsize', 14)
% 
% s(2) = subplot(2,1,2);
% histogram(s(2), routes_effi_samp(:,:,2,1)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 21', 'fontsize', 14)
% 
% s(3) = subplot(3,1,3);
% histogram(s(3), routes_effi_samp(:,:,2,3)), hold on
% axis([xaxis_left xaxis_right 0 inf])
% title('Route 23', 'fontsize', 14)


%routes_effi = max(routes_length(:))./routes_length
%     routes_length
%     routes_degree

% the upper bound for tau, because there are n_goal positions
% we need to sum up the n_goal positions
upper_bound = n_goal * (round(max(routes_effi_samp(:)))+1);

% user-defined risk levels
risk_levels = [0.1, 1.0];

% user-defined searching separation for tau
serh_sep = 0.01;

% store greedy set
cvar_greset_risks = cell(length(risk_levels),1);

% for each risk level
for i = 1 : length(risk_levels)

    risk_level = risk_levels(i); 

    % CVaR greedy assignment
    [cvar_greset, cvar_gre_distri]...
        = CVaR_greedy_graph(routes_effi_samp, risk_level, serh_sep, n_samp, upper_bound); 

    % store {cvar_greset}
    cvar_greset_risks{i} = cvar_greset;
end       