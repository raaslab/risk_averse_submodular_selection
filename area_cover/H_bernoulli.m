% calculate the H_value by sampling the multi-independent bernoulli
% distribution. 
function H_appro = H_bernoulli(set, tau, alpha,reward, prob, n_s)

         sum_tail_reward = 0; 
           
         for i = 1 : n_s
             
             reward_ns = 0;
             
             for j = 1 : length(set)
                 
                 bernoulli_j = binornd(1, prob(set(j))); 
                 
                 reward_ns = reward_ns + bernoulli_j * reward(set(j)); 
             end
             
             tail_reward = max(0, tau-reward_ns); 
             
             sum_tail_reward = sum_tail_reward + tail_reward;              
             
         end
         
         H_appro = tau - (1/alpha) * (1/n_s) * sum_tail_reward; 

end