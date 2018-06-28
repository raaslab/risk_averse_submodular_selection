%calculate the distribution of the number of sensor success
function [n_sen_dis] = nsensor_succ_distribution(set, pr_sensor)
            
          %powerset of set 
          power_set = PowerSet(set);
          
          n_sen_dis = zeros(length(set), 2); 
                    
          %how many sensor success 
          for n_sen = 0 : length(set)
              
              n_sen_dis(n_sen+1, 1) = n_sen;
              n_sen_dis(n_sen+1 ,2) = 0; 
              
              for i = 1 : length(power_set)
                  
                  n_sensor_p_temp = 1; 
                  
                  if length(power_set{i}) == n_sen
                      
                        if n_sen == 0 % no sensor successes
                            set_diff = setdiff(set, power_set{i}); 
                            
                            for k = 1 : length(set_diff)
                                n_sensor_p_temp = n_sensor_p_temp * (1 - pr_sensor(set_diff(k)));                             
                            end
                        else % at least one successes
                            
                            for j = 1 : length(power_set{i})
                                
                                n_sensor_p_temp = n_sensor_p_temp * pr_sensor(power_set{i}(j));
                                
                            end   
                             % others fail    
                            set_diff = setdiff(set, power_set{i});                                
                            if isempty(set_diff) == 0

                                for k = 1 : length(set_diff)
                                    n_sensor_p_temp = n_sensor_p_temp * (1 - pr_sensor(set_diff(k)));
                                end

                            end
                                                         
                            
                        end
                            
                            
                      n_sen_dis(n_sen+1 ,2) = n_sen_dis(n_sen+1 ,2) + n_sensor_p_temp;    
                  end
                  
              end
              
          end
          
         
end