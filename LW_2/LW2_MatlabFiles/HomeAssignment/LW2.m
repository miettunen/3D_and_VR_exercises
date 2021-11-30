%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality 
%
%
% Your implementation should run by executing this m-file ("run LW2.m"), 
% but feel free to create additional files for your own functions
% Make sure it runs without errors after unzipping
%
% Fill out the information below
%
% Group members: Antti-Jussi Mäkipää & Teemu Miettunen
% Additional tasks completed (5, 6, 7, 8):
%
% Fill in your implementation at the assigned slots. You can use the 
% existing drawing scripts or draw your own figures. 
% To give an impression of the scope of each task, 
% the number of lines of code in the reference implementation is given
% This is highly subjective depending on coding style, and should not
% be considered as a requirement. Use as much code as you need, but if you
% start having 10 times the lines, you may consider that there might be an
% easier way to do it.
%--------------------------------------------------------------------------

clear;
clc;

% Load synthetic data:
load synthdata

% Load real data:
%   .Depth from Kinect is in "mm";
%   .Translation vector is in "mm";
%   .Intrinsic parameters are in "pixels";
  
% load KinectData.mat
%kinect_data = load('./KinectData.mat');
%Image = imread('./Colour_rect.tif');
%Depth = imread('./Depth_rect.tif');

% LW2_Demo
%% Task 1: Plotting global point cloud (8 lines of code)
% Back projection from PMD image plane to global space
figure;
subplot(2,1,1), imshow(Image);
subplot(2,1,2), imshow(Depth, []);


[u,v] = meshgrid(1:size(Depth,2), 1:size(Depth,1));


u_center = u - max(u, [], 'all')/2;
v_center = v - max(v, [], 'all')/2;

z =((Dparam.f/Dparam.pixelsize)*Depth)./sqrt((Dparam.f/Dparam.pixelsize)^2+u_center.^2+v_center.^2);
%mesh(u,v,z)
x = (z.*(u_center))/(Dparam.fx/Dparam.pixelsize);
y = (z.*(v_center))/(Dparam.fy/Dparam.pixelsize);

min(z, [], 'all');

