function H_appro = H_approximate_poisson_sample(set, pair, tau, efficiency, alpha, n_s)
              %note that set is a taxi set s_i for demand location id
              
              %note that pair is [i, j] pair each location i and robot j
              %set is a N*1 cell, contains the assignemnt for each location
              %i.            
              %the submodular funcion is f(S,y): = sum_i max_j\in S_i
              %e_ij.
              
              % update the set 
              set{pair(1)} = [set{pair(1)}, pair(2)];
              
              [tail_samples, ~] = efficiency_distribution_samp(set, efficiency, tau, n_s);
              
              H_appro = tau - (1/alpha) * (1/n_s)* sum(tail_samples);
              
end