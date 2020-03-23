% cvar for multi-vehicle assignment
function [cvar_set] = ...
    CVaR_graph(routes_effi_samp, alpha, delta, n_s, upper_bound)

    global n_goal n_robot
    
    % the number of tau(s)
    n_tau = upper_bound/delta + 1; 
    
    %store tau and hvalue
    tau_hvalue = zeros(n_tau, 2);
   
    %store the upper bound of H* 
    tau_hstar = zeros(n_tau, 1); 
    
    %store the greedy selected set at each tau, the data is a nx1_tau cell
    alltau_set = cell(n_tau, 1); 
    
    % a counter 
    cnt = 1;
    for tau = delta : delta : upper_bound       
        % since we need to assign a set of sensors S_i to each demand
        % location i. we need to keep each S_i separately. 
        
        cvar_eachtau = zeros(n_goal, n_robot);
             
              % N demand locaions
              for i  =  1 : n_goal
                  %R taxis
                  for  j  = 1 : n_robot  
                         cvar_eachtau(i,j)  = H_approximate_ij([i,j], ...
                              tau, routes_effi_samp, alpha, n_s); 
                         
                  end %the end of r robots
              end% the end of N demand locations for S_i
              
              %collect all the marginal gains for updating      
              % find the maximum cvar_eachtau
               [row_inx, col_inx] = find(cvar_eachtau == max(cvar_eachtau(:)), 1); 
               
            
             % store h_values
             %we simplily add all h_values_s_i together
             %*** this step needs further checking!!!***
             tau_hvalue(cnt, :) = [tau, max(cvar_eachtau(:))]; 
             
             alltau_set{cnt} =  [row_inx, col_inx];


             cnt = cnt + 1;     
    end
    % tau_loop ends
    
       % find the largest one
       [~, cvar_inx] =  max(tau_hvalue(:,2)); 
       
       cvar_set = alltau_set{cvar_inx};
       
%        %calculate the uncertainty, we know that the mean and the
%        %uncertainty for poisson distribution are the same. 
%        [cvar_distribution] = efficiency_distribution(cvar_set, routes_effi_samp, n_s);
       
end