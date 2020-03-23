% update parameters after each move
function [d_nodes_1, r_nodes_1, rnodes_full_1, ve_edge_de_1, ve_edge_de_last_1,...
    routes_length, routes_degree, greset_full_1, greset_update_1, min_reach_next_time]...
            = update_parameter_allstep_minnext(d_nodes, r_nodes, rnodes_full, cvar_set, ...
            greset_full, greset_update, allnodes, goalroutes, goalroutes_length, ...
            goalroutes_degree, ve_edge_de, ve_edge_de_last, edges_length_degree)  
        %routes_effi_samp_temp, goalroutes_effi_samp, n_s
        % d_nodes_1; 
        d_nodes_1 = d_nodes;
        r_nodes_1 = r_nodes;
        rnodes_full_1 = rnodes_full;
        
        greset_update_1 = greset_update;
        
        % greset_update_1, always the updated assignment
        % some demand column can be gone
        % greset_full_1, always the whole assignemnt, even some demands are
        % already served
        sum = 0; 
        for i = 1 : length(greset_update)
            sum = sum + length(greset_update{i});
        end
        
        if sum < length(rnodes_full_1(:,1))
            greset_full_1 = greset_update;
        else
            greset_full_1 = greset_full;
        end
        
        ve_edge_de_1 = ve_edge_de;
        ve_edge_de_last_1 = ve_edge_de_last; 

        % all vehicles take a sample on the travel time
        % set the per-step as the smallest travel time of the vehicle arrving at the next node
        reach_next_time_sample = cell(length(d_nodes(:,1)),1); 
        min_reach_next_time = 10000; 
        for i = 1 : length(d_nodes(:,1))
            for j = 1 : length(cvar_set{i})
                v1v2_len = ve_edge_de{d_nodes(i,1), r_nodes(cvar_set{i}(j),1)}(2);
                v1v2_degree = ve_edge_de{d_nodes(i,1), r_nodes(cvar_set{i}(j),1)}(3);
                % unifrom distribution [v1v2_len, v1v2_len+v1v2_degree]
                % travel time is proportional to travel length + uncertainty
                s_ini = trandn(0, inf);
                s = v1v2_len + s_ini * sqrt(v1v2_degree); 
                
                reach_next_time_sample{i} = [reach_next_time_sample{i}, s];
                
                ve_edge_de_last_1{d_nodes(i,1), r_nodes(cvar_set{i}(j),1)}...
                     = [0, v1v2_len, v1v2_degree, s];
                if s <= min_reach_next_time
                    min_reach_next_time = s; 
                end
            end
        end              
        
         reach_demand_j = []; 
         for i = 1 : length(d_nodes(:,1)) % note that set and d_node have the same length
             % demand inx, d(i,1), 
             d_inx = d_nodes(i,1);
             greset_full_1{d_inx} = [];
             greset_update_1{d_inx} = [];
             reach_demand_i = 0; 
             r_reach_i = [];
             for j = 1 : length(cvar_set{i}) %check its elements
                 % update set{i}(j) by real index
                 greset_full_1{d_inx} = [greset_full_1{d_inx}, r_nodes(cvar_set{i}(j), 1)];
                 greset_update_1{d_inx} = [greset_update_1{d_inx}, r_nodes(cvar_set{i}(j), 1)];
                 % set{i}{j} corresponds to the route, d(i,1) to r(set{i}{j}, 1) 
                 % make vehicle, r(set{i}{j},1) move to next node along the
                 % route, d(i,1) to r(set{i}{j}, 1)
                 % vehicle inx 
                 r_inx = find(allnodes == r_nodes(cvar_set{i}(j), 2)); 
                 
                 % OK, to decide where the vehicle should move
                 % the vehicle is on edge, ONLINE DECISION:
                 % [allroutes{d_inx,r_inx}(end),allroutes{d_inx,r_inx}(end-1)]
                 % sample from the edge, if sample < legnth_mean, go end-1                 
                 % v1: r_nodes(set{i}(j), 2)
                 % v2: allroutes{d_inx,r_inx}(end-1)
                 % corresponds to [d_nodes(i,1), r_nodes(set{i}(j),1)]
                 % sample from edge v1,v2
