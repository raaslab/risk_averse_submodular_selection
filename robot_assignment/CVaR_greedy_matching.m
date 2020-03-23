% cvar greedy for multi-robot assignment
function [cvar_gre_set, cvar_gre_distribution, cvar_gre_hvalue, cvar_gre_add,...
    cvar_gre_tau,cvar_gre_curv, tau_hvalue, H_star_value, H_set, ...
    max_hstar_bound] = CVaR_greedy_matching(robot_demand_sample, alpha, delta, ...
    n_s, one_demand_bound)

    global N R
    
    % the upper bound for tau
    tau_bound  = N * one_demand_bound; 
    
    % the number of tau(s)
    n_tau = tau_bound/delta; 
    
    %store the H value
    H_value = zeros(n_tau, 1);
    
    H_curv = zeros(n_tau, 2);
    %store tau and H_value
    tau_hvalue = zeros(n_tau, 2);
   
    %store the upper bound of H* 
    H_star_value = zeros(n_tau, 1); 
    
    %store the greedy selected set at each tau, the data is a nx1_tau cell
    H_set = cell(n_tau, 1); 
    
    % a counter 
    cnt = 1;
    for tau = delta : delta : tau_bound       
        % since we need to assign a set of sensors S_i to each demand
        % location i. we need to keep each S_i separately. 
         
        %/*** Greedy Algorithm ***/ 
        % create gre_set to store S_i (s) at each tau 
        gre_set = cell(N, 1);
%         for k = 1 : N
%             gre_set{k} =k;
%         end
        % since we will assign all the taxis, the greedy algorithm has 
        % this also indicates the previous set
        
        % keep track of the taxi has been assigned, becaue a taxi can be
        % assigned at most once. 
        gre_selected = [];
        
        max_curv = [];
        
        % we need to initialize the previous greedy values
        gre_hvalue_last  = tau * (1 - 1/alpha); 
        
        %R rounds
         for r  = 1 : R
              %keep margin gain at each round for each location i 
              %store location i, margin_gain, current_h_value at each round
              %store inx of ij, margin_gain, h_value current at each round
              %of selection
              % this step we calucalte H(SU{i, j}) - H(S), we would like to 
              % separate this into N rows, and R - length(gre_selected)
              % columns
              
              margin_inx = zeros(N, R - length(gre_selected)); 
              margin_gain = zeros (N, R-  length(gre_selected)); 
              hvalue_current = zeros(N, R - length(gre_selected)); 
              curv = zeros(N, R - length(gre_selected)); 
             
              % N demand locaions
              for i  =  1 : N
                  %R taxis
                  cnt_j = 1; 
                  for  j  = 1 : R  
                      % first check if taxi j has not been selected
                      if ismember(j, gre_selected) == 0 
                          gre_current_ij = H_approximate_poisson(gre_set, [i,j], ...
                              tau, robot_demand_sample, alpha, n_s); 
                          margin_hvalue_ij =  gre_current_ij - gre_hvalue_last; 
                      
                          margin_inx(i, cnt_j) = j; 
                          margin_gain(i, cnt_j) = margin_hvalue_ij; 
                          hvalue_current(i, cnt_j) = gre_current_ij; 
                          curv(i, cnt_j) = 1 - ...
                              margin_hvalue_ij/(gre_current_ij- tau * (1 - 1/alpha)); 
                          
                          cnt_j = cnt_j + 1; 
                      else % skip j

                      end
                  end %the end of r robots
              end% the end of N demand locations for S_i
              
              %collect all the marginal gains for updating      
              % find the maximum margin gain
               [row_inx, col_inx] = find(margin_gain == max(max(margin_gain)), 1); 
               
               % Then we know, the row_inx is the location, and col_inx is
               %  the taxi j we select
               
               % update the gre_set_i  
               gre_set{row_inx} = [gre_set{row_inx}, margin_inx(row_inx, col_inx)];
               
               % update the gre_set_selected, actually, the union of all gre_set is
               % gre_set_selected
               gre_selected = [gre_selected, margin_inx(row_inx, col_inx)]; 
               
               max_curv = [max_curv, max(curv(:))];              
              
               %update the  gre_hvalue_last     
               gre_hvalue_last = hvalue_current(row_inx, col_inx); 
                            
         end % the end of R round for greedy algorithm    
         
         %store s_i(s) inside it
         H_set{cnt} = gre_set;
         
         % store h_values
         %we simplily add all h_values_s_i together
         %*** this step needs further checking!!!***
         H_value(cnt) = gre_hvalue_last; 
         
         H_curv(cnt, :) = [tau, max(max_curv)]; 
         %store tau_hvalue
         tau_hvalue(cnt, :) = [tau, gre_hvalue_last]; 
         
         %calculate the H* value in the partition case
         H_star_value(cnt) = H_value(cnt); %+ (1/2)* tau * (1/alpha -1);  
                
         cnt = cnt + 1; 
    end
    % tau_loop ends    
    
       % we use H_star_values to decide which one to choose 
       % max of the upper bounds
       % we only need the first one
       max_hstar_bound = max(H_star_value); 
       
       max_Hstar_inx = find(H_star_value == max_hstar_bound,1); 
   
       % find the associated set we choose, this is a set. 
       cvar_gre_set = H_set{max_Hstar_inx}; 
   
       % find the associated cvar_gre_value by the greedy approach
       cvar_gre_hvalue = H_value(max_Hstar_inx);
       
       %calculate the additivity term
       cvar_gre_tau = H_curv(max_Hstar_inx, 1);
       cvar_gre_curv =  H_curv(max_Hstar_inx, 2); 
       cvar_gre_add = cvar_gre_tau*(1/alpha - 1) * ...
           cvar_gre_curv/(1 + cvar_gre_curv);        
       %calculate the uncertainty, we know that the mean and the
       %uncertainty for poisson distribution are the same. 
       [cvar_gre_distribution] = efficiency_distribution(cvar_gre_set, robot_demand_sample, n_s);
       %[~, cvar_gre_distribution] = efficiency_distribution_samp(cvar_gre_set, efficiency, tau, n_s);
end