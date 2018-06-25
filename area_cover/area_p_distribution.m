%calculate the distribution of the success
function [area_p_dis] = area_p_distribution(set, vis_binary, pr_sensor)
          
          % Given the gre_set, calculate the distribution of area covered
          % this is a small power set, sensor 1 works, sensor 2 works,
          % sensor 3 works.. sensor 12 23 13, sensor 1 2 3, then the
          % probability and area covered.
          global poly_large
                   
          power_set = PowerSet(set); 
          
          %set the area_p_distribution to be empty_set
          % first item, area_covered, second item, probability
          area_p_dis = zeros(length(power_set), 2); 
          % set/selected set
          area_p_dis(:,2)=1;
          
          for i = 1 : length(power_set)
              
              if isempty(power_set{i}) == 1 
                  area_p_dis(i, 1) = 0;
                  
                  %the probability of all sensor fail
                  for k = 1 : length(set)
                      area_p_dis(i,2) = area_p_dis(i,2) * (1 - pr_sensor(set(k))); 
                  end
                  
              else % power_set{i} is not empty, 
                  
                  %some sensors are successfully working 
                  %calculatet the area_covered by these successful sensors
                  union_binary = zeros(9*poly_large, 9*poly_large);
                  
                  for j = 1 : length(power_set{i})    
                      union_binary = union_binary | vis_binary{1, power_set{i}(j)};
                      area_p_dis(i,2) = area_p_dis(i,2) * pr_sensor(power_set{i}(j)); 
                  end
                  area_p_dis(i, 1) = bwarea(union_binary)/(poly_large*poly_large);
                  
                  %some sensors fail, calculate the probability of failures
                  set_diff_i = setdiff(set, power_set{i}); 
            
                  if isempty(set_diff_i) == 0
                    
                     for k = 1 : length(set_diff_i)
                         area_p_dis(i,2) = area_p_dis(i,2) * (1 - pr_sensor(set_diff_i(k)));
                     end
                  %check if all sensors are successfully working    
                  else
                      
                  end
                  
                                 
              end
              
              
          end
                   
         [~,idx] = sort(area_p_dis(:,1)); % sort just the first column
         area_p_dis = area_p_dis(idx,:);   % sort the whole matrix using the sort indices
          
end