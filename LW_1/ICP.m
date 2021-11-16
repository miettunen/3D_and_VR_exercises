function [bunny_estR,bunny_estt] = ICP(pts, pts_moved, down_sample_step)
    
    % Downsample the points
    ds_point_cloud = pcdownsample(pointCloud(pts), 'random', down_sample_step);
    ds_point_cloud_moved = pcdownsample(pointCloud(pts_moved), 'random', down_sample_step);
    
    ds_pts = ds_point_cloud.Location;
    ds_pts_moved = ds_point_cloud_moved.Location;
    
    % Search for nearest neighbour
    [idx, dist] = knnsearch(ds_pts, ds_pts_moved, 'K', 1,'Distance', 'euclidean');
    % Estimate rotation and translation
    [bunny_estR, bunny_estt] = estimateRT_pt2pt(ds_pts(idx, :), ds_pts_moved);
end

