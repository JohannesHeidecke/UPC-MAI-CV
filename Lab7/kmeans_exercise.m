function kmeans_exercise()
% Authors: J. Heidecke & A. Suarez


%% Prepare environment
close all hidden; clear; clc

addpath(genpath('images'))

%% Read and show image

I = imread('animals.jpg');

%% Show image and let user decide the optimum value for K

imshow(I)
% K = input('Choose optimum K: '); % Comment this if you want to fix the K value
K = 10; % Uncomment this if you want to fix the K value

%% Execute the KMeans algorithm

data = double(reshape(I, size(I,1)*size(I,2), 3));
[labels, colors] = kmeans(data, K);

%% Show colored labels 

show_results(size(I,2), size(I,1), labels, colors*255)

end
