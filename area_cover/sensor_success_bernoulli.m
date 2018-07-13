%generate the binary sample for each sensor with a success probability
function sensor_success_sample = sensor_success_bernoulli(pr_sensor, n_s)

         global N

         sensor_success_sample = zeros(N, n_s);
         
         for i = 1 : N
             
             sensor_success_sample(i, :) = binornd(1, pr_sensor(i), 1, n_s);
             
         end
         
         

end