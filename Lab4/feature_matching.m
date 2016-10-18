% You should run this before running this script (with the correct path to
% vlfeat).
% run('../../vlfeat-0.9.16/toolbox/vl_setup');

Ia = imread('images/im2_ex1.jpg');
Ib = imread('images/im1_ex1.jpg');
Ia = single(rgb2gray(Ia));
Ib = single(rgb2gray(Ib));
imshow([Ia Ib],[])
[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);
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