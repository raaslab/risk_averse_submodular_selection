% triggering_vehicle_assignment function
function [arrive_time, arrive_step, num_assign, run_time] = ...
    trigger_assign_fun(d_nodes, r_nodes, max_num_node, ...
    routes_length, routes_degree,...
    allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree, ...
    goalroutes_length, goalroutes_degree, risk_level, serh_sep, n_samp, D, tri_ratio)
    
    % define cell to store online assignment
    % the number of assignments is less than max_num_node
    online_assign = cell(1, max_num_node);
    online_dnodes = cell(1, max_num_node);
    online_rnodes = cell(1, max_num_node);
    online_edge = cell(1, max_num_node);

    % keep track of all nodes at each time step
    r_nodes_full = r_nodes(:,2);
    % keep track of the assignments
    greset_full = cell(D,1);
    greset_update = cell(D,1); 
    
    arrive_time = 0;
    arrive_step = 1;
    num_assign = 0;
    min_reach_next_time = 0;
    % assignment triggering condition
    % do an initial assignment at the first step
    tri_flag = 1;
        
    tic;
    while ~isempty(d_nodes)
        if tri_flag == 1
            num_assign = num_assign + 1; 
            % initial assignment is decided by the initial positions of vehicles and demands
            % presample 
            [routes_effi_samp] = presample_gaussian(routes_length, routes_degree, n_samp);

            % the upper bound for tau, because there are n_goal positions
            % we need to sum up the n_goal positions
            upper_bound = length(d_nodes) * round(max(routes_effi_samp(:))); 
            
            % CVaR greedy assignment
            % Cvar_gre_distri
            [cvar_greset]...
             = CVaR_greedy_graph(routes_effi_samp, risk_level, serh_sep, n_samp, upper_bound);            
            % set back to 0
            tri_flag = 0;
        end
        % update parameters after each move
%         [d_nodes, r_nodes, r_nodes_full, ve_edge_de, ve_edge_de_last,...
%             routes_length, routes_degree, greset_full, greset_update, tri_flag]...
%             = update_parameter_trigger(d_nodes, r_nodes, r_nodes_full, cvar_greset, greset_full,...
%             greset_update, allnodes, goalroutes, goalroutes_length, goalroutes_degree,...
%             ve_edge_de, ve_edge_de_last, edges_length_degree, tri_flag, tri_ratio); 
        
%         [d_nodes, r_nodes, r_nodes_full, ve_edge_de, ve_edge_de_last,...
%             routes_length, routes_degree, greset_full, greset_update, tri_flag, min_reach_next_time]...
%             = update_parameter_trigger_minnext(d_nodes, r_nodes, r_nodes_full, cvar_greset, greset_full,...
%             greset_update, allnodes, goalroutes, goalroutes_length, goalroutes_degree,...
%             ve_edge_de, ve_edge_de_last, edges_length_degree, tri_flag, tri_ratio); 
        
         [d_nodes, r_nodes, r_nodes_full, ve_edge_de, ve_edge_de_last,...
            routes_length, routes_degree, greset_full, greset_update, tri_flag, min_reach_next_time]...
            = update_parameter_trigger_minnext2(d_nodes, r_nodes, r_nodes_full, cvar_greset, greset_full,...
            greset_update, allnodes, goalroutes, goalroutes_length, goalroutes_degree,...
            ve_edge_de, ve_edge_de_last, edges_length_degree, tri_flag, tri_ratio, min_reach_next_time); 
        
            % store assignment for each move
        online_assign{arrive_step} = greset_full; 
        online_dnodes{arrive_step} = d_nodes;
        online_rnodes{arrive_step} = r_nodes;
        online_edge{arrive_step} = ve_edge_de_last;
        arrive_step = arrive_step + 1; 
        arrive_time = arrive_time + min_reach_next_time; 
        
        % plot  
        % graph_plot(greset_full, allnodes, r_nodes_full, goalroutes); 
    end
    run_time = toc;
end