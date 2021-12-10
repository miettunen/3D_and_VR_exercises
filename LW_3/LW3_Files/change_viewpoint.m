function [] = change_viewpoint(model, viewer_location, screen)
    %Viewer properties:       
    viewer = [];
    %Viewer's pose
    viewer.Location = viewer_location; % [X,Y,Z]
    %viewer.Orientation = rotX(0) * rotY(0) * rotZ(0); % Identity matrix => eye(3)
    viewer.Orientation = eye(3);
    %Viewer's extrinsic parameters
    viewer.R = eye(3);
    viewer.T = -viewer.Location*viewer.R;

    %Screen f (distance from viewer to screen)
    screen.f = [viewer.T(3)/screen.pixelSize(1), viewer.T(3)/screen.pixelSize(2)]; % [fx,fy]
    %Screen principal point
    screen.pp = [ screen.res(1)/2-viewer.T(1)/screen.pixelSize(1), screen.res(2)/2-(viewer.T(2)/screen.pixelSize(2)+screen.res(2)/2)]; %[cx, cy]
    %Screen intrinsic parameters matrix
    screen.K = [screen.f(1), 0, screen.pp(1); ...
               0, screen.f(2), screen.pp(2); ...
               0, 0, 1];

    XYZ = model.vertices;
    screen.uv = Project3DTo2D(XYZ, screen.K, viewer.R, viewer.T);
    model.connectivity = sort_polygons(model.vertices, model.connectivity, viewer.R, viewer.T);
    %Draw scene
    subplot(1,2,1);
    for c = 1:size(model.connectivity, 2)
        patch('Faces',[1 2 3], ...
            'Vertices',[model.vertices(:,model.connectivity(1, c)), ...
            model.vertices(:,model.connectivity(2, c)), ...
            model.vertices(:,model.connectivity(3, c))]', ...
            'FaceColor', model.color(:,c), ...
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
    plot(screen.uv(1,:), screen.uv(2,:), '.', 'MarkerSize', 20);
    set(gca, 'YDir', 'reverse');
    hold on;
    for c = 1:size(model.connectivity, 2)
        patch(  'Faces', [1 2 3], ...
            'Vertices', [screen.uv(:,model.connectivity(1, c)), ...
            screen.uv(:,model.connectivity(2, c)), ...
            screen.uv(:,model.connectivity(3, c))]', ...
            'FaceColor', model.color(:,c), ...
            'EdgeColor', 'none');
    end
    format = '%.2f';
    title(['Task 2.3  [X,Y,Z]=[', num2str(viewer_location(1), format), ' ', num2str(viewer_location(2), format), ' ', num2str(viewer_location(3), format),']']);
    axis image;
    xlim([0,screen.res(1)]);
    ylim([0,screen.res(2)]);
    
end

