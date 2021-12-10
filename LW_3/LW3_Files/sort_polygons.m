function [connectivity_sorted] = sort_polygons(vertices, connectivity)
    [m,n] = size(connectivity);
    depth = zeros([1,n]);
    for i = 1:n
        % Find points from each triangle and calculate depth (average of z)
        points = vertices(:,connectivity(:,i));
        depth(i) = sum(points(3,:));
    end
    [~, index] = sort(depth, 'descend');
    connectivity_sorted = connectivity(:,index);
end