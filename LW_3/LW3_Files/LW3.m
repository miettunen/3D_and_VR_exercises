%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality
%
%
% Your implementation should run by executing this m-file ("run LW3.m"), 
% but feel free to create additional files for your own functions
% Make sure it runs without errors after unzipping
%
% Group members:
% Additional tasks completed (2.4, 2.5, 2.6, 2.7, 2.8):
%
% The tracking system and image rendering should run in real-time (> 1 fps)
%--------------------------------------------------------------------------
%% Model creation - Task 2.1

% Define model (cube):
cube = [];

cube.vertices = [; ...    %X
                 ; ...    %Y
                 ];       %Z

cube.connectivity = [; ... 
                     ; ...
                     ]; 

cube.color = [; ... %R
              ; ... %G
              ];    %B 

%Transform the model:          
model1 = cube;
%Scale factor
scale = 1;
%Rotation matrix
rotation = rotX(0) * rotY(0) * rotZ(0);
%Translation vector
translation = [0,0,0];
%Apply transformations
model1.vertices = model1.vertices .* scale;
model1.vertices = rotation * model1.vertices;
model1.vertices = model1.vertices + translation';


%The scene
scene = {model1, model2, model3};

%Draw scene, triangle-by-triangle
figure(1), cla;
for(k=1:length(scene))
    for c = 1:size(scene{k}.connectivity, 2)
        patch('Faces',[1 2 3], ...
            'Vertices',[scene{k}.vertices(:,scene{k}.connectivity(1, c)), ...
            scene{k}.vertices(:,scene{k}.connectivity(2, c)), ...
            scene{k}.vertices(:,scene{k}.connectivity(3, c))]', ...
            'FaceColor', scene{k}.color(:,c), ...
            'EdgeColor', 'k');
        
        hold on;
        
    end
end

%Draw axes - sensor origin
DrawAxes(eye(3), [0,0,0], 1 ,'Sensor Origin', 0.01, []);

%Set title, axes format, limits, etc
title('Model creation - Task 2.1');
axis image;
grid on;
view(45,36);
xlim([-1.2,1.2]); ylim([-1.2,1.2]); zlim([-1.2,1.2]);  
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');

%% Perspective projection - Task 2.2

%Screen properties:
screen = [];
%Resolution (native resolution)
screen.res = [0, 0]; % [u,v]
%Screen's pixel size - force pixel to be square!  
screen.pixelSize = [ 0, 0]; % [x,y]
%Screen physical size (in meters)
screen.physicalSize = [ 0, 0]; % [x,y]
%Screen 3D coordinates
screen.coord3D = [; ... %X 
                  ; ... %Y
                  ];    %Z

%Screen f (distance from viewer to screen)
screen.f = [ 0, 0]; % [fx,fy]
%Screen principal point
screen.pp = [ 0, 0]; %[cx, cy]
%Screen intrinsic parameters matrix
screen.K = [screen.f(1), 0, screen.pp(1); ...
           0, screen.f(2), screen.pp(2); ...
           0, 0, 1];
%Projected 3D points for each model in the scene       
screen.uv = cell([1, length(scene)]);

%Viewer properties:       
viewer = [];
%Viewer's pose
viewer.Location = [ 0, 0, 0]; % [X,Y,Z]
viewer.Orientation = rotX(0) * rotY(0) * rotZ(0); % Identity matrix => eye(3) 
%Viewer's extrinsic parameters
viewer.R = 0;
viewer.T = 0;   

for(k=1:length(scene))
    
    %Project
    XYZ_data = scene{k}.vertices;
    screen.uv(k) = { Project3DTo2D(XYZ_data, screen.K, viewer.R, viewer.T) };
    
    
    %Draw scene
    subplot(1,2,1);
    for c = 1:size(scene{k}.connectivity, 2)
        patch('Faces',[1 2 3], ...
            'Vertices',[scene{k}.vertices(:,scene{k}.connectivity(1, c)), ...
            scene{k}.vertices(:,scene{k}.connectivity(2, c)), ...
            scene{k}.vertices(:,scene{k}.connectivity(3, c))]', ...
            'FaceColor', scene{k}.color(:,c), ...
            'EdgeColor', 'none');
        
        hold on;
    end
    
    %Draw 3D screen
    line([screen.coord3D(1,:), screen.coord3D(1,1)], ...
         [screen.coord3D(2,:), screen.coord3D(2,1)], ...
         [screen.coord3D(3,:), screen.coord3D(3,1)], ...
         'Color',[0,0,0.3], 'LineWidth', 2);
    
    %Draw axes - sensor origin
    DrawAxes(eye(3), [0,0,0], 1 ,'Sensor Origin', 0.01);
    
    %Draw viewer
    DrawAxes(viewer.Orientation, viewer.Location, 0.2 ,'Viewer', 0.01);
    
    %Set title, axes format, limits, etc
    title('Scene');
    axis image;
    grid on;
    view(33,22);
    xlim([-1.2,1.2]); ylim([-1.2,1.2]); zlim([-1.2,1.2]);
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
    
    
    %Draw projected scene - virtual display
    subplot(1,2,2)
    plot(screen.uv{k}(1,:), screen.uv{k}(2,:), '.', 'MarkerSize', 20);
    set(gca, 'YDir', 'reverse');
    hold on;
    for c = 1:size(scene{k}.connectivity, 2)
        patch(  'Faces', [1 2 3], ...
            'Vertices', [screen.uv{k}(:,scene{k}.connectivity(1, c)), ...
            screen.uv{k}(:,scene{k}.connectivity(2, c)), ...
            screen.uv{k}(:,scene{k}.connectivity(3, c))]', ...
            'FaceColor', scene{k}.color(:,c), ...
            'EdgeColor', 'none');
    end
    title('Perspective projection - Task 2.2');
    axis image;
    xlim([0,0]);
    ylim([0,0]);
    
