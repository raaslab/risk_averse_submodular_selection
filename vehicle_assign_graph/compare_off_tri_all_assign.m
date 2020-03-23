% compare online with offline assignment

% initial setup, vehicles, demands, routes
clear all
pause(2);
clc;
% the number of demands
D = 5;
% the number of vehicles
R = 12;

% demand nodes on the graph
d_nodes = [1, 5593274356; 2, 1468455070; 3, 726762480; 4, 726773073; 5, 5288322380];
%; 6, 729499126
% we have all_nodes, goal_routes, goal_routes_length, goal_routes_degree
load('allnodes_array');
load('goalroutes_cell');
load('goalroutes_length_array');
load('goalroutes_degree_array');
load('edges_length_degree');

% % given fixed r_nodes
%  r_nodes = [1, 726779606; 2, 1576711031; 3, 726763227];

% then we can randomly generate R vehicle nodes
r_nodes_raw = [];
% the nodes alreay chosen
node_chosen = d_nodes(:,2)'; 
while length(r_nodes_raw) < R
    inx_rand = randi([1, length(allnodes)]);
    if ~ismember(allnodes(inx_rand), node_chosen)
        r_nodes_raw = [r_nodes_raw, allnodes(inx_rand)]; 
        node_chosen = [node_chosen, allnodes(inx_rand)];
    end
end
r_nodes = zeros(R,2); 
for i =  1 : R
    r_nodes(i,1) = i;
    r_nodes(i,2) = r_nodes_raw(i); 
end

% compute the maximum number of nodes on a single path
max_num_node = 0; 
for i = 1 : D
    for j = 1 : length(allnodes)
        if length(goalroutes{i,j}) >= max_num_node
            max_num_node = length(goalroutes{i,j}); 
        end
    end
end

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

% initial setup for cvar greey assignment
% conduct online assignment, the terminated condition is all the demands are served.
% 1, presample 
n_samp = 1000;

% 2, CVaR greedy
% user-defined risk levels
risk_level = 0.1;

% user-defined searching separation for tau
serh_sep = 0.1;

n_trials = 1;

% array to the arrival time
arrive_time = zeros(5, n_trials);
% array to store the arrival time step
arrive_step = zeros(5, n_trials);
% array to store num of assignments
num_assign = zeros(5, n_trials);
% array to store the running time of assignments
run_time = zeros(5, n_trials);
% trigger ratio
tri_ratio = [0.3, 0.5, 0.7]; 


for k = 1 : n_trials
    k
    % offline assignment
    [off_arrive_time, off_arrive_step, off_run_time] = ...
        offline_assign_fun(d_nodes, r_nodes, max_num_node, ...
        routes_length, routes_degree, allnodes, goalroutes, ve_edge_de, ...
        ve_edge_de_last, edges_length_degree, risk_level, serh_sep, n_samp);
    
    % only initial assign
    arrive_time(1,k) = off_arrive_time;
    arrive_step(1,k) = off_arrive_step;
    num_assign(1,k) = 1; 
    run_time(1,k) = off_run_time;
    
    % triggering assignment
    for l = 1: size(tri_ratio,2)
        l
        [tri_arrive_time, tri_arrive_step, tri_num_assign, tri_run_time] = ...
            trigger_assign_fun(d_nodes, r_nodes, max_num_node, ...
            routes_length, routes_degree,...
            allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree, ...
            goalroutes_length, goalroutes_degree, risk_level, serh_sep, n_samp, D, tri_ratio(l));

        % assign at triggering time steps
        arrive_time(1+l,k) = tri_arrive_time;
        arrive_step(1+l,k) = tri_arrive_step;
        num_assign(1+l,k) = tri_num_assign;
        run_time(1+l,k) = tri_run_time;
    end    
    
    % all_step assingment
    [all_arrive_time, all_arrive_step, all_run_time] = ...
        allstep_assign_fun(d_nodes, r_nodes, max_num_node, ...
        routes_length, routes_degree,...
        allnodes, goalroutes,ve_edge_de, ve_edge_de_last, edges_length_degree, ...
        goalroutes_length, goalroutes_degree, risk_level, serh_sep, n_samp, D);
    
    % assign at every time step
    arrive_time(5,k) = all_arrive_time;
    arrive_step(5,k) = all_arrive_step;
    num_assign(5,k) = all_arrive_step;
    run_time(5,k) = all_run_time;
end
%%
% plot comparision of 3 assigment strategy w.r.t arrive_time
figure(1), hold on
boxplot(arrive_time', {'Offline', 'Trigger-0.3', 'Trigger-0.5', 'Trigger-0.7', 'All-step'}) 
% title('The time when all the demand locations are reached')
% xlabel(' ')
ylabel('Arrival time')
% title('arrival time')

% % plot comparision of 3 assigment strategy w.r.t arrive_time and trigger cnt
% figure(2), hold on
% boxplot(arrive_step', {'Offline', 'Trigger-0.3', 'Trigger-0.5', 'Trigger-0.7', 'All-step'}) 
% % title('The time when all the demand locations are reached')
% % xlabel(' ')
% ylabel('Arrival step')
% % title('arrival steps')

figure(2), hold on
boxplot(num_assign', {'Offline', 'Trigger-0.3', 'Trigger-0.5', 'Trigger-0.7', 'All-step'})
% title('The number of ')
% xlabel('Country of Origin')
ylabel('Number of assignments')
% title('number of assignments')

figure(3)
boxplot(run_time', {'Offline', 'Trigger-0.3', 'Trigger-0.5', 'Trigger-0.7', 'All-step'})
% title('Miles per Gallon by Vehicle Origin')
% xlabel('Country of Origin')
ylabel('Running time')
% title('running time')