% calculate the mean and the uncertainty after obtainting the set 
function  [mean_uncertain] = efficiency_mean_uncertain(set, efficiency)


               % the demand location id. set is a cell, it contains N rows
               mean_uncertain = 0; 
               for i = 1 : length(set)
                   
                     for j = 1 : length(set{i})
                         
                          mean_uncertain = mean_uncertain + efficiency(i, set{i}(j));
                         
                     end
                   
               end

end
