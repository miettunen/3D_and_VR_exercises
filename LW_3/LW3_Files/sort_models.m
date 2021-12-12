function [models_sorted] = sort_models(models, R, T)
    [m,n] = size(models);
    depth = zeros([1,n]);
    
    for i = 1:n
        vertices = models{i}.vertices;
        XYZ_cam = R*vertices+T';
        corner1 = XYZ_cam(:,1);
        corner2 = XYZ_cam(:,8);
        depth(i) = corner1(3)+corner2(3);
            
    end
    [~, index] = sort(depth, 'descend');
    models_sorted = models(:,index);
end