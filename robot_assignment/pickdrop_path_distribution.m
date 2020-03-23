% pre-compute a sample table of short_path_len
% independent distribution

function short_path_sample = pickdrop_path_distribution(short_path_len, n_s)
    %the number of drop_off locaitons N and pick_up locations M
    %for each (location, robot) pair, we give n_s sampling
    
    global N R
    
    short_path_sample = zeros(1, n_s, N, R); 
    
    % let's first manipulate the 2d path_len matrix short_path_len
    range = max(max(short_path_len(:)));
    efficiency = range./short_path_len;
    max_effi = max(max(efficiency));
               
        for i = 1 : N            
            for j = 1 : R
                    % poisson distribution
%                     short_path_sample(:, :, i, j) =  poissrnd(effi(i,j), 1, n_s);
                    % uniform distribution
%                     short_path_sample(:, :, i, j) =...
%                         (2 * effi(i,j)^2.5/range) .* rand(1, n_s) ...
%                         +(effi(i,j) - effi(i,j)^2.5/range);  
                    % truncated Gaussian distribution
                    pd = makedist('Normal','mu',efficiency(i,j),'sigma',sqrt(max_effi/efficiency(i,j)));
                    t = truncate(pd,0,Inf);
                    short_path_sample(:, :, i, j) = random(t,1,n_s);

            end

        end
        
end