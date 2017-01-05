function demo_svm()
%% Load tags and SVM model

Y = load('GroundTruth.mat');
Y = Y.Y;
SVMModel = load('SVMModel.mat');
SVMModel = SVMModel.SVMModel;

%% Start classifying

for Image = Y
    I = imresize(imread(['materialLab10/', Image.name]), 0.25);
    classify_and_show(I, strcmp(Image.tag, '1'))
    waitforbuttonpress
%     pause(0.1)
end

function classify_and_show(I, Y)
    WH = size(I,1)*size(I,2);
    % Compute normalized histogram with reduced number of bins
    nhist = cat(1, ...
        imhist(I(:,:,1), 5), ...
        imhist(I(:,:,2), 5), ...
        imhist(I(:,:,3), 5)) / WH;
    X = nhist';
    Y_ = svmclassify(SVMModel, X);
    imshow(I)
    if Y
        truth = 'indoor';
    else
        truth = 'outdoor';
    end
    if Y_
        guess = 'indoor';
    else
        guess = 'outdoor';
    end
    title(['Truth: ', truth, ', guess: ', guess]);
    color = 'rg';
    color = color(1 + (Y==Y_));
    rectangle('Position', [1, 1, size(I, 2), size(I, 1)], 'EdgeColor', color, 'LineWidth', 4)
end

end