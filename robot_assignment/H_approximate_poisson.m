%approximate the h_value of the multi-independent poisson distribution 
function H_appro = H_approximate_poisson(id, set, tau, efficiency, alpha, n_s)

              % note that set is a taxi set s_i for demand location id 
              
              sum_tail_h = 0; 

              for i = 1 : n_s 
                 
                 effi_sample = zeros(length(set), 1);    
                 for j = 1 : length(set)
                     
                     %sample from Poisson distribution for each id-set(j)
                     effi_sample(j) = poissrnd(efficiency(id, set(j))); 
                     
                 end
                 max_effi_sample = max(effi_sample); 
                 
                 tail_h  = max(0, tau - max_effi_sample); 
                 
                 sum_tail_h = tail_h + sum_tail_h; 
                  
              end %sampling ends
              
              H_appro = tau - (1/alpha) * (1/n_s) * sum_tail_h; 


end