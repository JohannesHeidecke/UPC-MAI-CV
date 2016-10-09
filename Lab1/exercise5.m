% MAI - CV
% Laboratory 1
% Exercise 5
% Deliverable by: Johannes Heidecke

I = imread('car_gray.jpg');

figure;
subplot(4, 1, 1);
imshow(I);

I2 = imbinarize(I, (150/255));

subplot(4, 1, 2);
imshow(I2);

subplot(4, 1, 3);
imshow(I .* uint8(I2));

subplot(4, 1, 4);
imshow(I .* uint8(~I2));