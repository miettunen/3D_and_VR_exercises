% Your implementation should run by executing this m-file ("run LW1.m"), 
% but feel free to create additional files for your own functions
% Make sure it runs without errors after unziping
% This file is for guiding the work. You are free to make changes that suit
% you.

% Fill out the information below

% Group members:
% Tasks Completed: 




%% Task A:  Apply transformation on point and visualize  [mandatory]

%create point cloud 
Points=pointCloud([0 0 3; 5 0 5; 2.5 2.5 0]);


%create transformation
t = [0 2 3];
r = [20 50 40];

x = r(1);
y = r(2);
z = r(3);
R_x = [1 0 0; 0 cos(x) -sin(x); 0 sin(x) cos(x)];
R_y = [cos(y) 0 sin(y); 0 1 0; -sin(y) 0 cos(y)];
R_z = [cos(z) -sin(z) 0; sin(z) cos(z) 0; 0 0 1];

R = R_x*R_y*R_z;

P_t1 = rigidTransform(Points.Location(1, :), R, t);
P_t2 = rigidTransform(Points.Location(2, :), R, t);
P_t3 = rigidTransform(Points.Location(3, :), R, t);

PointsMoved = pointCloud([P_t1; P_t2; P_t3]);

%Visualize the point cloud piar
f2=figure;pcshowpair(Points,PointsMoved, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',200);
offset=.2;
hold on, text(Points.Location(:,1)+offset,Points.Location(:,2)+offset ,Points.Location(:,3)+offset,num2str([1:Points.Count]'));
hold on, text(PointsMoved.Location(:,1)+offset, PointsMoved.Location(:,2)+offset ,PointsMoved.Location(:,3)+offset,num2str([1:PointsMoved.Count]'));

title('Original and Transformed points');
xlabel('X (unit)');
ylabel('Y (unit)');
zlabel('Z (unit)');


%% Task B: Estimate homogenous transformation [rotation and translation] between original and transformed point cloud of task A [mandatory]
% First run task A to get data for this task B

%data from task A
pts=Points.Location; %reference points
ptsMoved=PointsMoved.Location; % Points to align to reference

% Estimate the transformation [R,t]

[R,t] = estimateRT_pt2pt(pts, ptsMoved);

% Transform

pts_estimated = rigidTransform(ptsMoved, R, t);

ptsAlligned = pointCloud(pts_estimated);

% Visualize
figure,pcshowpair(Points,ptsAlligned, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',200)
hold on, text(Points.Location(:,1),Points.Location(:,2) ,Points.Location(:,3),num2str([1:Points.Count]'))
hold on, text(ptsAlligned.Location(:,1), ptsAlligned.Location(:,2) ,ptsAlligned.Location(:,3),num2str([1:ptsAlligned.Count]'))
title('tranformed and merged Point clouds')

% Find the error (RMSE)
err = Points.Location - ptsAlligned.Location;
err = err .* err;
err = sum(err(:));
rmse = sqrt(err/ptsAlligned.Count);


%% Task C: Create a function to iteratively allign bunny ptsMoved point cloud  to the reference [mandatory]
%load dataset
load('Supplements/Data and Demos/bunny.mat')
iterations = 30;

% extract points
pts = bunny.Location;
ptsMoved = bunnyMoved.Location;

% Set parameters
DownsampleStep=0.3; % can be changed
visualize=true;

%Perform ICP
[bunny_estR,bunny_estt, bunny_aligned]=ICP(pts, ptsMoved, DownsampleStep, iterations, visualize);


%% Task D: Add an adaptive Stop Criterion to task C [+1]

%load dataset
load('Supplements/Data and Demos/bunny.mat')

% extract points
pts=bunny.Location;%reference points
ptsMoved=bunnyMoved.Location; %Points to align to reference

% Set parameters
DownsampleStep=0.0015; % can be changed
tolerance=[0.1, 0.1];  % can be changed
visualize=true;

iterations = 1000;
consecutive_criterion = 0;
bunny_estR_old = zeros(3,3);
bunny_estt_old = zeros(3);

bunnyAlligned = pointCloud([0, 0, 0]);
for iter = 1:iterations
    
    %Perform ICP
    [bunny_estR_new,bunny_estt_new]=ICP(pts, ptsMoved, DownsampleStep);
    sum(abs(bunny_estR_new - bunny_estR_old), 'all')
    if sum(abs(bunny_estR_new - bunny_estR_old), 'all') < tolerance(1) && sum(abs(bunny_estt_new - bunny_estt_old), 'all') < tolerance(2)
        consecutive_criterion = consecutive_criterion + 1;
    else
        consecutive_criterion = 0;
    end
    bunnyAlligned=pointCloud(rigidTransform(ptsMoved, bunny_estR_new, bunny_estt_new));
    if consecutive_criterion == 3
        break
    end

    ptsMoved = bunnyAlligned.Location;
    bunny_estR_old = bunny_estR_new;
    bunny_estt_old = bunny_estt_new;
end

figure, pcshowpair(bunny,bunnyAlligned, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',100)
title(['Converged on the iteration ', num2str(iter)])



%% Task E:	Registration and Stitching of multiple Point Clouds [+1]

%load dataset
load('FabLab_scans.mat')

starting_image = 1;

% Set parameters
DownsampleStep=0.2;
mergeSize=0.01;  %sets the parameter for pcmerge function to merge 2 points if they are assumed to be same.
visualize= false;
iterations = 30;

%visualize first pointcloud 
Map=FabLabm{starting_image};

%open up a figure to display and update
f=figure;
hAxes = pcshow(Map, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down');
title('Stiched Scene');

% Set the axes property for faster rendering
hAxes.CameraViewAngleMode = 'auto';
hScatter = hAxes.Children;

% To initialize the pipeline
newPtCloud=FabLabm{starting_image};
Rs(:,:,1)=eye(3);
ts(:,1)=[0 0 0]';


for i = starting_image+1:length(FabLabm)
       
    % Use previous  point cloud as reference.
    referencePtCloud = newPtCloud;
    
    % get new point cloud which you want to register to the previous point cloud
    newPtCloud = FabLabm{i};
    
    % Apply ICP registration.
    [estR,estt, aligned]=ICP(referencePtCloud.Location, newPtCloud.Location, DownsampleStep, iterations, visualize);
    
    %Accumulate the transformations as shown in Task A and as used inside the ICP function
    Rs(:,:,i) = estR;
    ts(:,i) = estt;
    
    % Transform the current/new point cloud to the reference coordinate system
    % defined by the first point cloud using the accumulated transformation.  
    ptsAligned = newPtCloud.Location;
    for j = 1:length(Rs)
        ptsAligned = rigidTransform(ptsAligned, Rs(j), ts(j));
    end
    ptCloudAligned = pointCloud(ptsAligned);
    
    ptCloudAligned.Color=newPtCloud.Color;
    referencePtCloud = ptCloudAligned;
    
    % Merge the newly alligned point cloud into the global map to update
    Map = pcmerge(ptCloudAligned, Map, mergeSize);

    % Visualize the world scene.
    hScatter.XData = Map.Location(:,1);
    hScatter.YData = Map.Location(:,2);
    hScatter.ZData = Map.Location(:,3);
    hScatter.CData = Map.Color;
    drawnow('limitrate')

end
    figure(f)
    
%% Task F: Create a function to iteratively alligns bunny ptsMoved based on distance and colour [+1]

%load dataset
load('slab.mat')

% extract points
pts=slab1.Location;%reference points
ptsMoved=slab2.Location; %Points to align to reference

% Set parameters
DownsampleStep=0.3;
tolerance=[0.001, 0.001];
visualize=true;

% For testing here, we donot use colour as input. The default distance based ICP is used
useColour=false;
[slab_estR,slab_estt]=ICP(); % colour input only used for visualization

% Use colour assisted ICP
useColour=true;
[slab_estR,slab_estt]=ICP();% colour used both for visualization and estimation


%% Task G: Create a function to iteratively allign  bunny ptsMoved using point-2-plane metric [+1]
%load dataset
load('bunny.mat')

% extract points
pts=bunny.Location;%reference points
ptsMoved=bunnyMoved.Location; %Points to align to reference

% Set parameters
tolerance=[0.001, 0.001];
DownsampleStep=0.0015;
useColour=false;
visualize=true;

% compare the convergence both metrics in terms of iterations and final error
[bunny_estR,bunny_estt,err_pt]=ICP(); % point-to-point method
[bunny_estR,bunny_estt,err_pl]=ICP(); % point-to-plane method


