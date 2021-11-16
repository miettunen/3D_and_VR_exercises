function [bunny_estR,bunny_estt, bunny_aligned] = ICP(pts, pts_moved, down_sample_step, iterations, visualize)
    if visualize
        figure;
    end
    for iter = 1 : iterations
        % Downsample the points
        ds_point_cloud = pcdownsample(pointCloud(pts), 'random', down_sample_step);
        ds_point_cloud_moved = pcdownsample(pointCloud(pts_moved), 'random', down_sample_step);

        ds_pts = ds_point_cloud.Location;
        ds_pts_moved = ds_point_cloud_moved.Location;

        % Search for nearest neighbour
        [idx, dist] = knnsearch(ds_pts, ds_pts_moved, 'K', 1,'Distance', 'euclidean');
        % Estimate rotation and translation
        [bunny_estR, bunny_estt] = estimateRT_pt2pt(ds_pts(idx, :), ds_pts_moved);
        bunny_aligned = pointCloud(rigidTransform(pts_moved, bunny_estR, bunny_estt));
        if visualize
            
            pcshowpair(pointCloud(pts), bunny_aligned, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',100)
            title(['Press any button for the next iteration!     ', 'Iteration: ', num2str(iter)])
            waitforbuttonpress;
        end
        pts_moved = bunny_aligned.Location;
        
    end
end

