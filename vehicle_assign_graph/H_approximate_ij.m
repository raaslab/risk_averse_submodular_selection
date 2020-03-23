%approximate the h_value of the multi-independent poisson distribution 
function H_appro = H_approximate_ij(set, tau, routes_effi_samp, alpha, n_s)
              %note that set is a taxi set s_i for demand location id
              
              %note that pair is [i, j] pair each location i and robot j
              %set is a N*1 cell, contains the assignemnt for each location
              %i.            
              % the submodular funcion is f(S,y): = sum_i max_j\in S_i
              % e_ij.
                                                                    
              tail_h = max((tau * ones(1, n_s) - ...
                  routes_effi_samp(:,:, set(1), set(2))), zeros(1, n_s)); 
              
              H_appro = tau - (1/alpha) * mean(tail_h); 

end