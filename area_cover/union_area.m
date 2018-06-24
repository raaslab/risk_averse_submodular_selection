%calculate the area covered by the union set S
% and the joint probability of success

function u_area = union_area(set, vis_binary)
            
          global poly_large

          union_binary = zeros(9*poly_large, 9*poly_large); 
           
          for i = 1: length(set)              
             union_binary = union_binary | vis_binary{1, set(i)}; 
        
          end
          
          u_area = bwarea(union_binary)/(poly_large*poly_large); 
     
end 