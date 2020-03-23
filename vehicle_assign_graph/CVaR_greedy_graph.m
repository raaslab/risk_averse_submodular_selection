% cvar greedy for multi-vehicle assignment
function [cvar_gre_set] = ...
    CVaR_greedy_graph(routes_effi_samp, alpha, delta, n_s, upper_bound)
%cvar_gre_distribution

    [~,~,n_goal,n_robot] = size(routes_effi_samp);

    % the number of tau(s)
    n_tau = round(upper_bound/delta);
    if n_tau > 1000
        n_tau = 1000;
    end
    
    %store tau and hvalue
    tau_hvalue = zeros(n_tau, 1);
   
    %store the upper bound of H* 
    tau_hstar = zeros(n_tau, 1); 
    
    %store the greedy selected set at each tau, the data is a nx1_tau cell
    alltau_greset = cell(n_tau, 1); 
    
    % a counter 
    cnt = 1;
    for tau = delta : delta : upper_bound       
        % since we need to assign a set of sensors S_i to each demand
        % location i. we need to keep each S_i separately. 
         
        %/*** Greedy Algorithm ***/ 
        % create gre_set to store S_i (s) at each tau 
        gre_set = cell(n_goal, 1); 
        % since we will assign all the taxis, the greedy algorithm has 
        % this also indicates the previous set
        
        % keep track of the taxi has been assigned, becaue a taxi can be
        % assigned at most once. 
        gre_selected = [];
        
        % we need to initialize the previous greedy values
        gre_hvalue_last  = tau * (1 - 1/alpha); 
        
        %R rounds
         for r  = 1 : n_robot
              %keep margin gain at each round for each location i 
              %store location i, margin_gain, current_h_value at each round
              %store inx of ij, margin_gain, h_value current at each round
              %of selection
              % this step we calucalte H(SU{i, j}) - H(S), we would like to 
              % separate this into N rows, and R - length(gre_selected)
              % columns
              
              margin_inx = zeros(n_goal, n_robot - length(gre_selected)); 
              margin_gain = zeros (n_goal, n_robot-  length(gre_selected)); 
              hvalue_current = zeros(n_goal, n_robot - length(gre_selected)); 
             
              % N demand locaions
              for i  =  1 : n_goal
                  %R taxis
                  cnt_j = 1; 
                  for  j  = 1 : n_robot  
                      % first check if taxi j has not been selected
                      if ismember(j, gre_selected) == 0 
                          gre_current_ij = H_approximate(gre_set, [i,j], ...
                              tau, routes_effi_samp, alpha, n_s); 
                          margin_hvalue_ij =  gre_current_ij - gre_hvalue_last; 
                      
                          margin_inx(i, cnt_j) = j; 
                          margin_gain(i, cnt_j) = margin_hvalue_ij; 
                          hvalue_current(i, cnt_j) = gre_current_ij;     
                          
                          cnt_j = cnt_j +1; 
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
              
               %update the  gre_hvalue_last     
               gre_hvalue_last = hvalue_current(row_inx, col_inx); 
                            
         end % the end of R round for greedy algorithm    
         
         %store s_i(s) inside it
         alltau_greset{cnt} = gre_set;
         
         % store h_values
         %we simplily add all h_values_s_i together
         %*** this step needs further checking!!!***
         tau_hvalue(cnt) = gre_hvalue_last; 
         
         %calculate the H* value in the partition case
         tau_hstar(cnt) = gre_hvalue_last + (1/2)* tau * (1/alpha -1); 
         
         
        cnt = cnt + 1;     
    end
    % tau_loop ends
    
    
       % we use H_star_values to decide which one to choose 
       % max of the upper bounds
       % we only need the first one
       max_hstar_bound = max(tau_hstar); 
       
       max_Hstar_inx = find(tau_hstar == max_hstar_bound,1); 
   
       % find the associated set we choose, this is a set. 
       cvar_gre_set = alltau_greset{max_Hstar_inx}; 
   
       % find the associated cvar_gre_value by the greedy approach
%        cvar_gre_hvalue = tau_hvalue(max_Hstar_inx);
       
       %calculate the uncertainty, we know that the mean and the
       %uncertainty for poisson distribution are the same. 
       %[cvar_gre_distribution] = efficiency_distribution(cvar_gre_set, efficiency, n_s);
%        [cvar_gre_distribution] = efficiency_distribution(cvar_gre_set, routes_effi_samp, n_s);

end