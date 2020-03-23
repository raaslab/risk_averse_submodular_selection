% calculate the mean and the uncertainty after obtainting the set 
function  sum_max_demand = efficiency_distribution(set, routes_effi_samp, n_s)

        % return the distribution of the f(S,y) = \sum_i max_j e_ij
        % search for all locations
        max_each_demand = zeros(length(set), n_s); 
        
        sum_max_demand = zeros(1, n_s);
        
        for i = 1 : length(set)
                  %for each location, calculate the maximum vector
                  if isempty(set{i}) == 0                      
                      for j = 1 : length(set{i})
                           max_each_demand(i, :) = max(max_each_demand(i, :), ...
                               routes_effi_samp(:,:, i, set{i}(j)));                        
                      end
                      
                  end
                  
                  sum_max_demand = sum_max_demand + max_each_demand(i, :);                         
        end           
end