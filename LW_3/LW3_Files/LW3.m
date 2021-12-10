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
%% 
clear;
%LW3_Demo
%% Model creation - Task 2.1
clear;
close all;

% points = [0,0,0; 1,0,0; 0,1,0; 0,0,1; 1,1,0; 1,0,1; 0,1,1; 1,1,1]
%             1       2     3      4      5       6     7      8
% Define model (cube):
cube = [];

cube.vertices = [0 1 0 0 1 1 0 1; ...    %X
                 0 0 1 0 1 0 1 1; ...    %Y
                 0 0 0 1 0 1 1 1];       %Z

cube.connectivity = [1 5 1 6 1 7, 2 8 3 8 4 8; ... 
                     2 2 2 2 3 3, 5 5 5 5 6 6; ...
                     3 3 4 4 4 4, 6 6 7 7 7 7]; 

cube.color = [0.9020    0.2353    1.0000         0    0.9608    0.5686    0.2745    0.9412    0.8235    0.9804         0    0.8627; ... %R
              0.0980    0.7059    0.8824    0.5098    0.5098    0.1176    0.9412    0.1961    0.9608    0.7451    0.5020    0.7451; ... %G
              0.2941    0.2941    0.0980    0.7843    0.1882    0.7059    0.9412    0.9020    0.2353    0.8314    0.5020    1.0000];    %B 

%Transform the model:          
model1 = cube;
%Scale factor
scale = 0.1;
%Rotation matrix
rotation = rotX(10) * rotY(180) * rotZ(15);
%Translation vector
translation = [0, 0.1, 0.2];
%Apply transformations
model1.vertices = model1.vertices .* scale;
model1.vertices = rotation * model1.vertices;
model1.vertices = model1.vertices + translation';

% %Transform the model:          
% model2 = cube;
% %Scale factor
% scale = 0.4;
% %Rotation matrix
% rotation = rotX(6657457) * rotY(5468) * rotZ(25564);
% %Translation vector
% translation = [0, 0, 1.5];
% %Apply transformations
% model2.vertices = model2.vertices .* scale;
% model2.vertices = rotation * model2.vertices;
% model2.vertices = model2.vertices + translation';


%The scene
scene = {model1};

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

% screen_size = [0.527, 0.296];  % tebari
% screen_res = [1920 1080];

screen_size = [0.596, 0.335];    % päätalo
screen_res = [2556 1440];

pixel_size = [screen_size(1)/screen_res(1) screen_size(1)/screen_res(1)];
dist_from_screen = 0.6;



%Screen properties:
screen = [];
%Resolution (native resolution)
screen.res = screen_res; % [u,v]
%Screen's pixel size - force pixel to be square!  
screen.pixelSize = pixel_size; % [x,y]
%Screen physical size (in meters)
screen.physicalSize = screen_size; % [x,y]
%Screen 3D coordinates
screen.coord3D = [screen_size(1)/2, screen_size(1)/2 -screen_size(1)/2 -screen_size(1)/2 ; ... %X 
                  0  screen_size(2) screen_size(2) 0; ... %Y
                  0 0 0 0];    %Z



       
%Projected 3D points for each model in the scene       
screen.uv = cell([1, length(scene)]);

%Viewer properties:       
viewer = [];
%Viewer's pose
viewer.Location = [ 0, screen_size(2)/2, -dist_from_screen]; % [X,Y,Z]
viewer.Orientation = rotX(0) * rotY(0) * rotZ(0); % Identity matrix => eye(3) 
%Viewer's extrinsic parameters
viewer.R = eye(3);
viewer.T = -viewer.Location*viewer.R;

%Screen f (distance from viewer to screen)
screen.f = [viewer.T(3)/pixel_size(1), viewer.T(3)/pixel_size(2)]; % [fx,fy]
%Screen principal point
screen.pp = [ screen_res(1)/2-viewer.T(1)/pixel_size(1), screen_res(2)/2-(viewer.T(2)/pixel_size(2)+screen_res(2)/2)]; %[cx, cy]
%Screen intrinsic parameters matrix
screen.K = [screen.f(1), 0, screen.pp(1); ...
           0, screen.f(2), screen.pp(2); ...
           0, 0, 1];

XYZ = scene{1}.vertices;
uv = Project3DTo2D(XYZ, screen.K, viewer.R, viewer.T);

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
    xlim([0,screen_res(1)]);
    ylim([0,screen_res(2)]);
    
end

%% Changing viewpoint - Task 2.3
screen_size = [0.596, 0.335];    % päätalo
screen_res = [2556 1440];

pixel_size = [screen_size(1)/screen_res(1) screen_size(1)/screen_res(1)];
dist_from_screen = 0.6;

%Screen properties:
screen = [];
%Resolution (native resolution)
screen.res = screen_res; % [u,v]
%Screen's pixel size - force pixel to be square!  
screen.pixelSize = pixel_size; % [x,y]
%Screen physical size (in meters)
screen.physicalSize = screen_size; % [x,y]
%Screen 3D coordinates
screen.coord3D = [screen_size(1)/2, screen_size(1)/2 -screen_size(1)/2 -screen_size(1)/2 ; ... %X 
                  0  screen_size(2) screen_size(2) 0; ... %Y
                  0 0 0 0];    %Z

viewer_location = [ 0.5, screen_size(2)/2, -dist_from_screen]; % [X,Y,Z]
viewer_orientation = eye(3);
change_viewpoint(model1, viewer_location, viewer_orientation, screen);





%% Accessing Kinect - Task 2.4
%Add Kinect lib
addpath('./KinectLib/');

%Load calibration data
load KinectCalibData.mat;
synthetic = true;
if synthetic
    load faceTrackingInfo.mat;
    load depthFrames.mat;
end

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
%hd = KinectInterface(option);
%hd = hd.KinectInit();


%Get Kinect data
h = figure;
while(ishandle(h)) %loop until figure is closed
    
    if ~synthetic % Kinect data
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
        
    else % Synthetic data
            
        for i=1:length(depthFrames)
            if(ishandle(h))
                
                frames = depthFrames(i);
                depthFrame = frames{1};

                faces = faceTrackingInfo(i);
                faceFrame = faces{1};

                %Draw depth image
                cla;
                %imagesc(depthFrame);
                %colormap(gray(65536));
                axis image;
                hold on;

                %Draw face tracking data:
                frameCell = struct2cell(faceFrame);
                %Draw ROI
                r = rectangle('Position',faceFrame.ROI, 'EdgeColor', 'r', 'LineWidth', 2);
                head_position = [r.Position(1) + r.Position(3)/2 r.Position(2) + r.Position(4)/2];
                %plot(head_position(1), head_position(2), '.b', 'MarkerSize', 20);
                
                head_depth = depthFrame(round(head_position(1)), round(head_position(2)));
                
                z = double(head_depth) * 10^(-3); %/ screen.pixelSize(1);
                x = (z*(head_position(1)))/Dparam.fx;
                y = (z*(head_position(2)))/Dparam.fy;
                viewer_loc = [x y z];

                change_viewpoint(model1, viewer_loc, screen);
                %Draw facial feature points (eyes, mouth, nose)
                for (i=1:5)
                    plot(frameCell{i}.Position(1), frameCell{i}.Position(2), '.g', 'MarkerSize', 20);
                end
                drawnow();
                clf;
                
            end
            
            
            
        end

        
    end
     
   %drawnow();   
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