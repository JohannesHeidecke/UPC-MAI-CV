% MAI - CV
% Laboratory 1
% Exercise 2
% Deliverable by: Johannes Heidecke

% read the image chairs.jpg from file
I = imread('chairs.jpg');

% extract the different color channels:
rI = I(:, :, 1);
gI = I(:, :, 2);
bI = I(:, :, 3);

% display the channels:
figure;

subplot(2, 3, 2);
imshow(I);
title('Original Image');

subplot(2, 3, 4);
imshow(rI);
title('Red Channel');

subplot(2, 3, 5);
imshow(gI);
title('Green Channel');

subplot(2, 3, 6);
imshow(bI);
title('Blue Channel');

% interchange channels:
figure;

subplot(3, 2, 1);
imshow(cat(3, rI, gI, bI));
title('RGB -> RGB (normal)');

subplot(3, 2, 2);
imshow(cat(3, rI, bI, gI));
title('RGB -> RBG');

subplot(3, 2, 3);
imshow(cat(3, gI, rI, bI));
title('RGB -> GRB');

subplot(3, 2, 4);
imshow(cat(3, bI, rI, gI));
title('RGB -> BRG');

subplot(3, 2, 5);
imshow(cat(3, gI, bI, rI));
title('RGB -> GBR');

subplot(3, 2, 6);
imshow(cat(3, bI, gI, rI));
title('RGB -> BGR');

% multiply channels by 0:
figure;
subplot(1, 3, 1);
imshow(cat(3, bI * 0, gI, rI));
title('RGB -> 0GB');

subplot(1, 3, 2);
imshow(cat(3, bI, gI * 0, rI));
title('RGB -> R0B');

subplot(1, 3, 3);
imshow(cat(3, bI, gI, rI * 0));
title('RGB -> RH0');
