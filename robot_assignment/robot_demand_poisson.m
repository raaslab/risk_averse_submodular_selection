% build a table of the expecatation of choosing maximium sample from the
% indepenent poisson distribution

function robot_demand_sample = robot_demand_poisson(efficiency, n_s)
    %the number of demand locaitons N and supplying robots M
    %for each (location, robot) pair, we give n_s sampling
    
    global N R 
    
    range = max(max(efficiency));
    
    robot_demand_sample = zeros(1, n_s, N, R); 
               
        for i = 1 : N            
            for j = 1 : R
%                 robot_demand_sample(:, :, i, j) =  poissrnd(2^efficiency(i,j), 1, n_s); 
                    robot_demand_sample(:, :, i, j) =...
                        (2 * efficiency(i,j)^2.5/range) .* rand(1, n_s) ...
                        +(efficiency(i,j) - efficiency(i,j)^2.5/range);  
%                 robot_demand_sample(:, :, i, j) =  2^efficiency(i,j) * ones(1, n_s);
            end

        end
        
end