%approximate the h_value of the multi-independent poisson distribution 
function H_appro = H_approximate(set, pair, tau, routes_effi_samp, alpha, n_s)
              %note that set is a taxi set s_i for demand location id
              
              %note that pair is [i, j] pair each location i and robot j
              %set is a N*1 cell, contains the assignemnt for each location
              %i.            
              % the submodular funcion is f(S,y): = sum_i max_j\in S_i
              % e_ij.
              
              % update the set 
              set{pair(1)} = [set{pair(1)}, pair(2)];
              
              sum_max_demand = efficiency_distribution(set, routes_effi_samp, n_s);        
                                                      
              tail_h = max((tau * ones(1, n_s) - sum_max_demand), zeros(1, n_s)); 
              
              H_appro = tau - (1/alpha) * mean(tail_h); 

end