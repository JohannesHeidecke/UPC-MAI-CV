function mshift_exercise()
%Authors: A. Suárez & J. Heidecke

    %% Prepare environment
    close all hidden; clear; clc

    addpath(genpath('images'))

    %% Read and show image

    I = imread('animals.jpg');
%     I = imread('alwin2.jpg');
%     I = imread('bigbangfamily.png');
%     I = imresize(I, 0.5);
%     I = imrotate(I, 90);

    %% Show image

    imshow(I);
    
    %% Let the user decide whether he wants to include the spatial coordinates or not

    % include_spatial = input('Include spatial coordinates? (0/1): '); % Comment this to fix the value
    include_spatial = 1; % Uncomment this to fix the value

    %% Execute the KMeans algorithm

    data = double(reshape(I, size(I,1)*size(I,2), 3));
    
    if include_spatial
        spatial_coordinates = generate_spatial_coordinates(size(I,2), size(I,1));
        data = [data, spatial_coordinates];
    end
    
    [colors, labels] = MeanShiftCluster(data', 50);

    %% Show results
    figure
    show_results(I, labels, colors')
    
end

