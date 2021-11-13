function [R, t] = estimateRT_pt2pt(P, P_t)
    centroid_original = 1/size(P, 1)*sum(P, 1);
    centroid_transformed = 1/size(P_t, 1)*sum(P_t, 1);
    
    subtracted_original = P - centroid_original;
    subtracted_transformed = P_t - centroid_transformed;
    
    covariance = subtracted_original'*subtracted_transformed;
   
    [U, ~, V] = svd(covariance);
    
    R = V*U';
    
    if det(R) < 0
        R(1) = R(1)*(-1);
    end
    
    t = -(centroid_transformed*R - centroid_original);
end