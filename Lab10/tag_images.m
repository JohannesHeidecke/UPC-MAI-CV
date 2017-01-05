function tag_images()

images = dir('materialLab10/*.jpg');

N = length({images.name});

Y = [];


hpb = waitbar(0, '0%');
completed = 0;
for image={images.name}
    I = imresize(imread(['materialLab10/', cell2mat(image)]), 0.25);
    imshow(I);
    Y = [Y, struct('name', cell2mat(image), 'tag', questdlg('Is indoor?', '', 1, 0, 1))];
    completed = completed + 1;
    waitbar(completed/N, hpb, sprintf('%f%%', completed/N*100));
end

close(hpb)

save('GroundTruth.mat', 'Y');

end

