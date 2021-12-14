function [uv, uvk] = Project3DTo2D(XYZ_data, screen_K, viewer_R, viewer_T)
    t = viewer_T';
    rt = [viewer_R, t];
    P = screen_K*rt;
    XYZ_data(4,:) = 1;
    uvk = P*XYZ_data;
    uv = uvk(1,:)./uvk(3,:);
    uv(2,:) = uvk(2,:)./uvk(3,:);
end