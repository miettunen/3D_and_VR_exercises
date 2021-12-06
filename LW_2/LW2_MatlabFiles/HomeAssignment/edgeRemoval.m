function edgeRemoval( h )
% Gets the handle h to a surf object, removes the stretched triangles causing
% artifacts on the edges of objects
    normals_size = size(h.FaceNormals);
    f_n = h.FaceNormals;
    h_c = h.CData;
    z = h.ZData;
    size(z)
    for i = 1:normals_size(1)
        for j = 1:normals_size(2)
            if norm([f_n(i, j, 1) f_n(i, j, 2)]) > h_c(i,j)
                h_c(i, j, :) = NaN;
            end
        end
    end
    h.CData = h_c;
end

