function tag_images_texture()

load GroundTruth.mat
N = length(Y);

% The images are ordered by time, with very similar images next to each
% other, so mess them all a litle bit:
rand('seed', 42); % do not change if loading X from Features-s42.mat!!
Y = Y(randperm(length(Y)));

train_Y = Y(1:100);
train_Y = cellfun(@str2num, {train_Y.tag})';

test_Y = Y(101:end);
test_Y = cellfun(@str2num, {test_Y.tag})';

% To save time: load precomputed descriptors from file
if 0
    F = makeLMfilters();
    Rs = [];
    completed = 0;
    hpb = waitbar(0, 'Obtaining texture descriptors: 0%');
    for image={Y.name}
        newR = [];
        I = imread(['materialLab10/', cell2mat(image)]);
        I = im2double(I);
        % In order to reduce the runtime, we resize the image to 20% 
        % Warning: do not decrease size below filter sizes.
        I = imresize(I, 0.2);
        mR = getMeanColorChannelValue(I, 1);
        mG = getMeanColorChannelValue(I, 2);
        mB = getMeanColorChannelValue(I, 3);
        Rcol = [mR; mG; mB];
        newR = [newR Rcol'];
        I = rgb2gray(I);
        R = getResponses(I, F);
        Rsd = getResponseSd(R);
        newR = [newR Rsd'];
        Rs = [Rs; newR];
        completed = completed + 1;
        waitbar(completed/N, hpb, sprintf('Obtaining texture descriptors: %f%%', completed/N*100));  
    end
    close(hpb)
    save('Textures-s42.mat', 'Rs');
else
    % Load Rs from file to save runtime
    load('Textures-s42.mat');
end

train_Rs = Rs(1:100, :);
test_Rs = Rs(101:end, :);

ks =[];
accs = [];
bestAcc = 0;
bestK = 0;
bestConfusion = 0;
for k=3:2:97
    test_Y_ = zeros(size(test_Y));
    for i = 1:length(test_Y)
        knn = knnsearch(train_Rs, test_Rs(i, :), 'k', k, 'distance', 'seuclidean');
        if sum(test_Y(knn)) > floor(k/2)
            test_Y_(i) = 1;
        end
    end

    TP = sum(test_Y & test_Y_);
    TN = sum(~test_Y & ~test_Y_);
    FP = sum(~test_Y & test_Y_);
    FN = sum(test_Y & ~test_Y_);
    Confusion = [TP, FP; FN, TN];
    Acc = (TP+TN) / (TP + TN + FP + FN);
    ks = [ks k];
    accs = [accs Acc];
    if Acc > bestAcc
        bestAcc = Acc;
        bestK = k;
        bestConfusion = Confusion;
    end
end

figure;
plot(ks, accs);
bestConfusion
bestAcc
bestK


end

function F=makeLMfilters

% Returns the LML filter bank of size 49x49x48 in F. To convolve an
% image I with the filter bank you can either use the matlab function
% conv2, i.e. responses(:,:,i)=conv2(I,F(:,:,i),'valid'), or use the
% Fourier transform.

  SUP=49;                 % Support of the largest filter (must be odd)
  SCALEX=sqrt(2).^[1:3];  % Sigma_{x} for the oriented filters
  NORIENT=6;              % Number of orientations

  NROTINV=12;
  NBAR=length(SCALEX)*NORIENT;
  NEDGE=length(SCALEX)*NORIENT;
  NF=NBAR+NEDGE+NROTINV;
  F=zeros(SUP,SUP,NF);
  hsup=(SUP-1)/2;
  [x,y]=meshgrid([-hsup:hsup],[hsup:-1:-hsup]);
  orgpts=[x(:) y(:)]';

  count=1;
  for scale=1:length(SCALEX),
    for orient=0:NORIENT-1,
      angle=pi*orient/NORIENT;  % Not 2pi as filters have symmetry
      c=cos(angle);s=sin(angle);
      rotpts=[c -s;s c]*orgpts;
      F(:,:,count)=makefilter(SCALEX(scale),0,1,rotpts,SUP);
      F(:,:,count+NEDGE)=makefilter(SCALEX(scale),0,2,rotpts,SUP);
      count=count+1;
    end;
  end;
  
  count=NBAR+NEDGE+1;
  SCALES=sqrt(2).^[1:4];
  for i=1:length(SCALES),
    F(:,:,count)=normalise(fspecial('gaussian',SUP,SCALES(i)));
    F(:,:,count+1)=normalise(fspecial('log',SUP,SCALES(i)));
    F(:,:,count+2)=normalise(fspecial('log',SUP,3*SCALES(i)));
    count=count+3;
  end;
return
end

function f=makefilter(scale,phasex,phasey,pts,sup)
  gx=gauss1d(3*scale,0,pts(1,:),phasex);
  gy=gauss1d(scale,0,pts(2,:),phasey);
  f=normalise(reshape(gx.*gy,sup,sup));
return
end

function g=gauss1d(sigma,mean,x,ord)
% Function to compute gaussian derivatives of order 0 <= ord < 3
% evaluated at x.

  x=x-mean;num=x.*x;
  variance=sigma^2;
  denom=2*variance;  
  g=exp(-num/denom)/(pi*denom)^0.5;
  switch ord,
    case 1, g=-g.*(x/variance);
    case 2, g=g.*((num-variance)/(variance^2));
  end;
return
end

function f=normalise(f), f=f-mean(f(:)); f=f/sum(abs(f(:))); 
return 
end

function R = getResponses(I, F)
    rSize = size(conv2(I, F(:,:,1), 'valid')); 
    R = zeros(rSize(1), rSize(2), size(F,3));
    for k = 1:size(F,3)
        R(:,:,k) = conv2(I, F(:,:,k), 'valid');
    end
end

function Rsd = getResponseSd(R)
    Rsd = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rsd(k) = std(Rv);
    end
end

function cm = getMeanColorChannelValue(I, channel)
    Iv = reshape(I(:,:,channel), [1, numel(I(:,:,channel))]);
    cm = mean(Iv);
end