% % build a table of the expecatation of choosing maximium sample from the
% indepenent poisson distribution
function groutes_effi_samp = presample_uniform(routes_length, routes_degree, n_s)
    %the number of demand locaitons N and supplying robots M
    %for each (location, robot) pair, we give n_s sampling
    
    [n_goal, n_robot] = size(routes_length); 
       
    % find the 2nd smallest element in routes_length
%     small_2nd = min(setdiff(routes_length(:),min(routes_length(:))));
   
    groutes_effi_samp = zeros(1, n_s, n_goal, n_robot);                
        for i = 1 : n_goal            
            for j = 1 : n_robot
%                 sample_temp = zeros(1, n_s);
                
%                 for k = 1 : n_s
%                     % do some manupliation of the mean and variance. 
%                     % effi_mean: 10/routes_length variance: 10*routes_degree
%                     if routes_length(i,j) ~=0
%                         r1 = normrnd((max(routes_length(:))/routes_length(i,j)), ...
%                             routes_degree(i,j));
%                     else
%                         r1 = max(routes_length(:))/(0.01*small_2nd);
%                     end
%                     if r1>=0
%                          sample_temp(k) = r1;
%                     else
%                          sample_temp(k) = 0;
%                     end
%                 end
                groutes_effi_samp(:, :, i, j) = routes_length(i,j) + routes_degree(i,j) * rand(1, n_s); 
                groutes_effi_samp(:, :, i, j) = max(routes_length(:))./groutes_effi_samp(:, :, i, j);
            end
        end        
end