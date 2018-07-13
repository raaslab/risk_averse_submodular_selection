% funtion: approximate the value of the auxiliary function H by sampling

function H_appro = H_approximate_bernoulli(set, tau, alpha, vis_area, vis_binary, sensor_success_sample, n_s)    
     
     %else we use sampling method, sample n_s times. Note that it is a
     %multi-independent bernoulli distribution. pr_sensor(i) is the
     %probability and vis_binary(i) is the binary region it can see. Note
     %that we enlarge the vis_polygon by 100 times. So we need to divide it
     %by 10000! to get the area of the origin one. 
        
        % sum of max(0, tau-f(s,y)) to calculate the expection 
        
        uarea = uarea_distribution(set, vis_binary, sensor_success_sample, n_s);
        %%use sum directly
        %uarea = uarea_distribution_sum(set, vis_area, sensor_success_sample, n_s);
        
        tail_h = max(tau * ones(1, n_s) - uarea, zeros(1, n_s)); 
        
        H_appro = tau - (1/alpha) * mean(tail_h); 
        

end