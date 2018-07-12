% funtion: approximate the value of the auxiliary function H by sampling

function H_appro = H_approximate_bernoulli(set, tau, alpha, vis_binary, pr_sensor, n_s)    
     
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
        
        [~, tail_area] = uarea_distribution(set, tau, vis_binary, pr_sensor, n_s);
        
        H_appro = tau - (1/alpha) * (1/n_s) * sum(tail_area); 
        
     end
     

end