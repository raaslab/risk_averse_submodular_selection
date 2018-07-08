function H_appro = H_approximate_poisson_sample_edem(set, pair, tau, efficiency, alpha, n_s)
              %note that set is a taxi set s_i for demand location id
              
              %note that pair is [i, j] pair each location i and robot j
              %set is a N*1 cell, contains the assignemnt for each location
              %i.            
              %the submodular funcion is f(S,y): = sum_i max_j\in S_i
              %e_ij.
              
              % update the set 
              set{pair(1)} = [set{pair(1)}, pair(2)];
              
              max_edem = zeros(1, n_s);
              tail_edem = zeros(1, n_s);
              for k = 1 : n_s
                  % we only focus on the row pair(1)
                  max_edem_ns=0;
                  for j = 1 : length(set{pair(1)})
                      max_edem_ns = max(max_edem_ns, poissrnd(efficiency(pair(1), set{pair(1)}(j))));       
                  end
                  max_edem(k) = max_edem_ns; 
                  tail_edem(k) = max(tau - max_edem(k), 0); 
              end
              
                  
              H_appro = tau - (1/alpha) * (1/n_s) * sum(tail_edem);
              
end