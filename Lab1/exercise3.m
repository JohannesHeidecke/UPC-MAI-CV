% MAI - CV
% Laboratory 1
% Exercise 3
% Deliverable by: Johannes Heidecke

function exercise3()
% read an image file:
I = imread('corals.jpg');

% rescaleAndPlot(I);
histogramComparison(I);
% rescaleAndRestore(I);
% applyFilters(I);

end

function rescaleAndPlot(I)
% show image after rescaling to smaller sizes:
figure;

subplot(2, 2, 1);
imshow(I);
title('original');

subplot(2, 2, 2);
imshow(imresize(I, 0.5));
title('scaled to 0.5 size');

subplot(2, 2, 3);
imshow(imresize(I, 0.1));
title('scaled to 0.1 size');

subplot(2, 2, 4);
imshow(imresize(I, 0.01));
title('scaled to 0.01 size');
end

function histogramComparison(I)
% compare histograms of original and rescaled image:
% for this example, using the 0.1 rescaled image
figure;

I_rescaled = imresize(I, 0.1);

subplot(3, 2, 1);
imhist(I(:, :, 1));
title('Histogram red channel original');

subplot(3, 2, 2);
imhist(I_rescaled(:, :, 1));
title('Histogram red channel rescaled');

subplot(3, 2, 3);
imhist(I(:, :, 2));
title('Histogram green channel original');

subplot(3, 2, 4);
imhist(I_rescaled(:, :, 2));
title('Histogram green channel rescaled');

subplot(3, 2, 5);
imhist(I(:, :, 3));
title('Histogram blue channel original');

subplot(3, 2, 6);
imhist(I_rescaled(:, :, 3));
title('Histogram blue channel rescaled');
end

function rescaleAndRestore(I)
% returning the rescaled image to the original size:
I_rescaled = imresize(I, 0.1);
I_restored = imresize(I_rescaled, 10);

figure;

subplot(2, 3, 1);
imshow(I);
title('Original image');

subplot(2, 3, 2);
imshow(I_rescaled);
title('Image rescaled to 0.1 size');

subplot(2, 3, 3);
imshow(I_restored);
title('0.1 image restored to original size');

s = size(I);
subplot(2, 3, 4);
imshow(I(1:round(s(1) * 0.1), 1:round(s(2) * 0.1), :));
title('Cut from original image');

s = size(I_rescaled);
subplot(2, 3, 5);
imshow(I_rescaled(1:round(s(1) * 0.1), 1:round(s(2) * 0.1), :));
title('Cut from rescaled to 0.1 size');

s = size(I_restored);
subplot(2, 3, 6);
imshow(I_restored(1:round(s(1) * 0.1), 1:round(s(2) * 0.1), :));
title('Cut from restored');
end

function applyFilters(I)
% apply different filters to the image
kernel = ones(100, 100);
kernel = 1/sum(sum(kernel)) * kernel;

I_filtered = imfilter(I, kernel);
figure;
imshow(I_filtered);

kernel = fspecial('gaussian', 50, 20);
I_filtered = imfilter(I, kernel);
figure;
imshow(I_filtered);

% compare different kernels
figure;
subplot(2, 2, 1);
imshow(I);

kernel = [1 1 1 1 1];
kernel = 1/sum(sum(kernel)) * kernel;
I_filtered = imfilter(I, kernel);
subplot(2, 2, 2);
imshow(I_filtered);
title('XXXXXX');

kernel = [1;1;1;1;1];
kernel = 1/sum(sum(kernel)) * kernel;
I_filtered = imfilter(I, kernel);
subplot(2, 2, 3);
imshow(I_filtered);

kernel = [[1 1 1 1 1]; [1 1 1 1 1]; [1 1 1 1 1]; [1 1 1 1 1]; [1 1 1 1 1]];
kernel = 1/sum(sum(kernel)) * kernel;
I_filtered = imfilter(I, kernel);
subplot(2, 2, 4);
imshow(I_filtered);


% show differences beteen original and smoothed
figure;
subplot(1,3,1);
imshow(I);

subplot(1,3,2);
imshow(I_filtered);

subplot(1,3,3);
imshow(imabsdiff(I, I_filtered));
end