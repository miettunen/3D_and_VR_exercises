%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality
%
%
% Your implementation should run by executing this m-file ("run LW3.m"), 
% but feel free to create additional files for your own functions
% Make sure it runs without errors after unzipping
%
% Group members:
% Additional tasks completed (2.4, 2.5, 2.6, 2.7, 2.8): 2.4, 2.5, 2.6, 2.7
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

%Transform the model:          
model2 = cube;
%Scale factor
scale = 0.05;
%Rotation matrix
rotation = rotX(35) * rotY(180) * rotZ(60);
%Translation vector
translation = [0, 0.1, 0.4];
%Apply transformations
model2.vertices = model2.vertices .* scale;
model2.vertices = rotation * model2.vertices;
model2.vertices = model2.vertices + translation';

%Transform the model:          
model3 = cube;
%Scale factor
scale = 0.03;
%Rotation matrix
rotation = rotX(23) * rotY(180) * rotZ(97);
%Translation vector
translation = [-0.05, 0.12, -0.1];
%Apply transformations
model3.vertices = model3.vertices .* scale;
model3.vertices = rotation * model3.vertices;
model3.vertices = model3.vertices + translation';


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

%% Perspective projection and Painter's algorithm/additional models - Task 2.2, 2.5

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

scene_sorted = sort_models(scene, viewer.R, viewer.T);
figure(2);
for(k=1:length(scene))
    
    %Project
    XYZ_data = scene{k}.vertices;
    screen.uv(k) = { Project3DTo2D(XYZ_data, screen.K, viewer.R, viewer.T) };
    
    
    %Draw scene
    subplot(2,2,[1,3]);
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
    subplot(2,2,2)
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
    
    XYZ_data = scene_sorted{k}.vertices;
    screen_sorted.uv(k) = { Project3DTo2D(XYZ_data, screen.K, viewer.R, viewer.T) };
    
    %Draw projected scene - virtual display - painter's algorithm
    subplot(2,2,4)
    plot(screen.uv{k}(1,:), screen.uv{k}(2,:), '.', 'MarkerSize', 20);
    set(gca, 'YDir', 'reverse');
    hold on;
    scene_sorted{k}.connectivity = sort_polygons(scene_sorted{k}.vertices, scene_sorted{k}.connectivity, viewer.R, viewer.T);
    for c = 1:size(scene_sorted{k}.connectivity, 2)
        t1 = scene_sorted{k}.connectivity;
        patch(  'Faces', [1 2 3], ...
            'Vertices', [screen_sorted.uv{k}(:,scene_sorted{k}.connectivity(1, c)), ...
            screen_sorted.uv{k}(:,scene_sorted{k}.connectivity(2, c)), ...
            screen_sorted.uv{k}(:,scene_sorted{k}.connectivity(3, c))]', ...
            'FaceColor', scene_sorted{k}.color(:,c), ...
            'EdgeColor', 'none');
    end
    title("Additional models and Painter's algorithm - Task 2.5");
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

x1 = linspace(0, 0.3, 10);
x2 = linspace(0.3, -0.3, 20);
x = [x1 x2];
viewer_location = [ 0.5, screen_size(2)/2, -dist_from_screen]; % [X,Y,Z]
f1 = figure(3);
for i=1:length(x)
    if ishandle(f1)
        clf(f1);
        
        viewer_location = [ x(i), screen_size(2)/2, -dist_from_screen]; % [X,Y,Z]
        viewer_R = eye(3);
        viewer_T = -viewer.Location*viewer_R;
        scene_sorted = sort_models(scene, viewer_T, viewer_T);
        for k=1:length(scene)
            change_viewpoint(scene_sorted{k}, viewer_location, screen);
        end
        drawnow limitrate;
    end
end





%% Accessing Kinect and jitter stabilisation - Task 2.4 & 2.6
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

% Synthetic setup
delta_xyz = zeros(3, length(depthFrames));
delta_xyz_filt = zeros(3, length(depthFrames));
points_raw_x = zeros(1, length(depthFrames));
points_raw_y = zeros(1, length(depthFrames));
points_filt_x = zeros(1, length(depthFrames));
points_filt_y = zeros(1, length(depthFrames));


