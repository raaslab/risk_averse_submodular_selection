function uarea_sum = uarea_distribution_sum(set, vis_area, sensor_success_sample, n_s)


        uarea_sum = zeros(1, n_s);
           
            
            for j = 1 : length(set)

               % bernoulli_j can be zero and one. 
               uarea_sum =  uarea_sum + sensor_success_sample(set(j), :)...
                   * vis_area(1, set(j)); 
               
            end
            

end