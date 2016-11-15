% Computational Vision
% Practicum Face Recognition: Subject recognition (OPTIONAL EXERCISE)
%
% Student name: Alejandro Suarez & Johannes Heidecke
%
% >> OBJECTIVE: 
% 1)Complete this function to solve the subject recognition problem

% main function
function main_subject_recognition()

clc; close all; clear;

%% These sub-directories are required
addpath(genpath('feature_extraction'))
addpath(genpath('classification'))

%% Load database of images and analyze the structure
ARFace = importdata('ARFace.mat');

%% Prepare the data set samples identifying data and labels (male/female).
% We will use the internal faces loaded in the structure
display(ARFace)


%% Count the number of occurrences of each subject.

NumberSamples = size(ARFace.person, 2);
NOcc = 26; % It's always the same. Otherwise: sum(ARFace.person==ARFace.person(1));
NSubjects = 85; % It's always the same. Otherwise: NumberSamples/NOcc


%% Define the training set and test set from the data set using:
% a. Use the whole data set
% Build this data structure: 
%   images(:,i): is the image of sample i.
%   labels(i): is the label of sample i.
% Use the "internal" images, we will reduce dimensionality later.

images = ARFace.internal';
labels = ARFace.person';


%% Feature Extraction using PCA
mat_features_pca = feature_extraction('PCA', images);


%% Feature Extraction using PCA (95% variance explained)
mat_features_pca95 = feature_extraction('PCA95', images);


%% Feature Extraction using LDA
mat_features_lda = feature_extraction('LDA', images, labels);


%% Classification
% Call the function validation to perform the F-fold
% cross validation with: the samples, labels, information
% about the training set subjects and F the number of folds.

% Turn off warnings for deprecated KNNCLASSIFY:
warning('off', 'bioinfo:knnclassify:incompatibility');

F = 50;
error_pca = fold_validation_subject(mat_features_pca', labels', F);
display(['Error PCA: ', num2str(mean(error_pca)*100), '%']);
error_pca95 = fold_validation_subject(mat_features_pca95', labels', F);
display(['Error PCA95: ', num2str(mean(error_pca95)*100), '%']);
error_lda = fold_validation_subject(mat_features_lda', labels', F);
display(['Error LDA: ', num2str(mean(error_lda)*100), '%']);

end



