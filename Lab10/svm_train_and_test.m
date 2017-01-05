function svm_train_and_test()

%% Load tags

load GroundTruth.mat
N = length(Y);

% The images are ordered by time, with very similar images next to each
% other, so mess them all a litle bit:
rand('seed', 42); % do not change if loading X from Features-s42.mat!!
Y = Y(randperm(length(Y)));

train_Y = Y(1:100);
train_Y = cellfun(@str2num, {train_Y.tag})';

test_Y = Y(101:end);
test_Y = cellfun(@str2num, {test_Y.tag})';

%% Extract features from images

% This can take a while. Set the if condition to zero to load the
% attributes directly from a file.
if 0

    X = [];
    hpb = waitbar(0, 'Obtaining features: 0%');
    completed = 0;
    for image={Y.name}
        I = imread(['materialLab10/', cell2mat(image)]);
        WH = size(I,1)*size(I,2);
        % Compute normalized histogram with reduced number of bins
        nhist = cat(1, ...
            imhist(I(:,:,1), 5), ...
            imhist(I(:,:,2), 5), ...
            imhist(I(:,:,3), 5)) / WH;
        X = [X; nhist'];
        completed = completed + 1;
        waitbar(completed/N, hpb, sprintf('Obtaining features: %f%%', completed/N*100));
    end

    save('Features-s42.mat', 'X')

    close(hpb)  

else
    load Features-s42.mat
end

%% Train SVM

train_X = X(1:100, :);
test_X = X(101:end, :);

length(test_X)

% Train SVM with linear kernel
SVMModel = svmtrain(train_X, train_Y);
save('SVMModel.mat', 'SVMModel')

%% Test model

test_Y_ = svmclassify(SVMModel, test_X);

TP = sum(test_Y & test_Y_);
TN = sum(~test_Y & ~test_Y_);
FP = sum(~test_Y & test_Y_);
FN = sum(test_Y & ~test_Y_);
Confusion = [TP, FP; FN, TN]
Acc = (TP+TN) / (TP + TN + FP + FN)


end