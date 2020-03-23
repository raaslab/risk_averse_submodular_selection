% update parameters after each move
function [d_nodes_1, r_nodes_1, ve_edge_de_1, ve_edge_de_last_1, min_reach_next_time_1]...
            = update_parameter_offline_minnext2(d_nodes, r_nodes, cvar_set,...
            allnodes, goalroutes, ve_edge_de, ve_edge_de_last, edges_length_degree, min_reach_next_time)  
        
        %routes_effi_samp_temp, goalroutes_effi_samp, n_s
        % d_nodes_1; 
        d_nodes_1 = d_nodes;
        r_nodes_1 = r_nodes;
%         rnodes_full_1 = rnodes_full;
        
        ve_edge_de_1 = ve_edge_de;
        ve_edge_de_last_1 = ve_edge_de_last; 
         % d_node, r_node are always the reference
         % actullay, the main update is r_nodes, 
         % since we let all vehicles move to next node
%          reach_demand_j = zeros(length(r_nodes_1(:,1)),1);

        min_reach_next_time_1 = min_reach_next_time;
    
         % all vehicles take a sample on the travel time
         % set the per-step as the smallest travel time of the vehicle arrving at the next node        
         reach_next_time = cell(length(d_nodes(:,1)),1); 
         reach_next_time_temp =[];
         
         for i = 1 : length(d_nodes(:,1)) 
             d_2_inx = find(d_nodes(:,2) == d_nodes(i,2));
             for j = 1 : length(cvar_set{d_2_inx})
                v1v2_len = ve_edge_de{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)}(2);
                v1v2_degree = ve_edge_de{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)}(3);
                % if reach the new node, sample
                if ve_edge_de_last_1{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)}(1) == 0      
                    % unifrom distribution [v1v2_len, v1v2_len+v1v2_degree]
                    % travel time is proportional to travel length + uncertainty
                    s_ini = trandn(0, 1); %v1v2_len/sqrt(v1v2_degree)
                    s = v1v2_len + s_ini * sqrt(v1v2_degree);
                elseif ve_edge_de_last_1{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)}(1) == 1 %update the old sample time
                    s = ve_edge_de_last_1{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)}(4) - min_reach_next_time_1;
                end
                %update the time to reach the next node, stay on the current node/edge or move to the next edge
                ve_edge_de_last_1{d_nodes(i,1), r_nodes(cvar_set{d_2_inx}(j),1)} = [0, v1v2_len, v1v2_degree, s];
                reach_next_time{i} = [reach_next_time{i}, s];
                reach_next_time_temp = [reach_next_time_temp, s];                                
             end
         end
        % update the min_reach_next_time
        min_reach_next_time_1 = min(reach_next_time_temp);         
         
         for i = 1 : length(d_nodes(:,1)) % note that set and d_node have the same length
             % demand inx, d(i,1), 
             d_inx = d_nodes(i,1);
             d_2_inx = find(d_nodes(:,2) == d_nodes(i,2));
             reach_demand_i = 0; 
             for j = 1 : length(cvar_set{d_2_inx}) %check its elements
                 % set{i}{j} corresponds to the route, d(i,1) to r(set{i}{j}, 1) 
                 % make vehicle, r(set{i}{j},1) move to next node along the
                 % route, d(i,1) to r(set{i}{j}, 1)
                 % vehicle inx 
                 r_inx = find(allnodes == r_nodes(cvar_set{d_2_inx}(j), 2)); 
                 
                 % OK, to decide where the vehicle should move
                 % the vehicle is on edge, ONLINE DECISION:
                 % [allroutes{d_inx,r_inx}(end),allroutes{d_inx,r_inx}(end-1)]
                 % sample from the edge, if sample < legnth_mean, go end-1                 
                 % v1: r_nodes(set{i}(j), 2)
                 % v2: allroutes{d_inx,r_inx}(end-1)
                 % corresponds to [d_nodes(i,1), r_nodes(set{i}(j),1)]
                 % sample from edge v1,v2
%                  v1v2_len = ve_edge_de{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(2);
%                  v1v2_degree = ve_edge_de{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(3); 
                  
%                  s = normrnd(v1v2_len, v1v2_degree);
%                  ve_edge_de_last_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}...
%                      = [0, v1v2_len, v1v2_degree, s];

                 % if the vehicle can to to next node, d(v1v2) = 0;
                 % update to next edge v2v3
                 v2 = goalroutes{d_inx,r_inx}(end-1);                 
                 if reach_next_time{i}(j) == min_reach_next_time_1 || ...
                         ismember(r_nodes(cvar_set{d_2_inx}(j), 2), [3586727936, 3586727937, 3586727938, ...
                         3586727939, 3586727940, 3586727941])
                     next_move = v2;
                     ve_edge_de_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(1) = 0;
                     ve_edge_de_last_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(1) = 0;
                     if v2 ~= d_nodes(i,2)
                         % next edge v2, v3;
                         v3 = goalroutes{d_inx,r_inx}(end-2); 
                         v3v2_inx = find(edges_length_degree(:,1)==v3 & ...
                            edges_length_degree(:,2)==v2,1);
                         len = edges_length_degree(v3v2_inx, 3);
                         degree = edges_length_degree(v3v2_inx, 4);
                         ve_edge_de_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)} = [0 len degree]; 
                     end
                 else
                 % otherwise, stay end, reduce the edge length by sample,
                 % (1-length_mean/sample) * length_mean, same, uncertainty
                 % the vehicle stay on edge v1v2, but be closer to v2
                    % the distance from v1' to v2:
                    d_to_v2 = v1v2_len * (1 - min_reach_next_time_1/reach_next_time{i}(j));
                    % change v1v2_len to v1'v2
                    ve_edge_de_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(2) = d_to_v2;
                    % keep the next move at current node, 
                    next_move = goalroutes{d_inx,r_inx}(end);
                    % but we need to keep track of next node, 
                    % becasuse the vehicle is not going to turn back
                    % the lengh should be v1'v2 + v2 onwards... 
                    % so keep v2.
                    % indicate v2 is not arrived yet, arrive v1', keep v2
                    ve_edge_de_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(1) ...
                        = goalroutes{d_inx,r_inx}(end-1);
                    ve_edge_de_last_1{d_inx, r_nodes(cvar_set{d_2_inx}(j),1)}(1) = 1; 
                 end   
                 % check if next_move is the same as the demand
                 % remove the vehicle and the demand
                 if next_move == d_nodes(i,2) 
                     reach_demand_i = 1; 
%                      reach_demand_j(cvar_set{d_2_inx}(j))=1;
%                  else % not reach the demand, make nxet move
                 end
                 %update r_full_nodes, r: r_nodes(set{i}(j), 1)
                 r_nodes_1(cvar_set{d_2_inx}(j), 2) =  next_move; 
                 %rnodes_full_1(r_nodes(cvar_set{d_2_inx}(j), 1)) = next_move;
             end
             if reach_demand_i == 1
                 %calculated how many demands have been served
                 num_d_served =  length(d_nodes(:,1)) - length(d_nodes_1(:,1));
                 d_nodes_1(i-num_d_served, :) = [];
             end
         end 
%          for r = 1 : length(reach_demand_j)
%              if reach_demand_j(r) == 1
%                  r_nodes_1(r,:)=[]; 
%              end
%          end
end