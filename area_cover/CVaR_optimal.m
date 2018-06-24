%calculate the optimal S given tau and calculate the associated H_value
function [cvar_opt_set, cvar_opt_value] = ...
    CVaR_optimal(vis_binary, alpha, delta, pr_sensor, n_s)


        global N M All_visi
        
        % the upper bound for \tau should be the area of all visibile region. 
        tau_bound = round(All_visi)+1; 
  
        % the number of tau(s), tau_bound/delta+1, for each tau, we calculate
        % the greedily selected set and the cvar 
        n_tau = tau_bound/delta + 1;
        
        %store the associated H_value(s*, \tau) for given tau
        H_star = zeros(n_tau, 1);
        
        %store the optimal set for give tau
        opt_set = zeros(n_tau, M);
       
        %a counter
        cnt  = 1; 
         
         %define a id vector
         sensor_id = zeros(1, N);
       
         for i = 1: N
             
             sensor_id(i) = i; 
             
         end
         
         %evaluate all the possible cases
         % fromN choose M
          N_choose_M = nchoosek(sensor_id, M);
         
         for tau = 0 : delta : tau_bound
             
               
               % an array store H value 
               H_value = zeros(length(N_choose_M),1); 
               %evaluate all the possible cases 
                for i = 1: length(N_choose_M)
                    
                      H_value(i) = H_approximate_bernoulli(N_choose_M(i,:), tau, alpha, vis_binary, pr_sensor, n_s); 
                      
                end
               
                max_inx = find(H_value == max(H_value),1);
                
                 H_star(cnt, 1) = H_value(max_inx);
                 opt_set(cnt, :) = N_choose_M(max_inx, :); 
                
                 cnt = cnt + 1; 
         end
         
         max_inx_final = find(H_star == max(H_star), 1);
         cvar_opt_value = H_star(max_inx_final);
         cvar_opt_set = opt_set(max_inx_final, :); 
         
end