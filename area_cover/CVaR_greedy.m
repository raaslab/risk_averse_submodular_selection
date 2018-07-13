% maximize the CVaR function
% calculate the cvar by a greedy approach

function [cvar_gre_set, cvar_gre_value, uarea_dis] = ...
    CVaR_greedy(vis_binary, alpha, delta, sensor_success_sample, n_s)
   
   %the upper bound for tau is Visi_region. 
   global N M All_visi
   
   % the upper bound for \tau should be the area of all visibile region. 
   tau_bound = round(All_visi)+1; 
  
   % the number of tau(s), tau_bound/delta+1, for each tau, we calculate
   % the greedily selected set and the cvar 
   n_tau = tau_bound/delta + 1;
   
   %store the H value
   H_value = zeros(n_tau, 1);
   
   %store the upper bound of H* 
   H_star_value = zeros(n_tau, 1); 
   
   % store the set in the follwoing 5 items
   H_set = zeros(n_tau, M);
   
    
   %note that tau can be from zero to the tau_bound
   % a counter
   cnt = 1;
   for tau = 0 : delta : tau_bound
        
        %set greedy set for each tau to be empty
        gre_set = []; 
                
        % at each round, H_value at last round is the same. 
        % This value needs to be updated 
        % after we find the set at this round
        H_last = tau * (1 - 1/alpha); 
                
        %greedy approach, it has M rounds
        for i = 1 : M
            
            % use marginal_gain to keep track the sensor index, its
            % marginal gain, and the H_value at each round. Note that, the size of the matix
            % will decrease 1 at each round. 
            margin_gain = [];
                        
            % choose one sensor from N/( already selected) which has the maximum marginal gain 
            for j = 1 : N
                % if sensor j has not been selected yet, we check it
                if ismember(j, gre_set) == 0
                    
                    
                   H_current_j = H_approximate_bernoulli([gre_set, j],...
                       tau, alpha, vis_binary, sensor_success_sample, n_s);

                   margin_gain_j =  H_current_j - H_last; 

                   margin_gain = [margin_gain; [j, margin_gain_j, H_current_j]];   


                else % we skip j


                end

            end
                
             % find the index of the maximum one from second column marginal_gain 
               max_margin_gain = max(margin_gain(:,2)); 
             % we only need one maximumu (, 1)  
               max_inx = find(margin_gain(:,2) == max_margin_gain, 1);
             % put the associated sensor j in the greedy set
               gre_set = [gre_set, margin_gain(max_inx,1)];
               
             % H_last_round needs to be updated
             % updated by the associated H_current_round 
               H_last  = margin_gain(max_inx, 3); 
             

        end
           
        % Note that, H_last at the final selection is exactly the H value given tau and selected S           
        % samething for union_area_last. 
        %store cvar
        H_value(cnt) = H_last;
        
        %store set in the second to end
        H_set(cnt, :) = gre_set;
         
        %after we have the H_value, we can decide which one to choose by
        % 1-1/e for the uniform matroid
        % for each tau we have an upper bound for each H_star_values. (H(s*, iDelta))
        H_star_value(cnt) = H_value(cnt); %+ (1/exp(1))* tau * (1/alpha -1); 
        
        %counter plus 1
        cnt = cnt +1;      
   end
   
   % we use H_star_values to decide which one to choose 
   % max of the upper bounds
   % we only need the first one
   max_Hstar_inx = find(H_star_value == max(H_star_value),1); 
   
   % find the associated set we choose, this is a set. 
   cvar_gre_set = H_set(max_Hstar_inx, :); 
   
   % find the associated cvar_gre_value by the greedy approach
   cvar_gre_value = H_value(max_Hstar_inx);
   
   %calculate disterminstic u_area and u_prob
   %[cvar_gre_uarea, cvar_gre_uprob] = union_area_p(cvar_gre_set, vis_binary, pr_sensor); 
   %[area_p_dis] = area_p_distribution(cvar_gre_set, vis_binary, pr_sensor);
 
   %let's plot the distribution of the union area
   uarea_dis = uarea_distribution(cvar_gre_set, vis_binary, sensor_success_sample, n_s);
end