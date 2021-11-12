function [bunny_estR,bunny_estt] = ICP(pts, pts_moved, down_sample_step)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    R = 0;
    t = 0;
    ds_pts = pcdownsample(pts, 'random', down_sample_step);
    ds_pts_moved = pcdownsample(pts_moved, 'random', down_sample_step);
    [idx, dist] = knnsearch(ds_pts.Location, ds_pts_moved.Location);
    [dist_sorted, i] = sort(dist);
    new_idx = idx(i, :);
    [R, t] = estimateRT_pt2pt(idx, new_idx);
    bunny_estR = R;
    bunny_estt = t;
end

