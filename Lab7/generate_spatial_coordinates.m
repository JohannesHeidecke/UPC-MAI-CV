function coordinates = generate_spatial_coordinates(width, height)
% Convenience method for generating the spatial coordinates for each of the
% pixels of an image
    [xx,yy] = meshgrid(1:width, 1:height);
    coordinates = [xx(:), yy(:)];
end