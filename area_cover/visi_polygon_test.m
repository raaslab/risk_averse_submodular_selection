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


% %Read environment geometry from file
% environment = read_vertices_from_file('./example1.environment');
% define the environment by hand.
%environment = env; 
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


% % fix the initial setting of sensors' positions
% %we need to select 5 from 8 sensors to turn them on
global N M 
N = 8; 
M = 4; %choose five
observer = []; 
V = cell(1,N); 
vis_binary = cell(1,N);
vis_area = zeros(1,N);
pr_sensor = zeros(1,N); 

% Randomly generate 8 available obaservaers within [0 8.85]*[0  8.85]
while length(observer)< N
     ran_x = 9 * rand(1); 
     ran_y = 9 * rand(1); 
     if ~in_environment([ran_x ran_y] , environment , epsilon)    
     else
      observer = [observer; ran_x ran_y]; 
     end
end


% % manually select some good coordinates for the observers to make sure less
% % redundant overlapping.
% observer = [0.275 6.7; 1.40 5.05; 5.2 7.3; 4.96 5.25; 7.3 0.18; ...
% 5.0 2.5; 7.368 6.554; 7.534 8.74; 1.5 2.3; 3 5.37];

[~,idx] = sort(observer(:,1)); % sort just the first column
observer = observer(idx,:);   % sort the whole matrix using the sort indices

%%
%Clear plot and form window with desired properties
clf; set(gcf,'position',[200 500 700 600]); hold on;
axis equal; axis off; axis([X_MIN X_MAX Y_MIN Y_MAX]);

%Plot environment
patch( environment{1}(:,1) , environment{1}(:,2) , 0.1*ones(1,length(environment{1}(:,1)) ) , ...
       'w' , 'linewidth' , 1.0 );
for i = 2 : size(environment,2)
    patch( environment{i}(:,1) , environment{i}(:,2) , 0.1*ones(1,length(environment{i}(:,1)) ) , ...
           'k' , 'EdgeColor' , [0.7 0.7 0.7] , 'FaceColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
end

%Plot observer
for i = 1 : 2
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w',   'EdgeColor' , 'None',   'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
end

%Plot observer
for i = 4 : 4
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w', 'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
end


%%
%Clear plot and form window with desired properties
clf; set(gcf,'position',[200 500 700 600]); hold on;
axis equal; axis off; axis([X_MIN X_MAX Y_MIN Y_MAX]);

%Plot environment
patch( environment{1}(:,1) , environment{1}(:,2) , 0.1*ones(1,length(environment{1}(:,1)) ) , ...
       'w' , 'EdgeColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
for i = 2 : size(environment,2)
    patch( environment{i}(:,1) , environment{i}(:,2) , 0.1*ones(1,length(environment{i}(:,1)) ) , ...
           'k' , 'EdgeColor' , [0.7 0.7 0.7] , 'FaceColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
end
%Plot observer
for i = 1 : 3
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 13 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w',   'EdgeColor' , 'None',   'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
end

%Plot observer
for i = 4 : 4
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 9 , 'MarkerEdgeColor' , 'y' , 'MarkerFaceColor' , 'k' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w', 'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
end

%%
%observer(3,:) = [1.250662829961197   2.28627928715806];
%Clear plot and form window with desired properties
clf; set(gcf,'position',[200 500 700 600]); hold on;
axis equal; axis off; axis([X_MIN X_MAX Y_MIN Y_MAX]);

%Plot environment
patch( environment{1}(:,1) , environment{1}(:,2) , 0.1*ones(1,length(environment{1}(:,1)) ) , ...
       'w' , 'EdgeColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
for i = 2 : size(environment,2)
    patch( environment{i}(:,1) , environment{i}(:,2) , 0.1*ones(1,length(environment{i}(:,1)) ) , ...
           'k' , 'EdgeColor' , [0.7 0.7 0.7] , 'FaceColor' , [0.7 0.7 0.7] , 'linewidth' , 1.5 );
end
%Plot observer
for i = 1 : 1
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 13 , 'MarkerEdgeColor' , 'y' , 'linewidth' , 2, 'MarkerFaceColor' , 'r' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w',   'EdgeColor' , 'None',   'FaceColor' , [0.9, 0.5, 0.44] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
end

%Plot observer
for i = 2 : 2
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 13 , 'MarkerEdgeColor' , 'y' , 'linewidth' , 2, 'MarkerFaceColor' , 'b' );

%Compute and plot visibility polygon
V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
    'w',   'EdgeColor' , 'None',   'FaceColor' , [0.529, 0.808, 0.98] , 'linewidth' , 1.0 );
       %'r' , 'linewidth' , 1.5 );
% plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%        'b*' , 'Markersize' , 5 );
%[0.529, 0.808, 0.98]
end

%Plot observer
for i = 3 : 3
plot3( observer(i,1) , observer(i,2) , 0.3 , ...
       'o' , 'Markersize' , 13 , 'MarkerEdgeColor' , 'y' , 'linewidth' , 2, 'MarkerFaceColor' ,  [0.196,0.804,0.196]);

% %Compute and plot visibility polygon
% V{1} = visibility_polygon( [observer(i,1) observer(i,2)] , environment , epsilon , snap_distance );
% patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%     'w',   'EdgeColor' , 'None',   'FaceColor' , [0.565, 0.933, 0.565] , 'linewidth' , 1.0 );
%        %'r' , 'linewidth' , 1.5 );
% % plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
% %        'b*' , 'Markersize' , 5 );
end

