% feature_matching.m
% by Heidecke, Johannes & Suarez Hernandez, Alejandro

% You should run this before running this script (with the correct path to
% vlfeat).
% run('../../vlfeat-0.9.16/toolbox/vl_setup');


%% Load images and convert to 32bit float grayscale images

Ia = single(rgb2gray(imread('images/im2_ex1.jpg')));
Ib = single(rgb2gray(imread('images/im1_ex1.jpg')));
imshow([Ia Ib],[])

%% Compute features

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);

%% Compute matches and show between images using different threshold values.

[matches1, scores1] = vl_ubcmatch(da, db); % The default value of THRES is 1.5

[matches2, scores2] = vl_ubcmatch(da, db, 2.0);

[matches3, scores3] = vl_ubcmatch(da, db, 1.0);

show_matches(Ia,Ib,fa,fb,matches1);
title('Threshold ratio: 1.5')

figure
show_matches(Ia,Ib,fa,fb,matches2);
title('Threshold ratio: 2.0')

figure
show_matches(Ia,Ib,fa,fb,matches3);
title('Threshold ratio: 1.0')

%%  On introducing a motion model. Clearly the best results are found when
%   using the matches obtained with THR=2.0

d = fb(:,matches2(2,:))-fa(:,matches2(1,:));
p = mean(d,2);
display(['t_x=',num2str(p(1)),', t_y=',num2str(p(2))])

show_matches_linear_model(Ia,Ib,fa,fb,p);
title('Result of introducing a linear model with THR=2.0')

%% On switching from a translational model to an afine one.

d = fb(1:2,matches2(2,:))-fa(1:2,matches2(1,:));
i = size(d, 2);
A = zeros(6,6);
b = zeros(6,1);
for j = 1:i,
    x = fa(1:2,matches2(1,j));
    J = [x(1), x(2), 0, 0, 1, 0; 0, 0, x(1), x(2), 0, 1];
    A = A + J'*J;
    b = b + J'*d(1:2,j);
end
p = A\b;
display(['a_1=',num2str(p(1)),', a_2=',num2str(p(2)),', a_3=',num2str(p(3)),', a_4=',num2str(p(4)),', t_x=',num2str(p(5)),', t_y=',num2str(p(6))])

show_matches_affine_model(Ia,Ib,fa,fb,p);
title('Result of introducing an afine model with THR=2.0')

%% Using just a subset with the best matches

N = 9;
[Y I] = sort(scores1);
matches_sorted = matches1(:,I);
show_matches(Ia,Ib,fa,fb,matches_sorted(:,1:N));

%% Linear model with just the best matches

d = fb(1:2,matches_sorted(2,1:N))-fa(1:2,matches_sorted(1,1:N));
p = mean(d,2);
show_matches_linear_model(Ia,Ib,fa,fb,p);
title('Linear model with fit with just the best matches')

%% Afine model with just the best matches

d = fb(1:2,matches_sorted(2,1:N))-fa(1:2,matches_sorted(1,1:N));
i = size(d, 2);
A = zeros(6,6);
b = zeros(6,1);
for j = 1:i,
    x = fa(1:2,matches_sorted(1,j));
    J = [x(1), x(2), 0, 0, 1, 0; 0, 0, x(1), x(2), 0, 1];
    A = A + J'*J;
    b = b + J'*d(1:2,j);
end
p = A\b;
show_matches_affine_model(Ia,Ib,fa,fb,p);
title('Afine model with fit with just the 9 best matches')

