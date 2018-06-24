% Do a simple test of cvar optimization
% we generate N = 8 sensors and each with a reward and probability of
% success. The more reward, the less probability of success it has. Then we
% greedily select 5 from them to maximize the CVaR

%total number of sensors
N = 15;

%select 5 from it. 
M = 4; 

%define reward 
reward = 100* rand(N,1);

%define probability of success
prob = 1 - reward/100;

%%
%the separation of tau
delta = 1; 

%sampling times 
n_s = 200;

%the number of tau(s)
n_tau = round(sum(reward))/delta +1; 


% cvar_combo contains, cvar_set, cvar_value
% different alpha. 
cvar_value_set =[]; 

% cvar_combo contains, cvar_reward, cvar_prob
% different alpha. 
cvar_rewa_prob =[]; 
%the confidence level alpha
for alpha = 0.01 : 0.09 : 1

    %store the H value
    H_value = zeros(n_tau, 1);

    % store the set in the follwoing 5 items
    H_set = zeros(n_tau, M);


    %a counter
    cnt = 1; 

    for tau = 0 : delta : round(sum(reward))

        %set greedy set for each tau to be empty
        gre_set = []; 

        H_last = tau * (1 - 1/alpha);

        for i = 1 : M
            margin_gain = [];

            for j = 1 : N
                    % if sensor j has not been selected yet, we check it
                    if ismember(j, gre_set) == 0

                       H_current_j = H_bernoulli([gre_set, j], tau, alpha, reward, ...
                           prob, n_s);

                       margin_gain_j =  H_current_j - H_last; 

                       margin_gain = [margin_gain; [j, margin_gain_j, H_current_j]];   


                    else % we skip j


                    end           

            end     

                 % find the index of the maximum one from second column marginal_gain 
                   max_margin_gain = max(margin_gain(:,2)); 
                 % we only need one maximumu (, 1)  
                   max_inx = find(margin_gain(:,2) == max_margin_gain, 1);
                 % put the associated sensor j in the greedy set
                   gre_set = [gre_set, margin_gain(max_inx,1)];

                 % H_last_round needs to be updated
                 % updated by the associated H_current_round 
                   H_last  = margin_gain(max_inx, 3); 


        end
            %Note that, H_last at the final selection is exactly the H value given tau and selected S        


            %store cvar
            H_value(cnt, 1) = H_last;

            %store set in the second to end
            H_set(cnt, :) = gre_set;


            cnt = cnt +1;      


    end

    max_inx_tau = find(H_value == max(H_value));

    cvar_value = H_value(max_inx_tau);
    cvar_set = H_set(max_inx_tau, :); 
    
    %joint_reward and the joint probability
    [cvar_joint_rewa, cvar_joint_prob] = cvar_joint(cvar_set, reward, prob);
    
    
    %combo value and set
    cvar_value_set = [cvar_value_set; [alpha, cvar_value, cvar_set]];
    
    %combo 
    cvar_rewa_prob = [cvar_rewa_prob; [alpha, cvar_joint_rewa, cvar_joint_prob]];    
   

end

%cvar_value
figure (1)
plot(cvar_value_set(:, 1), cvar_value_set(:, 2), 'r*');

%joint reward
figure (2)
plot(cvar_rewa_prob(:, 1), cvar_rewa_prob(:, 2), 'bo');


%joint prob
figure (3)
plot(cvar_rewa_prob(:, 1), cvar_rewa_prob(:, 3), 'r.');