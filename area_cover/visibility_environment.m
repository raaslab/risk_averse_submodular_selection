%
%=========VisiLibity Demonstration Script=========
%
%This script uses the the MEX-files generated from 
%visibility_polygon.cpp and in_environment.cpp.  Follow 
%the instructions in the respective .cpp files to create
%these MEX-files before running this script. A graphical
%representation of the supplied environment file 
%example1.environment is dislplayed and the user can
%then select points (must be in the environment) with
%the mouse and the visibility polygon of that point will
%be computed and plotted over the environment.
%


%Clear the desk
clear all; close all; clc;
format long;


%Robustness constant
epsilon = 0.000000001;


%Snap distance (distance within which an observer location will be snapped to the
%boundary before the visibility polygon is computed)
snap_distance = 0.05;


%Read environment geometry from file
%environment = read_vertices_from_file('./example1.environment');


% define the environment by hand.
environment = cell(1,10);
environment{1,1} = [0, 0; 9, 0; 9, 9; 0, 9]; % the boundary of the environment, clockwise order
% for all the obstacles, should be counter clockwise order
environment{1,2} = [0.45, 6.9; 0.27, 6.9; 0.27, 7.5; 1.92, 7.5; 1.92, 6.9; 1.755, 6.9; 1.755, 5.85; 0.45, 5.85]; 
environment{1,3} = [0.495, 3.3; 0.495, 4.2; 1.65, 4.2; 1.65, 3.3];
environment{1,4} = [1.995, 6.15; 2.22, 6.15; 2.22, 4.05;  1.995, 4.05];
environment{1,5} = [1.83, 2.85; 2.37, 2.85; 2.37, 1.8; 1.83, 1.8];
environment{1,6} = [3.87, 7.8; 5.58, 7.8; 5.58, 7.125; 5.25, 7.125; 5.25, 7.47; 4.2, 7.47; 4.2, 7.125; 3.87, 7.125];
environment{1,7} = [6.795, 8.46; 8.13, 8.46; 8.13, 8.1; 7.545, 8.1; 7.545, 7.35; 7.62, 7.35; 7.62, 6.675;...
    7.245, 6.675; 7.245, 7.35; 7.14, 7.35; 7.14, 8.1; 6.795, 8.1]; 
environment{1,8} = [3.075, 3.75; 5.595, 3.75; 5.595, 2.85; 3.075, 2.85];
environment{1,9} = [5.265, 1.095; 5.91, 1.17; 5.835, 1.59; 7.275, 1.815; 7.35, 1.38; 7.545, 1.41;...
    7.605, 0.45; 5.325, 0.525]; 
environment{1,10} =[3.075, 6.45; 3.6, 6.45; 3.6, 5.85; 5.925, 5.85; 5.925, 6.45; 6.495,6.45; 6.495, 5.85;...
    7.11, 5.85; 7.11, 4.2; 6.93, 4.2;  6.93, 2.7; 6.225, 2.7; 6.225, 4.2;  6.465, 4.2; 6.465, 4.95; 6.06, 4.95;...
    6.06, 5.325;  4.53, 5.325;  4.53, 4.725; 3.075, 4.725];


%we first calculate the area of the obstacle all the visibility regiion

envi_binary = cell(1,9); 
envi_area = zeros(1,9); 
global All_visi poly_large

%how many times we enlarge the polygon
poly_large = 10; 

for i = 1 : 9 
    %calculate the binary of the environment, 100 times  
    envi_binary{i} = poly2mask(poly_large*[environment{1,i+1}(:,1); environment{1,i+1}(1,1)], ...
        poly_large*[environment{1,i+1}(:,2); environment{1,i+1}(1,2)], 9*poly_large, 9*poly_large); 
    envi_area(1,i) = bwarea(envi_binary{i})/(poly_large^2); 
    
end
sum_envi_area = sum(envi_area); 
All_visi = 9*9-sum_envi_area; 



%Calculate a good plot window (bounding box) based on outer polygon of environment
environment_min_x = min(environment{1}(:,1));
environment_max_x = max(environment{1}(:,1));
environment_min_y = min(environment{1}(:,2));
environment_max_y = max(environment{1}(:,2));
X_MIN = environment_min_x-0.1*(environment_max_x-environment_min_x);
X_MAX = environment_max_x+0.1*(environment_max_x-environment_min_x);
Y_MIN = environment_min_y-0.1*(environment_max_y-environment_min_y);
Y_MAX = environment_max_y+0.1*(environment_max_y-environment_min_y);


%Clear plot and form window with desired properties
clf; set(gcf,'position',[200 500 700 600]); hold on;
axis equal; axis off; axis([X_MIN X_MAX Y_MIN Y_MAX]);


%Plot Environment
patch( environment{1}(:,1) , environment{1}(:,2) , 0.1*ones(1,length(environment{1}(:,1)) ) , ...
       'w' , 'linewidth' , 1.0 );
