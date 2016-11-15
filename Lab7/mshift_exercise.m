function mshift_exercise()
%MSHIFT_EXERCISE Summary of this function goes here
%   Detailed explanation goes here

    %% Prepare environment
    close all hidden; clear; clc

    addpath(genpath('images'))

    %% Read and show image

    I = imread('animals.jpg');
%     I = imresize(I, 0.25);

    %% Show image and let user decide the optimum value for K

    imshow(I);

    %% Execute the KMeans algorithm

    data = double(reshape(I, size(I,1)*size(I,2), 3));
    [colors, labels] = MeanShiftCluster(data', 30);

    %% Show results
    
    show_results(size(I,2), size(I,1), labels, colors')
    
end

