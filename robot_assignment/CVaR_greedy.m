% cvar greedy for multi-robot assignment
function [cvar_gre_set, cvar_gre_hvalue, cvar_gre_uncertain] = CVaR_greedy(alpha, delta, n_s)

    global N R range
    
    % the upper bound for tau
    tau_bound  = range * N; 
    
    % the number of tau(s)
    n_tau = tau_bound +1; 
    
 
    %store the H value
    H_value = zeros(n_tau, 1);
   
    %store the upper bound of H* 
    H_star_value = zeros(n_tau, 1); 
    
    %store the greedy selected set at each tau 
    H_set = cell(n_tau); 
    
   
    % a counter 
    cnt = 1;
    for tau = 0 : delta : tau_bound
       
          
         
        cnt = cnt + 1;     
    end
    % tau_loop ends
    
end