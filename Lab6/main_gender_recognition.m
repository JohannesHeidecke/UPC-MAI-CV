% Computational Vision
% Practicum Face Recognition: Gender recognition
%
% Student name: Johannes Heidecke, Alejandro Suárez
%
% >> OBJECTIVE: 
% 1) Analize the code
% 2) Understand the function of each part of the code
% 3) Code the missing parts
% 4) Answer the pose questions
% 5) Execute the code 
% 6) Check the results and comment them in the report

% main function
function main_gender_recognition()

clc; close all; clear;

%% These sub-directories are required
addpath(genpath('feature_extraction'))
addpath(genpath('classification'))

%% Load database of images and analyze the structure
ARFace = importdata('ARFace.mat');

%% Prepare the data set samples identifying data and labels (male/female).
% We will use the internal faces loaded in the structure
display(ARFace)


%% Count the number of samples and samples males and females of the data set.
% This information is in ARFace.gender ==> male == 1, female == 0
NumberMales = sum(ARFace.gender);
NumberSamples = size(ARFace.gender, 2);
NumberFemales = NumberSamples - NumberMales;

%% Analyse ARFace.person:
% [a,b]=hist(ARFace.person,unique(ARFace.person))

%% Visualize some of the internal faces and save in bmp images
% Use the function reshape to transform the information from a vector to a
% matrix.
for i=1:10:NumberSamples  
    I = reshape(ARFace.internal(:, i), ARFace.internalSz);
    imwrite(I, strcat('out/face_',int2str(i),'.bmp'));  
end


%% Define the training set and test set from the data set using:
% a. Use the whole data set (an unbalanced problem)
% Build this data structure: 
%   images(:,i) is the image of sample i.
%   labels(i) is the label of sample i.
%   subjects(i) is the number of the subject of sample i.
% Use the "internal" images, we will reduce dimensionality later.

images = ARFace.internal;
labels = ARFace.gender;
subjects = ARFace.person;
    
%% Atention! We will use the dataset in the representation: Sample x Variables (Samples x 1188):
images = images';
labels = labels';
subjects = subjects';


%% Feature Extraction using PCA
tic;
mat_features_pca = feature_extraction('PCA', images);
strcat('# pca dim5 features: ', int2str(size(mat_features_pca)))
toc;

%% Feature Extraction using PCA (95% variance explained)
tic;
mat_features_pca95 = feature_extraction('PCA95', images);
strcat('# pca 95% features: ', int2str(size(mat_features_pca95)))
toc;


%% Feature Extraction using LDA
tic;
mat_features_lda = feature_extraction('LDA', images, labels);
strcat('# lda features: ', int2str(size(mat_features_lda)))
toc;


%% Classification
% Call the function validation to perform the F-fold
% cross validation with: the samples, labels, information
% about the training set subjects and F the number of folds.

% Turn off warnings for deprecated KNNCLASSIFY:
warning('off', 'bioinfo:knnclassify:incompatibility');

F = 20;
tic;
Rates_pca = validation(mat_features_pca', labels', subjects', F);
toc;
display(Rates_pca);
tic;
Rates_pca95 = validation(mat_features_pca95', labels', subjects', F);
toc;
display(Rates_pca95);
tic;
Rates_lda = validation(mat_features_lda', labels', subjects', F);
toc;
display(Rates_lda);


end



