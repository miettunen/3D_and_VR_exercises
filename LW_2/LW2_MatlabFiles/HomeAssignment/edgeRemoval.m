function edgeRemoval( h )
% Gets the handle h to a surf object, removes the stretched triangles causing
% artifacts on the edges of objects
    normals_size = size(h.FaceNormals);
    f_n = h.FaceNormals;
    h_c = h.CData;
    z = h.ZData;
    for i = 1:normals_size(1)
        for j = 1:normals_size(2)
            %{
            if norm([f_n(i, j, 1) f_n(i, j, 2)]) > f_n(i, j, 3)
                h.CData(i, j, 3) = NaN;
            end
            %}
            if norm([f_n(i, j, 1) f_n(i, j, 2)]) > norm(f_n(i, j, 3))
                h_c(i, j, 3) = NaN;
            end
        end
    end
    h.CData = h_c;
end

