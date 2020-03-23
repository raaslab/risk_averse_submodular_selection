% offline_vehicle_assignment function
function [arrive_time, arrive_step, run_time] = offline_assign_fun(d_nodes, r_nodes, max_num_node, ...
    routes_length, routes_degree,...
    allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree, ...
    risk_level, serh_sep, n_samp)
    
    % define cell to store online assignment
    % the number of assignments is less than max_num_node
    online_dnodes = cell(1, max_num_node);
    online_rnodes = cell(1, max_num_node);
    online_edge = cell(1, max_num_node); 

    % the assignment is decided by the initial positions of vehicles and demands
    % presample 
    [routes_effi_samp] = presample_gaussian(routes_length, routes_degree, n_samp);

    % the upper bound for tau, because there are n_goal positions
    % we need to sum up the n_goal positions
    upper_bound = length(d_nodes) * round(max(routes_effi_samp(:)));
    
    % CVaR greedy assignment
    % cvar_gre_distri
    tic;
    [cvar_greset] = CVaR_greedy_graph(routes_effi_samp, risk_level, serh_sep, n_samp, upper_bound);

    arrive_time = 0;
    arrive_step = 1;
    min_reach_next_time = 0;
    
%     min2_reach_next_time = 0;
    while ~isempty(d_nodes)
        % update parameters
%         [d_nodes, r_nodes, ve_edge_de, ve_edge_de_last]...
%             = update_parameter_offline(d_nodes, r_nodes, cvar_greset,...
%            allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree); 
       
%         [d_nodes, r_nodes, ve_edge_de, ve_edge_de_last, min_reach_next_time]...
%             = update_parameter_offline_minnext(d_nodes, r_nodes, cvar_greset,...
%            allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree); 
       
        [d_nodes, r_nodes, ve_edge_de, ve_edge_de_last, min_reach_next_time]...
            = update_parameter_offline_minnext2(d_nodes, r_nodes, cvar_greset,...
           allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree,...
             min_reach_next_time);        

        % store assignment for each move
        online_dnodes{arrive_step} = d_nodes;
        online_rnodes{arrive_step} = r_nodes;
        online_edge{arrive_step} = ve_edge_de_last;
        arrive_step = arrive_step + 1; 
        arrive_time = arrive_time + min_reach_next_time;

        % plot 
        % graph_plot(cvar_greset, allnodes, r_nodes(:,2), goalroutes);
    end
    run_time = toc;
end