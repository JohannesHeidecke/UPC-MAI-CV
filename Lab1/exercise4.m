% MAI - CV
% Laboratory 1
% Exercise 4
% Deliverable by: Johannes Heidecke

I = imread('clooney.jpg');

% imshow(I);

cut = 213;

I2 = horzcat(I(:, cut+1:end, :), I(:, 1:cut, :));
figure;
imshow(I2);