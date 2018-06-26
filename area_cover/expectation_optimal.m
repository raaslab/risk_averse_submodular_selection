%calculate the optimal S given tau and calculate the associated H_value
function [expt_opt_set, expt_opt_value, area_p_dis] = expectation_optimal(vis_binary, pr_sensor, n_s)
        
        global N M
        
         %define a id vector
         sensor_id = zeros(1, N);
       
         for i = 1: N
             
             sensor_id(i) = i; 
             
         end  
         
         % evaluate all the possible cases
         % fromN choose M
          N_choose_M = nchoosek(sensor_id, M);
          
          %expt_value for each raw
          expt_value =  zeros(length(N_choose_M)); 
          
         
         for i = 1: length(N_choose_M)

               expt_value(i) = expt_approximate_bernoulli(N_choose_M(i,:), vis_binary, pr_sensor, n_s); 

         end          
         
         max_inx = find(expt_value == max(expt_value), 1);
         
         expt_opt_value = expt_value(max_inx);
         expt_opt_set = N_choose_M(max_inx, :); 
         
         % the area_p distribution of the expt_opt_set
         [area_p_dis] = area_p_distribution(expt_opt_set, vis_binary, pr_sensor);
         
         
end