x = reshape(x.', 1, []);
y = reshape(y.', 1, []);
z = reshape(z.', 1, []);
X = [x;y;z];

% Plotting
figure; hold on;
scatter3(X(1, :), X(2, :), X(3, :), 10, X(3, :));
colormap jet; colorbar;
scatter3(0, 0, 0, 500, 'gx', 'LineWidth', 2)
title('Task 1: Point cloud in global (x,y,z) space');
set(gca,'YDir','reverse');
set(gca,'ZDir','reverse');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal
drawnow;
%% Task 2: Projection to color camera image plane (5 lines of code)

X_proj = R*X + T;
u_colorcam = ((Cparam.fx/Cparam.pixelsize)*(X_proj(1,:))./X_proj(3,:))+Cparam.cx;
v_colorcam = ((Cparam.fy/Cparam.pixelsize)*(X_proj(2,:))./X_proj(3,:))+Cparam.cy;
z_colorcam = X_proj(3,:);

% Plotting
figure; axis equal
imshow(Image, []); hold on; %#ok<*NODEF>

% Only drawing the objects in front to check alignment
objectmask = z_colorcam<13;
sc = scatter(u_colorcam(objectmask), v_colorcam(objectmask), 10, z_colorcam(objectmask), 'filled');
sc.MarkerEdgeAlpha = 0.2;
sc.MarkerFaceAlpha = 0.2;
title( 'Task 2: Global depth points projected on image plane of the color camera');
drawnow;

%% Task 3: Resampling projected data (3 lines of code)




F = scatteredInterpolant(double(u_colorcam'), double(v_colorcam'), double(z_colorcam'), 'nearest');
z_colorcam_reg = F(u', v');
z_colorcam_reg = reshape(z_colorcam_reg, [640, 480])';

% Plotting
figure;
subplot( 131); imshow( Image, []); title('Task 3: Original color image')
subplot( 132); imshow( z_colorcam_reg, []); title('Task 3: Resampled depth image');
subplot( 133); imshowpair( Image, z_colorcam_reg); title('Task 3: Resampled depth on original color')

%% Task 4: Visualizing combined depth/color data

% Well, actually, this one is just plotting so you're done already
figure; 
surf(z_colorcam_reg, double(Image), 'EdgeColor', 'none')
set(gca,'ZDir','reverse');
set(gca,'YDir','reverse');
title( 'Task 4: 3D mesh generated from resampled depth')
drawnow;

%% Task 5: Artifact removal (6 lines of code)

% Just plotting here, add your implementation to the edgeRemoval.h function
figure; 
h = surf(z_colorcam_reg, double(Image), 'EdgeColor', 'none');
set(gca,'ZDir','reverse');
set(gca,'YDir','reverse');
title( 'Task 5: 3D mesh generated from resampled depth with edge artifacts removed')
edgeRemoval(h);


%% Task 6: Color resampling (4 lines of code)

u_something = reshape(u_colorcam, [640,480])';
v_something = reshape(v_colorcam, [640,480])';

red_ch = interp2(u, v, Image(:,:,1), u_something, v_something,'nearest');
green_ch = interp2(u, v, Image(:,:,2), u_something, v_something,'nearest');
blue_ch = interp2(u, v, Image(:,:,3), u_something, v_something,'nearest');


resampledColorImage = cat(3, red_ch, green_ch, blue_ch);
z_something = reshape(z_colorcam, [640,480])';

% Plotting
figure; 

subplot( 231); imshow( Image, []); title('Task 3: Original color image')
subplot( 232); imshow( z_colorcam_reg, []); title('Task 3: Resampled depth image');
subplot( 233); imshowpair( Image, z_colorcam_reg); title('Task 3: Resampled depth on original color')

subplot( 234); imshow( resampledColorImage, []); title('Task 6: Resampled color image')
subplot( 235); imshow( z_something, []); title('Task 6: Original depth image');
subplot( 236); imshowpair( resampledColorImage, z_something); title('Task 6: Resampled color on original depth')
drawnow;



%% Task 7: Z-buffering (19 lines of code)





% Plotting
figure;
subplot(131);
scatter(u_colorcam(:)', v_colorcam(:)', 10, z_colorcam)
ylim([0 size(Depth, 1)]); xlim([0 size(Depth, 2)]);
title( 'Irregular'); 
set(gca,'YDir','reverse'); 
axis image; 
drawnow;

subplot(132);
axis equal
scatter(uc(:), vc(:), 10, z_colorcam_reg(:))
ylim([0 size(Depth, 1)]); xlim([0 size(Depth, 2)]);
title( 'Regular'); 
set(gca,'YDir','reverse'); 
axis image; 
drawnow;

subplot(133);
axis equal
scatter(uc(:), vc(:), 10, z_colorcam_reg_zbuf(:))
ylim([0 size(Depth, 1)]); xlim([0 size(Depth, 2)]);
title( 'Regular z-buffered');
set(gca,'YDir','reverse'); 
axis image; 
drawnow;

figure; 
subplot(231); imshow( z_colorcam_reg, []);
title( 'Task 7: Depth data resampled into a regular grid ');
subplot(234); imshow( z_colorcam_reg_zbuf, []);
title( 'Task 7: Depth data resampled into a regular grid after Z-buffering');
subplot(2, 3, [2 3 5 6]); h = surf(z_colorcam_reg_zbuf, double(Image), 'EdgeColor', 'none');
set(gca,'ZDir', 'reverse')
set(gca,'YDir','reverse');
title( 'Task 7: Z-buffering 3D mesh generated from resampled depth')
edgeRemoval(h);
drawnow;
%% Task 8: Occlusion handling (14 lines of code)



% Plotting
figure;
scatter3(u_colorcam, v_colorcam, z_colorcam(:), 10, z_colorcam(:));
hold on;
plot(planeModel)
scatter3(u_missing, v_missing, z_missing, 50, 'gx');
set(gca,'YDir','reverse');
set(gca,'ZDir','reverse');
title('UVZ-point cloud with the plane fit (red) and missing pixels (green)')
drawnow;


figure; 
subplot(231); imshow( z_colorcam_reg_zbuf, []);
title( 'Task 7: Depth data resampled into a regular grid after Z-buffering ');
subplot(234); imshow( z_colorcam_reg_zbuf_filled, []);
title( 'Task 7: Depth data resampled into a regular grid after Z-buffering and occlusion filling');

subplot(2, 3, [2 3 5 6]); h = surf(z_colorcam_reg_zbuf_filled, double(Image), 'EdgeColor', 'none');
set(gca,'ZDir', 'reverse')
set(gca,'YDir','reverse');
title( 'Task 8: Z-buffering 3D mesh generated from resampled depth')
edgeRemoval(h);
drawnow;





