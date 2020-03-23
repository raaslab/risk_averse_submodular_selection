% offline vehicle assignment
clear all
pause(2);
clc;
% the number of demands
D = 2;
% the number of vehicles
R = 3;

% demand nodes on the graph
d_nodes = [1, 5593274356; 2, 1468455070];
%     ; 3, 726762480; 4, 726773073; 5, 5288322380];
%; 6, 729499126
% we have all_nodes, goal_routes, goal_routes_length, goal_routes_degree
load('allnodes_array');
load('goalroutes_cell');
load('goalroutes_length_array');
load('goalroutes_degree_array');
load('edges_length_degree');

% % then we can randomly generate R vehicle nodes
% r_nodes_raw = [];
% % the nodes alreay chosen
% node_chosen = d_nodes(:,2)'; 
% while length(r_nodes_raw) < R
%     inx_rand = randi([1, length(allnodes)]);
%     if ~ismember(allnodes(inx_rand), node_chosen)
%         r_nodes_raw = [r_nodes_raw, allnodes(inx_rand)]; 
%         node_chosen = [node_chosen, allnodes(inx_rand)];
%     end
% end
% r_nodes = zeros(R,2); 
% for i =  1 : R
%     r_nodes(i,1) = i;
%     r_nodes(i,2) = r_nodes_raw(i); 
% end
r_nodes = [1, 726779606; 2, 1576711031; 3, 726763227];
% 
%  r_nodes = [1   726762002;
%            2   726759699;
%            3   726764816;
%            4   713851299;
%            5   726761550;
%            6   734837802]; 

% first calculate the routes_length and routes_degree for each d_node to each r_node
routes_length = zeros(D,R);
routes_degree = zeros(D,R);
% create a cell_table to update the edge the vehicle is on
% first value should be the first edge from each vehicle to each demand on the route
ve_edge_de = cell(D, R);
ve_edge_de_last = cell(D,R);

for i = 1 : D 
    for j = 1 : R
        r_inx = find(allnodes == r_nodes(j,2));
        routes_length(i,j) = goalroutes_length(i, r_inx);
        routes_degree(i,j) = goalroutes_degree(i, r_inx); 
        % indicator: the robot is on tail node (v_1)
        % edge, tail(v_1)--> head(v2), len and degree
        % v1: r_nodes(j,2).
        % v2: allroutes{d_inx,r_inx}(end-1). 
        v2v1_inx = find(edges_length_degree(:,1)== goalroutes{i,r_inx}(end-1) & ...
            edges_length_degree(:,2)== r_nodes(j,2)); 
        len = edges_length_degree(v2v1_inx, 3);
        degree = edges_length_degree(v2v1_inx, 4);
        ve_edge_de{i,j} = [0, len, degree];    
        % store reach_state, current_len, degree, sample
        ve_edge_de_last{i,j} = [0, len, degree, 0]; 
    end
end
%%
% conduct online assignment, the terminated condition is all the demands are served.
% 1, presample 
n_samp = 1000;

% 2, CVaR greedy
% user-defined risk levels
risk_levels = [0.1];

% user-defined searching separation for tau
serh_sep = 0.1;

% store greedy set
cvar_greset_risks = cell(length(risk_levels),1);
online_dnodes_risks = cell(length(risk_levels),1);
online_rnodes_risks = cell(length(risk_levels),1);
online_edge_risks = cell(length(risk_levels),1);

% compute the maximum number of nodes on a single path
max_num_node = 0; 
for i = 1 : D
    for j = 1 : length(allnodes)
        if length(goalroutes{i,j}) >= max_num_node
            max_num_node = length(goalroutes{i,j}); 
        end
    end
end

for i = 1 : length(risk_levels)
    % define cell to store online assignment
    % the number of assignments is less than max_num_node
    online_dnodes = cell(1, max_num_node);
    online_rnodes = cell(1, max_num_node);
    online_edge = cell(1, max_num_node); 
    % keep track of active nodes at all time step
    d_nodes_act = d_nodes;
    r_nodes_act = r_nodes; 
    % keep track of all nodes at each time step
    % d_nodes_full = d_nodes;
    r_nodes_full = r_nodes(:,2);
    % keep track of the assignments
    greset_full = cell(D,1);
    greset_update = cell(D,1); 
    routes_length_temp = routes_length;
    routes_degree_temp = routes_degree;
     
    % the assignment is decided by the initial positions of vehicles and demands
    % presample 
    [routes_effi_samp] = presample_gaussian(routes_length_temp, routes_degree_temp, n_samp);

    % the upper bound for tau, because there are n_goal positions
    % we need to sum up the n_goal positions
    upper_bound = length(d_nodes_act) * round(max(routes_effi_samp(:)));

    % set risk_level
    risk_level = risk_levels(i); 

    % CVaR greedy assignment
    % cvar_gre_distri
    [cvar_greset] = CVaR_greedy_graph(routes_effi_samp, risk_level, serh_sep, n_samp, upper_bound);
    
    cnt = 1;
    min_reach_next_time = 0;
    arrive_time = 0; 
    while ~isempty(d_nodes_act)
        cnt
%         % update parameters, minnext
%         [d_nodes_act, r_nodes_act, ve_edge_de, ve_edge_de_last, min_reach_next_time]...
%             = update_parameter_offline_minnext(d_nodes_act, r_nodes_act, cvar_greset,...
%            allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree); 
        
        % update parameters, minnext2
        [d_nodes_act, r_nodes_act, ve_edge_de, ve_edge_de_last, min_reach_next_time]...
            = update_parameter_offline_minnext2(d_nodes_act, r_nodes_act, cvar_greset,...
           allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree, min_reach_next_time); 
        
        %store assignment for each move
        online_dnodes{cnt} = d_nodes(:,2);
        online_rnodes{cnt} = r_nodes;
        online_edge{cnt} = ve_edge_de_last;
        cnt = cnt + 1; 
        arrive_time = arrive_time + min_reach_next_time; 
        %plot 
        graph_plot(cvar_greset, allnodes, r_nodes_act(:,2), goalroutes);
    end
    
    %store parameter in each round
    online_dnodes = online_dnodes(~cellfun(@isempty, online_dnodes));
    online_dnodes_risks{i} = online_dnodes;
    
    online_rnodes = online_rnodes(~cellfun(@isempty, online_rnodes));
    online_rnodes_risks{i} = online_rnodes; 
    
    online_edge = online_edge(~cellfun(@isempty, online_edge));
    online_edge_risks{i} = online_edge; 
end