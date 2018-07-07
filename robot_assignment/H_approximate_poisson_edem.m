%approximate the h_value of the multi-independent poisson distribution 
function H_appro = H_approximate_poisson_edem(set, pair, tau, robot_demand_sample, alpha, n_s)
              %note that set is a taxi set s_i for demand location id
              
              %note that pair is [i, j] pair each location i and robot j
              %set is a N*1 cell, contains the assignemnt for each location
              %i.            
              % the submodular funcion is f(S,y): = sum_i max_j\in S_i
              % e_ij.
              
              % update the set 
              set{pair(1)} = [set{pair(1)}, pair(2)];
              
              max_demand = zeros(1, n_s);
              
              for i = 1 : length(set{pair(1)})
                   max_demand = max(max_demand, ...
                       robot_demand_sample(:,:, pair(1), set{pair(1)}(i)));                            
              end
                                                                    
              tail_h = max((tau * ones(1, n_s) - max_demand), zeros(1, n_s)); 
              
              H_appro = tau - (1/alpha) * mean(tail_h); 

end