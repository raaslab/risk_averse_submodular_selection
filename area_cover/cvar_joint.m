%calculate the joint reward and joint prob of sccuess in cvar test
function [cvar_joint_rewa, cvar_joint_prob] = cvar_joint(set, reward, prob)

          cvar_joint_rewa = 0; 
          cvar_joint_prob =1; 
          
          for i = 1: length(set)              
             cvar_joint_rewa = cvar_joint_rewa + reward(set(i)); 
             cvar_joint_prob = cvar_joint_prob * prob(set(i)); 
          end
end