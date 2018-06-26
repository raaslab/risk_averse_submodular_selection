%select the set by using greedy with risk-neutral the expectation
function [expt_gre_set, expt_gre_value,...
    area_p_dis]  = expectation_greedy(vis_binary, pr_sensor, n_s)
                         
        %the upper bound for tau is Visi_region. 
        global N M
         
        %set greedy set to be empty
        expt_gre_set = []; 

        % at each round, expt_value at last round is the same. 
        % This value needs to be updated 
        % after we find the set at this round
        expt_last = 0; 
        
        %greedy approach, it has M rounds
        for i = 1 : M
            
            % use marginal_gain to keep track the sensor index, its
            % marginal gain, and the H_value at each round. Note that, the size of the matix
            % will decrease 1 at each round. 
            margin_gain = [];
                        
            % choose one sensor from N/( already selected) which has the maximum marginal gain 
            for j = 1 : N
                % if sensor j has not been selected yet, we check it
                if ismember(j, expt_gre_set) == 0

                   expt_current_j = expt_approximate_bernoulli([expt_gre_set, j], vis_binary, pr_sensor, n_s);

                   margin_gain_j =  expt_current_j - expt_last; 

                   margin_gain = [margin_gain; [j, margin_gain_j, expt_current_j]];   


                else % we skip j


                end

            end
                
             % find the index of the maximum one from second column marginal_gain 
               max_margin_gain = max(margin_gain(:,2)); 
             % we only need one maximumu (, 1)  
               max_inx = find(margin_gain(:,2) == max_margin_gain, 1);
             % put the associated sensor j in the greedy set
               expt_gre_set = [expt_gre_set, margin_gain(max_inx,1)];

             % H_last_round needs to be updated
             % updated by the associated H_current_round 
               expt_last  = margin_gain(max_inx, 3); 

        end
        
             expt_gre_value = expt_last; 
%              %calculate disterminstic u_area and u_prob
%              [expt_gre_uarea, expt_gre_uprob] = union_area_p(expt_gre_set, vis_binary, pr_sensor); 

             %calculate the distribution of area_prob 
             [area_p_dis] = area_p_distribution(expt_gre_set, vis_binary, pr_sensor);

end