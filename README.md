# risk_averse_submodular_selection

1, area_cover folder contains risk-averse covering 

    main_file: "visibility_environment"
    subfiles: "CVaR_greedy": Successive Greedy Algorithm
              "H_approximate_bernoulli": calculate the hvalue H(S, tau).
              "uara_distribution": return the distribution of f(S): = union of the visi_region by gre_set
              "sensor_success_bernoulli": retun 2D matrix, (N, n_s) for each sensor i \in {1, ..., N}. 
    
2, multi-robot assignment folder
    
    main file: "multi_robot_assignment": Collect data from the Successive Greedy Algorithm.
    subfiles: "CVaR_greedy": Successive Greedy Algorithm
              "H_approximation_poisson": calculate the hvalue, H(S, tau)
              "efficiency_distribution": return the distribtion of f(S):= \sum_i max_{j} e_{ij}
              "robot_demand_poisson" : "return 4D matrix, (1, n_s, i, j). samples(1,n_s), location i robot j"
                   
3, mobility_on_demand folder
