function kmeans_exercise()
% Authors: J. Heidecke & A. Suarez


%% Prepare environment
close all hidden; clear; clc

addpath(genpath('images'))

%% Read and show image. Apply transformations (if that applies)

I = imread('animals.jpg');
%I = imread('alwin2.jpg');
%I = imread('bigbangfamily.png');

%I = imrotate(I,90);
I = imresize(I,0.25);
%I = imresize(I,2);

%% Show image and let user decide the value for K
imshow(I)
% K = input('Choose optimum K: '); % Comment this if you want to fix the K value
K = 10; % Uncomment this if you want to fix the K value

%% Let the user decide whether he wants to include the spatial coordinates or not

% include_spatial = input('Include spatial coordinates? (0/1): '); % Comment this to fix the value
include_spatial = 1; % Uncomment this to fix the value

%% Execute the KMeans algorithm

data = double(reshape(I, size(I,1)*size(I,2), 3));

if include_spatial
    spatial_coordinates = generate_spatial_coordinates(size(I,2), size(I,1));
    data = [data, spatial_coordinates];
end

% rand('seed',42) % Fix the state of the RNG. Uncomment for reproducible results

[labels, colors] = kmeans(data, K);

%% Show labels (in gray scale) and colored

figure
show_results(I, labels, colors)

end
