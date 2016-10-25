% Computational Vision
% Student names: ...
%
% >> OBJECTIVE: 
% 1) Analize the code
% 2) Understand the function of each part of the code
% 3) Code the missing parts
% 4) Execute the code and check the results
% 5) Comment the experiments and results in a report

% main function
function FD_ex1()

clc; close all; clear;

%% Initialization
% Define Viola & Jones parameters for the first two feature masks
% SEE THE ATTACHED IMAGE FOR DETAILS!!!
L = 80;                            % mask size [px]
d1 = 10; d2 = 15; d3 = 20; d4 = 10; % distances from the border
w1 = 50; w2 = 20; w3 = 20;          % width of the rectangles
h1 = 10; h2 = 20;                   % height of the rectangles

% L = 50;                            % mask size [px]
% d1 = 10; d2 = 15; d3 = 20; d4 = 10; % distances from the border
% w1 = 30; w2 = 10; w3 = 10;          % width of the rectangles
% h1 = 10; h2 = 20;                   % height of the rectangles


%% Draw the 2 feature masks (just for visualization purpose)
m1 = zeros(L,L);
m2 = zeros(L,L);

m1(d1+1:d1+h1,d2+1:d2+w1) = 1;
m1(d1+1+h1:d1+2*h1,d2+1:d2+w1) = 2;
figure(1);
imagesc(m1);
title('Rectangular mask for feature 1');
axis square;
colormap([128 128 128; 0 0 0; 255 255 255]/255);

m2(d3+1:d3+h2,d4+1:d4+w2) = 1;
m2(d3+1:d3+h2,d4+w2+1:d4+w2+w3) = 2;
m2(d3+1:d3+h2,d4+w2+w3+1:d4+2*w2+w3) = 1;
figure(2);
imagesc(m2);
title('Rectangular mask for feature 2');
axis square;
colormap([128 128 128; 0 0 0; 255 255 255]/255);


%% Load image, compute Integral Image and visualize it

% Load image 'NASA1.jpg' and convert image from rgb to grayscale 
I = rgb2gray(imread('NASA1.bmp'));

% Compute the Integral Image
S = cumsum(cumsum(double(I),2));
imshow(S/S(end));
title('(Normalized) Integral image')


%% Compute features for regions with faces

% (X,Y) coordinates of the top-left corner of windows with face
X = [193 340 444 573 717 834 979 1066 1224 195 445 717 964 1200];
Y = [118 151 112 177 114 177 121 184 127 270 298 279 285 295];
XY_FACE =  [X' Y'];    %[x1 y1; x2 y2 .....]

% Initialize the feature matrix for faces
FEAT_FACE = zeros(size(XY_FACE,1),2);

for i = 1:size(XY_FACE,1)
    
    % current top-left corner coordinates
     x = XY_FACE(i,1); 
     y = XY_FACE(i,2);
    
    % compute area of regions A and B for the first feature
    % HERE WE USE INTEGRAL IMAGE!
    area_A = S(y+d1+h1,x+d2+w1) - S(y+d1+1,x+d2+w1) - (S(y+d1+h1,x+d2+1) - S(y+d1+1,x+d2+1));
    area_B = S(y+2*h1+d1,x+w1+d2) - S(y+d1+h1+1,x+d2+w1) - (S(y+d1+2*h1,x+d2+1)-S(y+d1+h1+1,x+d2+1));
    
    % compute area of regions C, D and E for the second feature
    % HERE WE USE INTEGRAL IMAGE!
    area_C = S(y+d3+h2,x+d4+w2) - S(y+d3,x+d4+w2) - S(y+d3+h2,x+d4) + S(y+d3,x+d4);
    area_D = S(y+d3+h2,x+d4+w2+w3) - S(y+d3,x+d4+w2+w3) - S(y+d3+h2,x+d4+w2) + S(y+d3,x+d4+w2);
    area_E = S(y+d3+h2,x+d4+2*w2+w3) - S(y+d3,x+d4+2*w2+w3) - S(y+d3+h2,x+d4+w2+w3) + S(y+d3,x+d4+w2+w3);
    
    % compute features value
    F1 = area_B - area_A;
    F2 = area_D - (area_C + area_E);
    
    % cumulate the computed values
    FEAT_FACE(i,:) = [F1 F2];
    
end

%% Compute features for regions with non-faces

% (X,Y) coordinates of the top-left corner of windows with non-face
X=[ 28 307 574 829 1093 203 350 523 580 800 931 1127 692 1265];
Y=[ 36    28    27    30    46   768   757   742   859   745   912   777   994   820];
XY_NON_FACE = [X' Y'];

% Initialize the feature matrix for non-faces
FEAT_NON_FACE = zeros(size(XY_NON_FACE,1),2);

