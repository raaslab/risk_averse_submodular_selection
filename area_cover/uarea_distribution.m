function uarea = uarea_distribution(set, vis_binary, sensor_success_sample, n_s)

        global poly_large

        uarea = zeros(1, n_s);
        
        
        for i = 1 : n_s
            
            % give bernoulli samples for each sensor
            % for each round of sample, there is a binary combination of the
            % sensors, we can union them together. 
            % keep in mind that we enlarge the area by 100 times
            union_binary = zeros(9*poly_large, 9*poly_large); 
            
            for j = 1 : length(set)

               % bernoulli_j can be zero and one. 
               union_binary =  (union_binary) | (sensor_success_sample(set(j), i)...
                   * vis_binary{1, set(j)}); 
               
            end
            
            % after the union, calculate the area
            % keep in mind that we enlarge the popygon 100 times. we need
            % to divide by 10000 for the origina area. 
            uarea(i) = bwarea(union_binary)/(poly_large^2);
                                                                
        end

end