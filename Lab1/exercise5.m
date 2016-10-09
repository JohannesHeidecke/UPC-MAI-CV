% MAI - CV
% Laboratory 1
% Exercise 5
% Deliverable by: Johannes Heidecke

function exercise5()

I = imread('car_gray.jpg');

% create binarizations with the thresholds 20, 30, 150 and 255.
figure;
subplot(1, 4, 1);
imshow(thresholdImg(I, 20/255));
title('Binarization with threshold 20/255');
subplot(1, 4, 2);
imshow(thresholdImg(I, 30/255));
title('Binarization with threshold 30/255');
subplot(1, 4, 3);
imshow(thresholdImg(I, 150/255));
title('Binarization with threshold 150/255');
subplot(1, 4, 4);
imshow(thresholdImg(I, 255/255));
title('Binarization with threshold 255/255');

% save binarization with threshold 150 to disk
imwrite(thresholdImg(I, 150/255), 'car_binary.jpg');

% multiply original image by binarization:
figure;
imshow(I .* uint8(thresholdImg(I, 150/255)));
title('Original multiplied with its 150/255 binarization');

% multiply original image by inverted binarization:
figure;
imshow(I .* uint8(~thresholdImg(I, 150/255)));
title('Original multiplied with its inverted 150/255 binarization');

end

function out = thresholdImg(I, threshold)
% creates the binarization of I with the specified threshold
% threshold should be between 0 and 1, inclusive
out = imbinarize(I, threshold);

end