plot_len_x = 1:185;


viewer_loc_buffer = zeros(3,2);
buffer_length = length(viewer_loc_buffer);
buffer_ptr = 1;

previous_point_raw = [0 0];
previous_point_filt = [0 0];

h = figure(4);
previous_depth = 0;
img = depthFrames(1);
img_frame = img{1};
img_size = size(img_frame);
format = '%.2f';
for i=1:length(depthFrames)
    if(ishandle(h))
  
        frames = depthFrames(i);
        depthFrame = frames{1};
        
        
        faces = faceTrackingInfo(i);
        faceFrame = faces{1};


        %Draw face tracking data:
        frameCell = struct2cell(faceFrame);
        head_position = [faceFrame.ROI(1) + faceFrame.ROI(3)/2 faceFrame.ROI(2) + faceFrame.ROI(4)/2];        
        head_depth = depthFrame(round(faceFrame.FacePointType_Nose.Position(2)), round(faceFrame.FacePointType_Nose.Position(1)));
        
        z = double(head_depth) * 10^(-3); %/ screen.pixelSize(1);
        x = (z*(head_position(1)))/Dparam.fx;
        y = (z*(head_position(2)))/Dparam.fy;
        
        viewer_loc = [x y -z];
        viewer_loc_buffer(:, buffer_ptr) = viewer_loc;
        
        buffer_ptr = buffer_ptr + 1;
        viewer_loc_filtered = jitter_stabilization(viewer_loc_buffer);
        uv_filt = [-Dparam.fx *(viewer_loc_filtered(1)/viewer_loc_filtered(3)) -Dparam.fy *(viewer_loc_filtered(2)/viewer_loc_filtered(3))];
        
        image_center = [round(img_size(2)/2) round(img_size(1)/2)];
        world_origo = [(z*(image_center(1)))/Dparam.fx (z*(image_center(2)))/Dparam.fy];
        
        
        delta_xyz(:, i) = [x-world_origo(1) y-world_origo(2) -z + 0.5]';
        delta_xyz_filt(:, i) = [viewer_loc_filtered(1)-world_origo(1) viewer_loc_filtered(2)-world_origo(2) viewer_loc_filtered(3)+0.5]';

        points_raw_x(i) = head_position(1);
        points_raw_y(i) = head_position(2);
        points_filt_x(i) = uv_filt(1);
        points_filt_y(i) = uv_filt(2);

        %Draw depth image
        subplot(2,2,1);
        title({['Task 2.4 & 2.6'] ['[X, Y, Z]=[',num2str(x-world_origo(1), format), ',',num2str(-(y-world_origo(2)), format), ',', num2str(-z, format),'] [m]'] }); %#ok<NBRAK>
        UpdateImage('Raw data', depthFrame, [points_raw_x(1:i); points_raw_y(1:i)]');

        subplot(2,2,2);
        title({['Task 2.4 & 2.6'] ['[X, Y, Z]=[',num2str(viewer_loc_filtered(1)-world_origo(1), format), ',',num2str(-(viewer_loc_filtered(2)-world_origo(2)), format), ',', num2str(viewer_loc_filtered(3), format),'] [m]'] });
        UpdateImage('Filtered data', depthFrame, [points_filt_x(1:i); points_filt_y(1:i)]');

        subplot(2,2,3);
        UpdatePlot('Raw motion', plot_len_x(1:i), delta_xyz(:, 1:i)');

        subplot(2,2,4);
        UpdatePlot('Filtered motion', plot_len_x(1:i), delta_xyz_filt(:, 1:i)');

        drawnow;
        

        if buffer_ptr == buffer_length + 1
            buffer_ptr = 1;
        end
        previous_point_raw = head_position;
        previous_point_filt = uv_filt;
        previous_depth = head_depth;
    end
    
end
delete(h);
%Close Kinect
%hd.KinectClose();
clear mex; %free mex/static memory
%% Z-Buffering - Task 2.7

screen.f = [viewer.T(3)/pixel_size(1), viewer.T(3)/pixel_size(2)]; % [fx,fy]
%Screen principal point
screen.pp = [ screen_res(1)/2-viewer.T(1)/pixel_size(1), screen_res(2)/2-(viewer.T(2)/pixel_size(2)+screen_res(2)/2)]; %[cx, cy]
%Screen intrinsic parameters matrix
screen.K = [screen.f(1), 0, screen.pp(1); ...
           0, screen.f(2), screen.pp(2); ...
           0, 0, 1];


[rendered_image, finished_zbuffer] = z_buffer(scene, viewer.Location, screen);
figure(5);
for(k=1:length(scene))
    
    %Project
    XYZ_data = scene{k}.vertices;
    screen.uv(k) = { Project3DTo2D(XYZ_data, screen.K, viewer.R, viewer.T) };
    
    
    %Draw scene
    subplot(2,2,[1,3]);
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
    subplot(2,2,2)
    imshow(finished_zbuffer);
    title("Rendered Z-buffer - Task 2.7");
    axis on;
    xlim([0,screen_res(1)]);
    ylim([0,screen_res(2)]);
    
    
    %Draw projected scene - virtual display - painter's algorithm
    subplot(2,2,4)
    imshow(rendered_image);
    title("Rendered image using Z-buffer - Task 2.7");
    axis on;
    xlim([0,screen_res(1)]);
    ylim([0,screen_res(2)]);
    
end

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

function UpdateImage(TitleName, CData, pts)

    % Function for faster display refresh:

    % only update 'CData' on successive image calls

    % (does not update title or change resolution!)



    % First draw call

    if ~isappdata(gca,'imageHandle')

        imageHandle = imagesc(CData);
        colormap(gray(65536));
        axis image;

        title(TitleName);

        ax = gca; %Get axis handle

        ax.Color = 'k';

        ax.GridColor = 'w';
        
        set(ax, 'XColor', 'black'); set(ax, 'YColor', 'black');

        setappdata(gca,'imageHandle',imageHandle);

        hold on;

        plotHandle = plot(pts(:,1), pts(:,2), '-', 'MarkerSize', 20);
        
        setappdata(gca,'plotHandle', plotHandle);

        hold off;

    % Update CData only

    else

        imageHandle = getappdata(gca,'imageHandle');

        set(imageHandle,'CData',CData);



        plotHandle = getappdata(gca,'plotHandle');

        set(plotHandle,'XData',pts(:,1));

        set(plotHandle,'YData',pts(:,2));

    end

end

function UpdatePlot(TitleName, pts_x, pts_y)

    % Function for faster display refresh:

    % only update 'CData' on successive image calls

    % (does not update title or change resolution!)
    


    % First draw call

    if ~isappdata(gca,'plotHandle')
        
        title(TitleName);

        ax = gca; %Get axis handle
        
        ax.Color = 'w';

        ax.GridColor = 'k';
        xlim([1 180]); ylim([-0.6 0.6]);
        
        set(ax, 'XColor', 'black'); set(ax, 'YColor', 'black');
        

        hold on;
        

        plotHandle1 = plot(pts_x, pts_y(:, 1), '-r');
        setappdata(gca,'plotHandle1', plotHandle1);
        
        plotHandle2 = plot(pts_x, pts_y(:, 2), '-g');
        setappdata(gca,'plotHandle2', plotHandle2);
        
        plotHandle3 = plot(pts_x, pts_y(:, 3), '-b');
        setappdata(gca,'plotHandle3', plotHandle3);
        %legend('\Deltax', '\Deltay', '\Deltaz-0.5');
        hold off;

    % Update CData only

    else
        plotHandle1 = getappdata(gca,'plotHandle1');

        set(plotHandle1,'XData',pts_x);
        set(plotHandle1,'YData',pts_y(:,1));
        
        plotHandle2 = getappdata(gca,'plotHandle2');
        
        set(plotHandle2,'XData',pts_x);
        set(plotHandle2,'YData',pts_y(:,2));
        
        plotHandle3 = getappdata(gca,'plotHandle3');
        
        set(plotHandle3,'XData',pts_x);
        set(plotHandle3,'YData',pts_y(:,3));
        

    end

end