function [uv] = Project3DTo2D(XYZ_data, screen_K, viewer_R, viewer_T)
    [m, n] = size(XYZ_data);  
    uv = zeros([2, n]);
    for i = 1:n
        X_proj = viewer_R*XYZ_data(:,i) + viewer_T;
        projection = screen_K*X_proj;
        uv(:,i) = [projection(1)/projection(3), projection(2)/projection(3)];
    end
end