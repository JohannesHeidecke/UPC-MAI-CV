% Run SIFT implementation:
run('vlfeat-0.9.16/toolbox/vl_setup');

I = vl_impattern('roofs1');
I = single(rgb2gray(I));

% Extract SIFT keypoints and save them.
% f: keypoints (center, scale, orientation)
% d: descriptors of keypoints
% keypoints ordered by ascending scale.

% [f,d] = vl_sift(I);
% size(f)

% Show only the 50 largest keypoints:
% show_keypoints(I, f(:, end-50:end));

% Show only 50 random keypoints:
% show_keypoints(I,random_selection(f,50));

% Select keypoints with thresholds:
% [f,d] = vl_sift(I,'PeakThresh', 0.04, 'EdgeThresh', 10);
% size(f)
% Show selected interesting keypoints:
% figure;
% subplot(2, 2, 1);
% show_keypoints(I, f(:, end-2));
% title('Keypoint A, scale: 13.6');
% subplot(2, 2, 2);
% show_keypoints(I, f(:, end-4));
% title('Keypoint B, scale: 12.3');
% subplot(2, 2, 3);
% show_keypoints(I, f(:, end-30));
% title('Keypoint C, scale: 6.8');
% subplot(2, 2, 4);
% show_keypoints(I, f(:, end-505));
% title('Keypoint D, scale: 2.3');

% Question 2:

% figure;
% [f,d] = vl_sift(I);
% subplot(1, 2, 1);
% show_keypoints(I, f);
% title('Keypoints without peak threshold');
% [f,d] = vl_sift(I,'PeakThresh', 0.01);
% subplot(1, 2, 2);
% show_keypoints(I,f);
% title('Keypoints with peak threshold of 0.01');

% Question 3: 
%  ivals = 0:0.005:0.1;
%  keypN = ones(size(ivals));
%  for i = 1:length(ivals)
%      [f,d] = vl_sift(I,'PeakThresh', ivals(i));
%      keypN(i) = size(f, 2);
%  end
%  
% plot(ivals, keypN, 'LineWidth',3)
% title('Number of keypoints on roofs1 for different peak thresholds');
% xlabel('peak threshold');
% ylabel('number of keypoints detected');


% figure;
% [f,d] = vl_sift(I,'PeakThresh', 0.01);
% subplot(1, 3, 1);
% show_keypoints(I, f);
% title('Keypoints with peak threshold of 0.01');
% [f,d] = vl_sift(I,'PeakThresh', 0.04);
% subplot(1, 3, 2);
% show_keypoints(I,f);
% title('Keypoints with peak threshold of 0.04');
% [f,d] = vl_sift(I,'PeakThresh', 0.06);
% subplot(1, 3, 3);
% show_keypoints(I,f);
% title('Keypoints with peak threshold of 0.06');

% Question 4:



