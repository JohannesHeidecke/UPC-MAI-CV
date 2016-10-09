% MAI - CV
% Laboratory 1
% Exercise 1
% Deliverable by: Johannes Heidecke

% create the 3 images in gray scale:
I1 = zeros(200, 200, 'uint8');
I1(:, 101:200) = 255;
I2 = zeros(200, 200, 'uint8');
I2(101:200, :) = 255;
I3 = zeros(200, 200, 'uint8');
I3(1:100, 1:100) = 255;

% combine the 3 obtained images to construct a RGB image:
IRGB = cat(3, I1, I2, I3);

% display the images:
figure;
subplot(1, 4, 1);
imshow(I1);
subplot(1, 4, 2);
imshow(I2);
subplot(1, 4, 3);
imshow(I3);
subplot(1, 4, 4);
imshow(IRGB);

% save the RGB image:
imwrite(IRGB, '3channels.jpg');