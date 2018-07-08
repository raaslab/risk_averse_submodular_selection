% calculate the mean and the uncertainty after obtainting the set 
function  [tail_samples, sum_edem_ns] = efficiency_distribution_samp(set, efficiency, tau, n_s)
     
              sum_edem_ns = zeros(1, n_s);              
              tail_samples = zeros(1, n_s); 
               
              for k = 1 : n_s % n_s sample                  
                  % calculate the max_j e_{ij} for each demand i 
                  max_edem_ns = zeros(length(set), 1);
                  for i = 1 : length(set)
                      % check if set{i} is not empty                   
                      if isempty(set{i}) == 0
                         % search for all the robot j for demand i
                          for j = 1 : length(set{i})                              
                              max_edem_ns(i) = max(max_edem_ns(i), poissrnd(efficiency(i, set{i}(j))));
                              %max_edem_ns(i) = max(max_edem_ns(i), 2^efficiency(i, set{i}(j)))*rand(1);
                          end
                          
                      else 
                          max_edem_ns(i)  = 0; 
                      end                      
                      
                  end
                  sum_edem_ns(k) = sum(max_edem_ns);                   
                  tail_samples(k) = max(tau - sum_edem_ns(i), 0);                 
                                                     
              end %n_s sample end.  
          
end