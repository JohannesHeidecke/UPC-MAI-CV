% MAI - CV
% Laboratory 2
% Exercise 1
% Deliverable by: Johannes Heidecke

function exercise1

I = imread('starbuck.jpg');
Ig = rgb2gray(I);

% trySobel(Ig);
% tryPrewitt(Ig);
% tryRoberts(Ig);
% tryLaplacianOfGaussian(Ig);
% tryZerocross(Ig);
% tryCanny(Ig);
overlapEdges(I, 'Canny');

end

function trySobel(Ig)

% try different configurations of Sobel method
figure;
Iedge = edge(Ig, 'Sobel', 'horizontal');
subplot(1, 4, 1);
imshow(Iedge);
title('Sobel, only horizontal, automatic t');

[Iedge, t]  = edge(Ig, 'Sobel');
subplot(1, 4, 2);
imshow(Iedge);
title('Sobel, automatic t');

t

Iedge = edge(Ig, 'Sobel', 0.01);
subplot(1, 4, 3);
imshow(Iedge);
title('Sobel, t = 0.01');

Iedge = edge(Ig, 'Sobel', 0.1);
subplot(1, 4, 4);
imshow(Iedge);
title('Sobel, t = 0.1');

end

function tryPrewitt(Ig)

% try different configurations of Prewitt method
figure;
Iedge = edge(Ig, 'Prewitt', 'vertical');
subplot(1, 4, 1);
imshow(Iedge);
title('Prewitt, only vertically, automatic t');

[Iedge, t]  = edge(Ig, 'Prewitt');
subplot(1, 4, 2);
imshow(Iedge);
title('Prewitt, automatic t');

t

Iedge = edge(Ig, 'Prewitt', 0.4);
subplot(1, 4, 3);
imshow(Iedge);
title('Prewitt, t = 0.4');

Iedge = edge(Ig, 'Prewitt', 0.25);
subplot(1, 4, 4);
imshow(Iedge);
title('Prewitt, t = 0.25');

end

function tryRoberts(Ig)

% try different configurations of Roberts method
figure;

[Iedge, t]  = edge(Ig, 'Roberts');
subplot(1, 4, 1);
imshow(Iedge);
title('Roberts, automatic t');

t

Iedge = edge(Ig, 'Roberts', 0.3);
subplot(1, 4, 2);
imshow(Iedge);
title('Roberts, t = 0.3');

Iedge = edge(Ig, 'Roberts', 0.25);
subplot(1, 4, 3);
imshow(Iedge);
title('Roberts, t = 0.25');

Iedge = edge(Ig, 'Roberts', 0.05);
subplot(1, 4, 4);
imshow(Iedge);
title('Roberts, t = 0.05');

end

function tryLaplacianOfGaussian(Ig)

% try different configurations of Laplacian of Gaussian method
figure;

[Iedge, t]  = edge(Ig, 'log');
subplot(1, 4, 1);
imshow(Iedge);
title('Laplacian of Gaussian, automatic t');

t

Iedge = edge(Ig, 'log', [], 1);
subplot(1, 4, 2);
imshow(Iedge);
title('Laplacian of Gaussian, automatic t, sigma = 1');

Iedge = edge(Ig, 'log', 0.03);
subplot(1, 4, 3);
imshow(Iedge);
title('Laplacian of Gaussian, t = 0.3');

Iedge = edge(Ig, 'log', 0.01);
subplot(1, 4, 4);
imshow(Iedge);
title('Laplacian of Gaussian, t = 0.00001');

end

function tryZerocross(Ig)

% try different configurations of Roberts method
figure;

f = fspecial('gaussian', 5, 2);
[Iedge, t]  = edge(Ig, 'zerocross', [], f);
subplot(1, 4, 1);
imshow(Iedge);
title('Zerocross with gaussian, automatic t');

t

Iedge  = edge(Ig, 'zerocross', 0.015, f);
subplot(1, 4, 2);
imshow(Iedge);
title('Zerocross with gaussian, t = 0.015');

Iedge  = edge(Ig, 'zerocross', 0.006, f);
subplot(1, 4, 3);
imshow(Iedge);
title('Zerocross with gaussian, t = 0.006');

Iedge  = edge(Ig, 'zerocross', 0.001, f);
subplot(1, 4, 4);
imshow(Iedge);
title('Zerocross with gaussian, t = 0.001');

end

function tryCanny(Ig)

% try different configurations of Roberts method
figure;

[Iedge, t]  = edge(Ig, 'Canny');
subplot(1, 4, 1);
imshow(Iedge);
title('Canny, automatic t');

t

Iedge = edge(Ig, 'Canny', 0.2);
subplot(1, 4, 2);
imshow(Iedge);
title('Canny, t = 0.2/0.08');

Iedge = edge(Ig, 'Canny', 0.2, 2);
subplot(1, 4, 3);
imshow(Iedge);
title('Canny, t = 0.2/0.08, sigma = 2');

Iedge = edge(Ig, 'Canny', 0.2, 0.5);
subplot(1, 4, 4);
imshow(Iedge);
title('Canny, t = 0.2/0.08, sigma = 0.5');

end

function overlapEdges(I, method)

Ig = rgb2gray(I);

Iedge = edge(Ig, method);

IedgeInvRGB = cat(3, uint8(~Iedge), uint8(~Iedge), uint8(~Iedge));

Iprep = I .* IedgeInvRGB;

IedgeRed = uint8(cat(3, Iedge*255, zeros(size(Iedge)), zeros(size(Iedge))));

Ioverlap = Iprep + IedgeRed;

figure;
subplot(1, 3, 1);
imshow(I);
subplot(1, 3, 2);
imshow(IedgeRed);
title(method);
subplot(1, 3, 3);
imshow(Ioverlap);



end