function panoramic = panorama_creation(filename1, filename2, varargin)
    % panorama_creation.m
    % by Heidecke, Johannes & Suarez Hernandez, Alejandro
    % Creates a panoramic image by means of feature extraction and
    % matching.
    % Arguments:
    %   -filename1: path to first image
    %   -filename2: path to second image
    %   -M (optional, default value=100): number of RANDSAC iterations
    %   -N (optional, default value=10): cardinality of RANDSAC subset
    %   -epsilon (opcional, default value=5): 
    % You should run this before running this script (with the correct path to
    % vlfeat).
    % run('../../vlfeat-0.9.16/toolbox/vl_setup');
    % Example(s) of usage:
    %   >> I = panorama_creation('images/im2_ex1.jpg', 'images/im1_ex1.jpg');
    %   >> imshow(I)
    %
    %   >> I = panorama_creation('images/under_the_sea_1.png', 'images/under_the_sea_2.png',150,15,4);
    %   >> imshow(I)

    %% Assign defaults and check arguments
    
    assert(nargin <= 5, 'Too many arguments')
    
    M = 100;
    N = 10;
    epsilon = 5;
    
    if nargin >= 3
        M = varargin{1};
    end
    
    if nargin >= 4
        N = varargin{2};
    end
    
    if nargin == 5
        epsilon = varargin{3};
    end

    %% Load images and convert to 32bit float grayscale images

    Ia = single(rgb2gray(imread(filename1)));
    Ib = single(rgb2gray(imread(filename2)));

    %% Compute features

    [fa, da] = vl_sift(Ia);
    [fb, db] = vl_sift(Ib);

    %% Match features

    [matches, ~] = vl_ubcmatch(da,db); % don't care about the scores
    numMatches = size(matches,2);
    xa = fa(1:2,matches(1,:));
    xb = fb(1:2,matches(2,:));

    %% execute RANSAC. Each loop executes the randsac_iteration method
    %  defined below.

    p_opt = [0;0];
    n_opt = 0;
    
    for iter=1:M
        [p,n] = randsac_iteration;
        if n > n_opt
            p_opt = p;
            n_opt = n;
        end
    end
    
    %% Now merge the images. We use the merge method defined below.
    
    panoramic = uint8(merge);
    
    % The following call to imshow is here for convenience. If this
    % function were to be distributed as part of a library, it should be
    % removed.
    
    imshow(panoramic)
    h = title(['Panoramic of ',filename1,' and ',filename2]);
    set(h,'interpreter','none') % don't treat the underscores as a control character

    %% We encapsulate some of the functionalities of the algorithm so the
    %  variables used in each method do not pollute the workspace
    
    function [p,n] = randsac_iteration()
        % This method implements a single RANDSAC iteration.
        % Makes a subset of size N and find the optimum translation
        % according to the LMS criteria.
        subset = vl_colsubset(1:numMatches, N);
        d = xb(:,subset) - xa(:,subset);
        p = mean(d,2);
        xb_ = xa + repmat(p,1,size(xa,2));
        delta = xb - xb_;
        norm_sq = diag(delta'*delta);
        n = length(norm_sq(norm_sq<epsilon^2));
    end

    
    function panoramic = merge()
        % This method merges Ia and Ib into a panoramic image. It uses the
        % previously calculated p_opt
        
        % Compute bounding box
        box2 = [1 size(Ia,2) size(Ia,2)          1;
                1          1 size(Ia,1) size(Ia,1)];
        box2_ = box2 + repmat(p,1,size(box2,2));

        min_x = min(1, min(box2_(1,:)));
        min_y = min(1, min(box2_(2,:)));
        max_x = max(size(Ib,2), max(box2_(1,:)));
        max_y = max(size(Ib,1), max(box2_(2,:)));
        
        % Merge images
        [u,v] = meshgrid(min_x:max_x, min_y:max_y);
        Ib_ = vl_imwbackward(im2double(Ib), u, v);
        
        p_inverse = -p_opt;
        u_ = u + p_inverse(1);
        v_ = v + p_inverse(2);
        Ia_ = vl_imwbackward(im2double(Ia),u_,v_);
        
        Ib_(isnan(Ib_)) = 0;
        Ia_(isnan(Ia_)) = 0;
        panoramic = max(Ib_, Ia_);
    end

end