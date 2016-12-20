function ex1()

%% Run this before doing anything else
run('../../vlfeat-0.9.16/toolbox/vl_setup');
addpath '../../vlfeat-0.9.16/apps'

%% Run BOW demo
phow_caltech101



%% Load model and classify images in folders

model = load(['data/', 'tiny', '-model.mat']);
model = model.model;

for category = model.classes
    images = dir(['data/caltech-101/101_ObjectCategories/', cell2mat(category), '/*.jpg']);
    for image={images.name}
        classify_and_show(model, cell2mat(category), cell2mat(image))
        pause(0.1)
    end
end

end