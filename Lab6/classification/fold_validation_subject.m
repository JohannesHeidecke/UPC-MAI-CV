function [error] = fold_validation_subject(features, labels, NFolds)
% FOLD VALIDATION SUBJECT: compute the classification rates of validation after
%classification.
% Inputs:
% features: each columns is a sample and each row is a variable or feature:
% Variables x Samples
% labels: 1xS it contains all the labels (1 patients, 0 controls)
% subjects
% F: F fold validation will be used
% Outputs: vectors containing the rates of validation after classification.

%% Estimate the number of subjects for every fold

% We assume that all the subjects have the same number of images samples:
NOcc = sum(labels==labels(1));
NSubjects = length(labels);
NTest = floor(NSubjects/NFolds);

%% Randomly sort the data set before validation
p=randperm(NSubjects);
labels = labels(p);
features = features(:,p);

error = zeros(NFolds,1);
%% Loop of NFolds
for i = 1:NFolds
    
    select = false(NSubjects,1);
    
    if i==NFolds
        select((i-1)*NTest+1:end) = true;  
    else
        select((i-1)*NTest+1:i*NTest)  = true;   
    end

    % Load Training Set     
    TrainSet = features(:,~select);
    TrainLabels=labels(:,~select');

    % Load Test Set
    TestSet  = features(:,select);
    TestLabel = labels(:,select);
    
    % Necessary. The last fold can contain less elements.
    NTest = length(TestLabel);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Normalization    
    T_TrainSet=TrainSet';
    T_TestSet=TestSet';
    
    % Compute mean and variance:
    m=mean(T_TrainSet);
    v=std(T_TrainSet);

    % Normalize Training Set:
    mMatrix = ones (size(T_TrainSet,1), 1) * m;
    vMatrix = ones (size(T_TrainSet,1), 1) * v;
    T_TrainSet=(T_TrainSet-mMatrix)./vMatrix;

    % Normalize Test Set:
    mMatrix = ones (size(T_TestSet,1), 1) * m;
    vMatrix = ones (size(T_TestSet,1), 1) * v;    
    T_TestSet=(T_TestSet-mMatrix)./vMatrix;      
    
    % Transpose the data:
    TrainSet=T_TrainSet';
    TestSet=T_TestSet';
   
    % Train a k-nn classifier and test the test samples using knnclassify.m
    k=2;
    idx = knnclassify(TestSet', TrainSet', TrainLabels', k);
    Result_labels=idx';
        
    % Compute the classification rates
    error(i) = sum(Result_labels ~= TestLabel)/NTest;

end

end





