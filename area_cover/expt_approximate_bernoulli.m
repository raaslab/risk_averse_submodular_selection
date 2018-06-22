% funtion: approximate the value of the expectation

function expt_greedy = expt_approximate_bernoulli(set, vis_binary, pr_sensor, n_s)
              %we want to enlarge the polygon
              global poly_large 
              
               if isempty(set) == 1 
                   
                   expt_greedy = 0; 
                   
               else
                   
                   sum_area = 0; 
                   
                   for i  = 1 : n_s
                   
                       union_binary = zeros(9*poly_large, 9*poly_large);  

                       for j = 1 : length(set)

                           % find the inx of the sensor gre_set(j)
                           % find its binary value
                           bernoulli_j = binornd(1, pr_sensor(set(j))); 

                           % union sensor visbility_area together
                           % bernoulli_j can be zero and one. 
                           union_binary =  (union_binary) | (bernoulli_j * vis_binary{1, set(j)}); 

                       end
                       
                       area_ns = bwarea(union_binary)/(poly_large^2);
                       
                       sum_area = sum_area + area_ns; 
                       
                   end   
                   
                       expt_greedy = sum_area/n_s; 
                       
               end
               
end