%%% assign multiple vehicles to multiple demand locations

% n_goal demand locations
% n_robot robots

n_goal = 2;
n_robot = 3;

% presample these Gaussian random variables
% the number of samples for each efficiency
n_samp = 5000; 

n_trial = 1; 

% store data
gps_trial = cell(n_trial, 1);
routes_trial = cell(n_trial,1);
routes_length_trial = cell(n_trial, 1);
routes_degree_trial = cell(n_trial, 1);


% store all the gre_set
gre_set_trials = cell(n_trial, 1); 

for k = 1 : n_trial
    k
    system('/usr/local/opt/python3/bin/python3 gps_path_degree.py')
    % after receive the data from gps_path_degree.py
      load('gps_cell.mat');
      load('routes_length_cell.mat');
      load('routes_degree_cell.mat');
    % after loading, we get routes_gps, routes_degree, robotes_length
    % then we use create Gaussian random variables, mean: 1/robotes_length,
    % variance: routes degree*10, we sample n_sample of it. 
    
    gps_trial{k} = nodes_gps;
%     routes_trial{k} = routes; % routes is a cell data with [1,R*D] dimensions
    routes_length_trial{k} = routes_length;
    routes_degree_trial{k} = routes_degree;
    
    % presample 
    [routes_effi_samp] = presample_gaussian(routes_length,routes_degree, n_samp);

    % % plot the distribution first 
    % xaxis_left = min(routes_effi_samp(:));
    % xaxis_right = max(routes_effi_samp(:));

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

    % figure (2)
    % 
    % s(1) = subplot(3,1,1);
    % histogram(s(1), routes_effi_samp(:,:,2,1)), hold on
    % axis([xaxis_left xaxis_right 0 inf])
    % title('Route 21', 'fontsize', 14)
    % 
    % s(2) = subplot(3,1,2);
    % histogram(s(2), routes_effi_samp(:,:,2,2)), hold on
    % axis([xaxis_left xaxis_right 0 inf])
    % title('Route 22', 'fontsize', 14)
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
    upper_bound = n_goal * round(max(routes_effi_samp(:)));

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
                = CVaR_greedy_graph(n_goal, n_robot, routes_effi_samp, ...
                risk_level, serh_sep, n_samp, upper_bound); 

            % store {cvar_greset}
            cvar_greset_risks{i} = cvar_greset; 
            
            % we know next node and call python to 
            
        end 
       
              
       gre_set_trials{k} = cvar_greset_risks;   
end