end

%% Changing viewpoint - Task 2.3










%% Accessing Kinect - Task 2.4
%Add Kinect lib
addpath('./KinectLib/');
%Load calibration data
load KinectCalibData.mat;
%Depth map resolution
nRowsD = 424;
nColsD = 512;
%Depth camera calibration matrix (intrinsics)
KD = [Dparam.fx, 0, Dparam.cx; ...
       0, Dparam.fy, Dparam.cy; ...
       0, 0, 1];

% Kinect stream options:
%   Option 0 --> Colour                 
%   Option 1 --> Depth                  
%   Option 2 --> IR                     
%   Option 3 --> Colour & Depth        
%   Option 4 --> Colour & IR           
%   Option 5 --> Depth & IR            
%   Option 6 --> Colour & Depth & IR    
%   Option 7 --> Body Track             
%   Option 8 --> Depth & Face Track 

option = 8;

%Init Kinect:
hd = KinectInterface(option);
hd = hd.KinectInit();


%Get Kinect data
h = figure;
while(ishandle(h)) %loop until figure is closed
    
    %Grab data
    hd = hd.KinectGetData();
    depthFrame = hd.depthImg;
    faceData = hd.faceTrack;
 
    %If data is available
    if(~isempty(depthFrame) && ~isempty(faceData))
    
        %Draw depth image
        cla;
        imagesc(depthFrame);
        colormap(gray(65536));
        axis image;
        hold on;
        
        %Draw face tracking data:
        frameCell = struct2cell(faceData);
        %Draw ROI
        rectangle('Position',faceData.ROI, 'EdgeColor', 'r', 'LineWidth', 2);
        %Draw facial feature points (eyes, mouth, nose)
        for (i=1:5)
            plot(frameCell{i}.Position(1), frameCell{i}.Position(2), '.g', 'MarkerSize', 20);
        end
        
        
        
        
        
        
        
        %Your code: process frame and face data + update virtual screen
        %data (without or with additional models - Task 2.5) + (jitter 
        %stabilization - Task 2.6) + (Z-buffer rendering - Task 2.7)
        
        
        
        
        
        
    end
    
    drawnow();
end

%Close Kinect
hd.KinectClose();
clear mex; %free mex/static memory

%% Alternative head-tracking system using Kinect  - Task 2.8
%Add Kinect lib
addpath('./KinectLib/');
%Load calibration data
load KinectCalibData.mat;
%Depth map resolution
nRowsD = 424;
nColsD = 512;
%Depth camera calibration matrix (intrinsics)
KD = [Dparam.fx, 0, Dparam.cx; ...
       0, Dparam.fy, Dparam.cy; ...
       0, 0, 1];

% Kinect stream options:
%   Option 0 --> Colour                 
%   Option 1 --> Depth                  
%   Option 2 --> IR                     
%   Option 3 --> Colour & Depth        
%   Option 4 --> Colour & IR           
%   Option 5 --> Depth & IR            
%   Option 6 --> Colour & Depth & IR    
%   Option 7 --> Body Track             
%   Option 8 --> Depth & Face Track 

option = 3;

%Init Kinect:
hd = KinectInterface(option);
hd = hd.KinectInit();

%Get Kinect data
h = figure;
while(ishandle(h)) %loop until figure is closed
    
    %Grab data
    hd = hd.KinectGetData();
    colorFrame = hd.colourImg;
    depthFrame = hd.depthImg;

    [colorFrame, depthFrame] = KinectGetData(handle);
    
    %If data is available
    if(~isempty(colorFrame) && ~isempty(depthFrame))
    
        %Draw depth image
        cla;
        subplot(121)
        imagesc(colorFrame);
        axis image;
        
        subplot(122)
        imagesc(depthFrame);
        colormap(gray(65536));
        axis image;
        
        
        %Your code...
    
    
    
    end
    
    drawnow();
    
end
%Close Kinect
hd.KinectClose();
clear mex; %free mex/static memory


%--------------------------------------------------------------------------
%Functions
%--------------------------------------------------------------------------
function  Rx = rotX(angle) %in degrees
Rx = [1 0 0 ; ...
      0 cosd(angle) -sind(angle); ...
      0 sind(angle) cosd(angle)];
end

function  Ry = rotY(angle) %in degrees
Ry = [cosd(angle) 0 sind(angle); ...
      0 1 0; ...
      -sind(angle) 0 cosd(angle)];
end

function  Rz = rotZ(angle) %in degrees
Rz = [cosd(angle)  -sind(angle) 0; ...
     sind(angle) cosd(angle) 0; ...
      0 0 1];
end