for i = 2 : size(environment,2)
    patch( environment{i}(:,1) , environment{i}(:,2) , 0.1*ones(1,length(environment{i}(:,1)) ) , ...
           'k' , 'EdgeColor' , [0.7 0.7 0.7] , 'FaceColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
end

% fix the initial setting of sensors' positions
%we need to select 5 from 8 sensors to turn them on
global N M 
N = 10; 
M = 3; %choose five
observer = []; 
V = cell(1,N); 
vis_binary = cell(1,N);
vis_area = zeros(1,N);
pr_sensor = zeros(1,N); 


% Randomly generate 8 available obaservaers within [0 8.85]*[0  8.85]
while length(observer)< N
     ran_x = 9 * rand(1); 
     ran_y = 9 * rand(1); 
     if ~in_environment( [ran_x ran_y] , environment , epsilon )    
     else
      observer = [observer; ran_x ran_y]; 
     end
end


for i = 1 : N
    %Plot the observers
    %if i ~= 1 &&  i  ~= 2
    plot3( observer(i,1) , observer(i,2) , 0.3 , ...
           'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );  
    %end   
    %Compute and plot visibility polygon  
    V{1,i} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
    
    %enlarge the polygon by 100 times, so that we can get more accaurate
    %areas. Actually, the larger the more acturate
    vis_binary{1, i} = poly2mask(poly_large*[V{1,i}(:,1); V{1,i}(1,1)], ...
        poly_large*[V{1,i}(:,2); V{1,i}(1,2)], 9*poly_large,9*poly_large);
    %Note that we need to divided it by 10000 so that we can get the true
    %original area
    vis_area(1, i) = bwarea(vis_binary{1, i})/(poly_large^2);
    
    % each sensor successful turn on rate, the more the sensor can see the
    % larger it will fail. pr_sensor is the survival rate.
    pr_sensor(1, i ) = 1- vis_area(1, i)/(All_visi/2); 
    
   
end   


%the upper bound for tau is Visi_region. 

% set an alpha alpha \in (0, 1] user defined probability threshold.
% alpha can chosen
%alpha = 0.05; 

% the separation for tau
delta = 0.5; 

% the sampling times for approximating CVaR
n_s = 200;

%store alpha and the associated data
cvar_gre_hvalue_area_prob = [];

cvar_opt_value_area_pro = [];



for alpha = 0.01 : 0.09 : 1

%CVaR + greedy
[cvar_gre_set, cvar_gre_value, cvar_gre_uarea, cvar_gre_uprob] = ...
    CVaR_greedy(vis_binary, alpha, delta, pr_sensor, n_s);

% % % cvar+ opt
% [cvar_opt_set, cvar_opt_value, probability_sensor] = ...
%     CVaR_optimal(vis_binary, alpha, delta, n_s); 



cvar_gre_hvalue_area_prob = [cvar_gre_hvalue_area_prob; [alpha, cvar_gre_value, ...
    cvar_gre_uarea, cvar_gre_uprob]]; 

% %expectation + opt
%  [expt_opt_set, expt_opt_value] = expectation_optimal(vis_binary, pr_sensor, n_s);
%  
% %expectation + greedy
% [expt_gre_set, expt_gre_value]  = expectation_greedy(vis_binary, pr_sensor, n_s); 



% %cvar + opt data
% [cvar_opt_area_temp, cvar_opt_p_temp] = union_area_p(cvar_opt_set, vis_binary, probability_sensor); 
%  
% 
% cvar_opt_value_area_pro = [cvar_opt_value_area_pro; [alpha, cvar_opt_value, ...
%     cvar_opt_area_temp, cvar_opt_p_temp]]; 


% %expectation + greedy
% [expt_gre_area_temp, expt_gre_p_temp] = union_area_p(expt_gre_set, vis_binary, pr_sensor); 
% expt_gre_area = [expt_gre_area; [alpha, expt_gre_area_temp]]; 
% expt_gre_p = [expt_gre_p; [alpha, expt_gre_p_temp]]; 


% %expectation + optimal
% [expt_opt_area_temp, expt_opt_p_temp] = union_area_p(expt_opt_set, vis_binary, pr_sensor); 
% expt_opt_area = [expt_opt_area; [alpha, expt_opt_area_temp]]; 
% expt_opt_p = [expt_opt_p; [alpha, expt_opt_p_temp]]; 
end

% % %cvar + opt
% figure (5)
% plot(cvar_opt_value_area_pro(:,1), cvar_opt_value_area_pro(:,2), 'r*'); hold on
% 
% figure (6)
% plot(cvar_opt_value_area_pro(:,1), cvar_opt_value_area_pro(:,3), 'bo'); hold on
% 
% figure(7)
% plot(cvar_opt_value_area_pro(:,1), cvar_opt_value_area_pro(:,4), 'm+'); hold on


%cvar+greedy
figure (5)
plot(cvar_gre_hvalue_area_prob(:,1), cvar_gre_hvalue_area_prob(:,2), 'r*'); hold on

figure (6)
plot(cvar_gre_hvalue_area_prob(:,1), cvar_gre_hvalue_area_prob(:,3), 'bo'); hold on

figure(7)
plot(cvar_gre_hvalue_area_prob(:,1), cvar_gre_hvalue_area_prob(:,4), 'm+'); hold on


% %expt + opt
% figure (6)
% plot(expt_opt_area(:,1), expt_opt_area(:,2), 'r*'); hold on
% 
% figure (7)
% plot(expt_opt_p(:,1), expt_opt_p(:,2), 'b'); hold on
% 
% 
% %expt+greedy
% figure (8)
% plot(expt_opt_area(:,1), expt_opt_area(:,2), 'r*'); hold on
% 
% figure (9)
% plot(expt_opt_p(:,1), expt_opt_p(:,2), 'b'); hold on
% 



% %Plot the observers
% plot3( observer(1,1) , observer(1,2) , 0.3 , ...
%            'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'r' );  

% patch( V{2}(:,1) , V{2}(:,2) , 0.1*ones( size(V{2},1) , 1 ) , ...
%         'w',   'EdgeColor' , 'None',   'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 ); 
   

