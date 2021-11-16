function [converged, R, t, bunny_aligned] = ICP(pts, pts_moved, down_sample_step, iters, visualize, tolerance, use_colours, slab1, slab2)
    consecutive_criterion = 0;
    bunny_estR_old = vrrotmat2vec(zeros(3,3));
    bunny_estt_old = zeros(3);

    if use_colours
        alpha = 0.4;
        slab1_ds = pcdownsample(slab1, 'random', down_sample_step);
        slab2_ds = pcdownsample(slab2, 'random', down_sample_step);
    end

    if visualize
        figure;
    end
    for iter = 1 : iters
            
        % Downsample the points
        ds_point_cloud = pcdownsample(pointCloud(pts), 'random', down_sample_step);
        ds_point_cloud_moved = pcdownsample(pointCloud(pts_moved), 'random', down_sample_step);

        ds_pts = ds_point_cloud.Location;
        ds_pts_moved = ds_point_cloud_moved.Location;
        if use_colours
            % Search for nearest neighbour
            [idx, dist] = knnsearch([ds_pts rgb2lab(slab1_ds.Color)], [ds_pts_moved rgb2lab(slab2_ds.Color)], 'K', 1,'Distance', 'seuclidean', 'Scale', [1 1 1 alpha alpha alpha]);
        else
            % Search for nearest neighbour
            [idx, dist] = knnsearch(ds_pts, ds_pts_moved, 'K', 1,'Distance', 'euclidean');
        end
        
        % Estimate rotation and translation
        [bunny_estR, bunny_estt] = estimateRT_pt2pt(ds_pts(idx, :), ds_pts_moved);
        % Convert to axis-angle representation
        R_axis_angle = vrrotmat2vec(bunny_estR);
        
        % Compare thresholds (4th index in the matrix correspondes to
        % angle)
        if abs(R_axis_angle(4) - bunny_estR_old(4)) < tolerance(1) && sum(abs(bunny_estt - bunny_estt_old)) < tolerance(2)
            consecutive_criterion = consecutive_criterion + 1;
        else
            consecutive_criterion = 0;
        end
    
        bunny_aligned = pointCloud(rigidTransform(pts_moved, bunny_estR, bunny_estt));
        R = bunny_estR;
        t = bunny_estt;
        if consecutive_criterion == 3
            converged = iter;
            return;
        end
        
        if visualize && use_colours == false
            pcshowpair(pointCloud(pts), bunny_aligned, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',100)
            title(['Task C.  Press any button for the next iteration!     ', 'Iteration: ', num2str(iter)])
            waitforbuttonpress;
        end
        if use_colours
            bunny_aligned.Color = slab2.Color;
            pcshow(slab1, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',100), hold on;
            pcshow(bunny_aligned, 'VerticalAxis','Y', 'VerticalAxisDir', 'down','MarkerSize',100), hold off;
            title(['Task E.  Press any button for the next iteration!     ', 'Iteration: ', num2str(iter)])
            waitforbuttonpress;
        end
        bunny_estR_old = R_axis_angle;
        bunny_estt_old = bunny_estt;
        pts_moved = bunny_aligned.Location;
        
    end
    converged = iter;
end

