% MAI - CV
% Laboratory 1
% Exercise 4
% Deliverable by: Johannes Heidecke

function exercise4()
I = imread('clooney.jpg');
cut = 213;
figure;
I2 = cutAndSwap(I, cut);
imshow(I2);

end

function out = cutAndSwap(I, cut)
% cut the image I along the column cut and swap both sides
out = horzcat(I(:, cut+1:end, :), I(:, 1:cut, :));
end