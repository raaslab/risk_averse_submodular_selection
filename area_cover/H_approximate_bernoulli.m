% funtion: approximate the value of the auxiliary function H by sampling

function H_appro = H_approximate_bernoulli(set, tau, alpha, vis_binary, pr_sensor, n_s)

     global poly_large
     
     if isempty(set) == 1
         
        H_appro = tau * (1 - 1/alpha);
     
     %else we use sampling method, sample n_s times. Note that it is a
     %multi-independent bernoulli distribution. pr_sensor(i) is the
     %probability and vis_binary(i) is the binary region it can see. Note
     %that we enlarge the vis_polygon by 100 times. So we need to divide it
     %by 10000! to get the area of the origin one. 
     else 
        %sample n_s times 
        
        % sum of max(0, tau-f(s,y)) to calculate the expection 
        sum_tail_area = 0; 
        
        for i = 1 : n_s
            
            % give bernoulli samples for each sensor
            % for each round of sample, there is a binary combination of the
            % sensors, we can union them together. 
            % keep in mind that we enlarge the area by 100 times
            union_binary = zeros(9*poly_large, 9*poly_large); 
            
            for j = 1 : length(set)
               % find the inx of the sensor gre_set(j)
               % find its binary value
               bernoulli_j = binornd(1, pr_sensor(j)); 
               
               % union sensor visbility_area together
               % bernoulli_j can be zero and one. 
               union_binary =  (union_binary) | (bernoulli_j * vis_binary{1, set(j)}); 
               
            end
            
            % after the union, calculate the area
            % keep in mind that we enlarge the popygon 100 times. we need
            % to divide by 10000 for the origina area. 
            area_ns = bwarea(union_binary)/(poly_large^2);
                       
            % we need max{0, tau-f(s,y)}
            tail_area = max(0, tau-area_ns);
                               
            sum_tail_area = sum_tail_area + tail_area; 
           
        end
        
        H_appro = tau - (1/alpha) * (1/n_s) * sum_tail_area; 
        
         
     end
     

end