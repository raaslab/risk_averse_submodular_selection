%calculate the area covered by the union set S
% and the joint probability of success

function [u_area, u_p] = union_area_p(set, vis_binary, pr_sensor)
            
          global poly_large

          union_binary = zeros(9*poly_large, 9*poly_large); 
          u_p =1;
          
          for i = 1: length(set)              
             union_binary = union_binary | vis_binary{1, set(i)}; 
             u_p = u_p * pr_sensor(set(i)); 
          end
          
          u_area = bwarea(union_binary)/(poly_large*poly_large); 
     
end 