%                  v1v2_len = ve_edge_de{d_inx, r_nodes(cvar_set{i}(j),1)}(2);
%                  v1v2_degree = ve_edge_de{d_inx, r_nodes(cvar_set{i}(j),1)}(3); 
%                   
%                  s = normrnd(v1v2_len, v1v2_degree);
%                  ve_edge_de_last_1{d_inx, r_nodes(cvar_set{i}(j),1)}...
%                      = [0, v1v2_len, v1v2_degree, s];

                 % if the vehicle can to to next node, d(v1v2) = 0;
                 % update to next edge v2v3
                 v2 = goalroutes{d_inx,r_inx}(end-1);    
                 
                 % if the travel_time_sample is the min_travel_time_sample, the vehicle can go to the next node
                 if reach_next_time_sample{i}(j) == min_reach_next_time || ...
                         ismember(r_nodes(cvar_set{i}(j), 2), [3586727936, 3586727937, 3586727938, ...
                         3586727939, 3586727940, 3586727941])
                     next_move = v2;
                     ve_edge_de_1{d_inx, r_nodes(cvar_set{i}(j),1)}(1) = 0;
                     ve_edge_de_last_1{d_inx, r_nodes(cvar_set{i}(j),1)}(1) = 0;
                     if v2 ~= d_nodes(i,2)
                         % next edge v2, v3;
                         v3 = goalroutes{d_inx,r_inx}(end-2); 
                         v3v2_inx = find(edges_length_degree(:,1)==v3 & ...
                            edges_length_degree(:,2)==v2, 1);
                         len = edges_length_degree(v3v2_inx, 3);
                         degree = edges_length_degree(v3v2_inx, 4);
                         ve_edge_de_1{d_inx, r_nodes(cvar_set{i}(j),1)} = [0, len, degree]; 
                     end
                 else
                 % otherwise, stay end, reduce the edge length by sample,
                 % (1-length_mean/sample) * length_mean, same, uncertainty
                 % the vehicle stay on edge v1v2, but be closer to v2
                    % the distance from v1' to v2:
                    d_to_v2 = v1v2_len * (1 - min_reach_next_time/reach_next_time_sample{i}(j));
                    % change v1v2_len to v1'v2
                    ve_edge_de_1{d_inx, r_nodes(cvar_set{i}(j),1)}(2) = d_to_v2;
                    % keep the next move at current node, 
                    next_move = goalroutes{d_inx,r_inx}(end);
                    % but we need to keep track of next node, 
                    % becasuse the vehicle is not going to turn back
                    % the lengh should be v1'v2 + v2 onwards... 
                    % so keep v2.
                    % indicate v2 is not arrived yet, arrive v1', keep v2
                    ve_edge_de_1{d_inx, r_nodes(cvar_set{i}(j),1)}(1) ...
                        = goalroutes{d_inx,r_inx}(end-1);
                    ve_edge_de_last_1{d_inx, r_nodes(cvar_set{i}(j),1)}(1) = 1; 
                 end   
                 % check if next_move is the same as the demand
                 % remove the vehicle and the demand
                 if next_move == d_nodes(i,2) 
                     reach_demand_i = 1; 
                     reach_demand_j = [reach_demand_j, cvar_set{i}(j)];
                     r_reach_i = [r_reach_i, r_nodes(cvar_set{i}(j), 1)];
                 else % not reach the demand, make nxet move
                     r_nodes_1(cvar_set{i}(j), 2) =  next_move; 
                 end
                 %update r_full_nodes, r: r_nodes(set{i}(j), 1)
                 rnodes_full_1(r_nodes(cvar_set{i}(j), 1)) = next_move;
             end
             if reach_demand_i == 1
                 num_d_served =  length(d_nodes(:,1)) - length(d_nodes_1(:,1));
                 d_nodes_1(i-num_d_served, :) = [];
                  %update greset_full_1
                 greset_update_1{d_inx} = r_reach_i;
                  %put the ids of arrived vehicles in it within i loop. 
             end
         end 
         % some vehicles arrived! make the rows empty
         r_nodes_1(reach_demand_j,:)=[]; 

        % update routes_length routes_degree
        routes_length = zeros(length(d_nodes_1(:,1)),length(r_nodes_1(:,1)));
        routes_degree = zeros(length(d_nodes_1(:,1)),length(r_nodes_1(:,1)));
        % update routes_efficiency_samp_temp
%         routes_effi_samp_temp = zeros(1,n_s, length(d_nodes_1(:,1)),length(r_nodes_1(:,1)));
        
        for i = 1 : length(d_nodes_1(:,1)) 
            d_inx = d_nodes_1(i, 1);
            for j = 1 : length(r_nodes_1(:,1))
                r_inx = r_nodes_1(j,1); 
                % check ve_edge_de
                reach_next = ve_edge_de_1{d_inx, r_inx}(1);
                
                % reach v2
                if reach_next == 0 
                    % find v2_inx
                   v2_node_inx = find(allnodes == r_nodes_1(j,2));
                   routes_length(i,j) = goalroutes_length(d_inx, v2_node_inx);
                   routes_degree(i,j) = goalroutes_degree(d_inx, v2_node_inx);
%                    routes_effi_samp_temp(:,:,i,j) = goalroutes_effi_samp(:,:, d_inx, v2_node_inx);
                else
                % reach v1', not v2
                % but we keep track of v2
                  v1_node_inx = find(allnodes == r_nodes_1(j,2));
                  v2_keep_inx = find(allnodes == reach_next);
                  v1primev2_len = ve_edge_de_1{d_inx, r_inx}(2);                   
%                   v1primev2_effi_samp = max(0., normrnd(max(goalroutes_length(:)/v1primev2_len), ...
%                       ve_edge_de_1{d_inx, r_inx}(3), [1, n_s]));                  
                  routes_degree(i,j) = goalroutes_degree(d_inx, v1_node_inx);
                  routes_length(i,j) = v1primev2_len + goalroutes_length(d_inx, v2_keep_inx);                 
%                   goal_v2_effi_samp = goalroutes_effi_samp(:,:,d_inx, v2_keep_inx);
%                   routes_effi_samp_temp(:,:,i,j) = ...
%                       (v1primev2_effi_samp.* goal_v2_effi_samp)./(v1primev2_effi_samp + ...
%                       goal_v2_effi_samp);
                end
                
            end
        end
end