for i = 1:size(XY_NON_FACE,1)
    
    % current top-left corner coordinates
    x = XY_NON_FACE(i,1); y = XY_NON_FACE(i,2);
    
    % compute area of regions A and B for the first feature
    % HERE WE USE INTEGRAL IMAGE!
    area_A = S(y+d1+h1,x+d2+w1) - S(y+d1+1,x+d2+w1) - (S(y+d1+h1,x+d2+1) - S(y+d1+1,x+d2+1));
    area_B = S(y+2*h1+d1,x+w1+d2) - S(y+d1+h1+1,x+d2+w1) - (S(y+d1+2*h1,x+d2+1)-S(y+d1+h1+1,x+d2+1));
    
    % compute area of regions C, D and E for the second feature
    % HERE WE USE INTEGRAL IMAGE!
    area_C = S(y+d3+h2,x+d4+w2) - S(y+d3,x+d4+w2) - S(y+d3+h2,x+d4) + S(y+d3,x+d4);
    area_D = S(y+d3+h2,x+d4+w2+w3) - S(y+d3,x+d4+w2+w3) - S(y+d3+h2,x+d4+w2) + S(y+d3,x+d4+w2);
    area_E = S(y+d3+h2,x+d4+2*w2+w3) - S(y+d3,x+d4+2*w2+w3) - S(y+d3+h2,x+d4+w2+w3) + S(y+d3,x+d4+w2+w3);
    
    % compute features value
    F1 = area_B - area_A;
    F2 = area_D - (area_C + area_E);
    
    % cumulate the computed values
    FEAT_NON_FACE(i,:) = [F1 F2];
    
end

%% Visualize samples in the feature space
figure(3)
hold on
scatter(FEAT_FACE(:,1),FEAT_FACE(:,2),'g');
scatter(FEAT_NON_FACE(:,1),FEAT_NON_FACE(:,2),'r');
xlabel('Feature 1');
ylabel('Feature 2');
title('Feature space');


%% Visualize image with used regions
figure(4);
imshow(I);

% patches with faces
for i = 1:size(XY_FACE,1)
    PATCH = [XY_FACE(i,:) L L];
    Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
    hold on;
    plot (Rectangle(:,1), Rectangle(:,2), 'g');
    hold off;
end

% patches without faces
for i = 1:size(XY_NON_FACE,1)
    PATCH = [XY_NON_FACE(i,:) L L];
    Rectangle = [PATCH(1) PATCH(2); PATCH(1)+PATCH(3) PATCH(2); PATCH(1)+PATCH(3) PATCH(2)+PATCH(4); PATCH(1)  PATCH(2)+PATCH(4); PATCH(1) PATCH(2)];
    hold on;
    plot (Rectangle(:,1), Rectangle(:,2), 'r');
    hold off;
end



%% Part 2:

%% Define the new regions of the test image 

% Load image 'NASA2.bmp' and convert image from rgb to grayscale 
I = rgb2gray(imread('NASA2.bmp'));

% Select regions with FACES and NON-FACES
figure(), imshow(I);
[x1, y1] = ginput();

% You could use ginput only once and then copy the coordinates
% >> copy coordinates here: <<
% x1 = ...
% y1 = ...

x1 = round(x1);
y1 = round(y1);

% (X,Y) coordinates of the top-left corner of windows with face
XY_TEST = [x1 y1];

  
%% Compute features for these new regions
% Compute the Integral Image
% >> code here <<

% Initialize the feature matrix for faces
FEAT_TEST = [];

for i = 1:size(XY_TEST,1)
    
    % current top-left corner coordinates
    x = XY_TEST(i,1);
    y = XY_TEST(i,2);
    
    % compute area of regions A and B for the first feature
    % HERE WE USE INTEGRAL IMAGE!
    area_A = S(y+d1+h1,x+d2+w1) - S(y+d1+1,x+d2+w1) - (S(y+d1+h1,x+d2+1) - S(y+d1+1,x+d2+1));
    area_B = S(y+2*h1+d1,x+w1+d2) - S(y+d1+h1+1,x+d2+w1) - (S(y+d1+2*h1,x+d2+1)-S(y+d1+h1+1,x+d2+1));
    
    % compute area of regions C, D and E for the second feature
    % HERE WE USE INTEGRAL IMAGE!
    % >> code to compute the area of regions C and E <<
    %     area_C = ...
    %     area_D = ...
    %     area_E = ...
    
    % compute features value
    F1 = area_B - area_A;
    F2 = area_D - (area_C + area_E);

    % cumulate the computed values
    FEAT_TEST = [FEAT_TEST; [F1 F2]];
    
end


%% Train a k-nn classifier and test the new windows
features_train = [FEAT_FACE; FEAT_NON_FACE];
Group = [repmat(1, length(FEAT_FACE), 1); repmat(2, length(FEAT_NON_FACE), 1)];
% Call the function knnclassify
% >> code here <<


%% Visualize samples in the feature space
% First, visualize the training samples:
figure();
hold on
scatter(FEAT_FACE(:,1),FEAT_FACE(:,2),'g');
scatter(FEAT_NON_FACE(:,1),FEAT_NON_FACE(:,2),'r');
xlabel('Feature 1');
ylabel('Feature 2');
title('Feature space');

% Second, visualize the test samples in two different colors
% >> code here <<


%% Visualize classification results in the test image

% Visualize image 'NASA2.bmp' with used regions
% >> code here <<

end





