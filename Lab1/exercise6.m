% MAI - CV
% Laboratory 1
% Exercise 6
% Deliverable by: Johannes Heidecke

function exercise6()
    H = imread('images/hand.jpg');
    M = imread('images/mapfre.jpg');
    HM = fuseImg(H, M, 20/255);
    figure;
    imshow(HM);
    title('Hand copied in front of tower');
end

function out = fuseImg(I1, I2, binThreshold)
%
% This function copies all pixels of I1 with a grayscale value above
% binThreshild onto I2.
%

% create the binarization of I1, using binThreshhold:
I1g = rgb2gray(I1);
B = im2bw(I1g, binThreshold);
% create inverted binarization:
IB = ~B;

% create IBrgb that can be used to be multiplied with RGB image I2: 
IBrgb = uint8(cat(3, IB, IB, IB));
% set all pixels of I2 to 0 that will be overwritten by I1 pixels later:
out = I2 .* IBrgb;

% create Brgb that can be used to be multiplied with RGB imag I1:
Brgb = uint8(cat(3, B, B, B));
% add all pixels of I1 that are 1 in the binarization to I2:
out = out + (I1 .* Brgb);

end