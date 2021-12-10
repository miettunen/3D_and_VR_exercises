function [viewer_location] = jitter_stabilization(location_buffer)
    [~, buffer_size] = size(location_buffer);
    viewer_location = sum(location_buffer, 2) / buffer_size;
end

