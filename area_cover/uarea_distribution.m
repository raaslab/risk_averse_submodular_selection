function [area_ns, tail_area] = uarea_distribution(set, tau, vis_binary, pr_sensor, n_s)

        global poly_large

        area_ns = zeros(1, n_s);
        tail_area = zeros(1, n_s);
        
        
        for i = 1 : n_s
            
            % give bernoulli samples for each sensor
            % for each round of sample, there is a binary combination of the
            % sensors, we can union them together. 
            % keep in mind that we enlarge the area by 100 times
            union_binary = zeros(9*poly_large, 9*poly_large); 
            
            for j = 1 : length(set)
               % find the inx of the sensor gre_set(j)
               % find its binary value
               bernoulli_j = binornd(1, pr_sensor(set(j))); 
               
               % union sensor visbility_area together
               % bernoulli_j can be zero and one. 
               union_binary =  (union_binary) | (bernoulli_j * vis_binary{1, set(j)}); 
               
            end
            
            % after the union, calculate the area
            % keep in mind that we enlarge the popygon 100 times. we need
            % to divide by 10000 for the origina area. 
            area_ns(i) = bwarea(union_binary)/(poly_large^2);
                       
            % we need max{0, tau-f(s,y)}
            tail_area(i) = max(0, tau - area_ns(i));
                                          
        end

end