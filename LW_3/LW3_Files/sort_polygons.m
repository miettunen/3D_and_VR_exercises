function [connectivity_sorted] = sort_polygons(vertices, connectivity, R, T)
    [m,n] = size(connectivity);
    depth = zeros([1,n]);
    XYZ_cam = R*vertices+T';
%     XYZ_cam = XYZ_cam';
%     XYZ_cam = vertices;
    
    for i = 1:n
        points = XYZ_cam(:,connectivity(:,i));
        dist = [norm(points(:,1)-points(:,2)), ...
                norm(points(:,1)-points(:,3)), ...
                norm(points(:,2)-points(:,3))];
        [~,I] = max(dist, [], 'all', 'linear');
        
        if I == 1
            depth(i) =  points(3,1)+points(3,2);
        elseif I == 2
            depth(i) =  points(3,1)+points(3,3);
        else
            depth(i) =  points(3,2)+points(3,3);
        end
            
    end
    [~, index] = sort(depth, 'descend');
    connectivity_sorted = connectivity(:,index);
end