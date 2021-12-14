function [rendered, z_buffer] = z_buffer(scene, viewer_location, screen)
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
           
    z_buffer = zeros(screen.res(2),screen.res(1));
    z_buffer(:,:) = 1.5;
    
    rendered = zeros(screen.res(2),screen.res(1),3);
    rendered(:,:,:) = 1;
    
    for k = 1:length(scene)
        model = scene{k};
        for c = 1:length(model.connectivity)
            points = model.vertices(:,model.connectivity(:,c));
            
            [uv, uvk] = Project3DTo2D(points, screen.K, viewer.R, viewer.T);
            xyz_proj = viewer.R*points+viewer.T;
            z_values = uvk(3,:);
            
            bounding_box = int64([min(uv(1,:), [], 'all') ...
                min(uv(2,:), [], 'all') ...
                max(uv(1,:), [], 'all') ...
                max(uv(2,:), [], 'all')]);
            xv = uv(1,:);
            yv = uv(2,:);
            xq = double(bounding_box(1)):1:double(bounding_box(3));
            yq = double(bounding_box(2)):1:double(bounding_box(4));
            
            [xq, yq] = meshgrid(xq,yq);
            xq = reshape(xq.',1,[]);
            yq = reshape(yq.',1,[]);
         
            in = inpolygon(xq,yq,xv,yv);
            surface_pixels = cat(1, xq(in), yq(in));
            
            
            
            [m,n] = size(surface_pixels);
            for i = 1:n
                pixel = surface_pixels(:,i);
                w1 = ((uv(2,2)-uv(2,3))*(pixel(1)-uv(1,3)) + (uv(1,3)-uv(1,2))*(pixel(2)-uv(2,3))) / ((uv(2,2)-uv(2,3))*(uv(1,1)-uv(1,3)) + (uv(1,3)-uv(1,2))*(uv(2,1)-uv(2,3)));
                w2 = ((uv(2,3)-uv(2,1))*(pixel(1)-uv(1,3)) + (uv(1,1)-uv(1,3))*(pixel(2)-uv(2,3))) / ((uv(2,2)-uv(2,3))*(uv(1,1)-uv(1,3)) + (uv(1,3)-uv(1,2))*(uv(2,1)-uv(2,3)));
                w3 = 1-w1-w2;
                pixel_z = inv( inv(z_values(1)) * w1 + inv(z_values(2)) * w2 + inv(z_values(3)) * w3 );
                
                
                if pixel_z < z_buffer(pixel(2), pixel(1))
                    rendered(pixel(2), pixel(1), :) = model.color(:,c);
                    z_buffer(pixel(2), pixel(1)) = pixel_z;
                end          
            end
        end
    end
    