function main

   F = getFilters();
   % visualizeFilters(F, 'jet');
   
   
   I = imread('texturesimages/forest/forest_1.jpg');
   I = im2double(I);
   I = rgb2gray(I);
   
   R = getResponses(I, F);
   visualizeResponses(R, 'jet');

   % showHorVerHistograms(F);
   
   featureModes = [1 0 0 0 0 1];
   [RsF fsF] = getClassFeatures('forest', '.jpg', F, featureModes);
   [RsB fsB] = getClassFeatures('buildings', '.jpg', F, featureModes);
   [RsS fsS] = getClassFeatures('sunset', '.jpg', F, featureModes);
     
   % visualizeFeatures(RsF, RsB, RsS, [1 17 45]);
   % visualizeFeatures(RsF, RsB, RsS, [41 25]);
   %visualizeFeatures(RsF, RsB, RsS, [41 25 38]);
   
   RsAll = [RsF; RsB; RsS];
   fsAll = [fsF; fsB; fsS];
   
   visualizeKNN(RsAll, fsAll, 9);
   
   
end

function visualizeFeatures(RsF, RsB, RsS, fIndices)

    figure;
    if numel(fIndices) == 2
        scatter(RsF(:,fIndices(1)), RsF(:,fIndices(2)), 'green', 'filled')
        hold on
        scatter(RsB(:,fIndices(1)), RsB(:,fIndices(2)), 'blue', 'filled')
        hold on
        scatter(RsS(:,fIndices(1)), RsS(:,fIndices(2)), 'red', 'filled')
        return
    else
        scatter3(RsF(:,fIndices(1)), RsF(:,fIndices(2)), RsF(:,fIndices(3)), 'green', 'filled')
        hold on
        scatter3(RsB(:,fIndices(1)), RsB(:,fIndices(2)), RsB(:,fIndices(3)), 'blue', 'filled')
        hold on
        scatter3(RsS(:,fIndices(1)), RsS(:,fIndices(2)), RsB(:,fIndices(3)), 'red', 'filled')
        view(-30,10)
    end
    
    

end

function [Rs, fileNames] = getClassFeatures(dir, extension, F, featureModes)

    Rs = [];
    fileNames = [];

    for k = 1:30
        fileName = strcat('texturesimages/', dir, '/', dir, '_', int2str(k) , extension);
        
        Ior = imread(fileName);
        I = im2double(Ior);
        I = rgb2gray(I);
        
        R = getResponses(I, F);
        newR = [];
        if featureModes(1) == 1
            Rm = getResponseMeans(R);
            newR = [newR Rm'];
        end
        if featureModes(2) == 1
            Rsd = getResponseSd(R);
            newR = [newR Rsd'];
        end
        if featureModes(3) == 1
             Rmin = getResponseMin(R);
             newR = [newR Rmin'];
        end
        if featureModes(4) == 1
            Rmax = getResponseMax(R);
            newR = [newR Rmax'];
        end
        if featureModes(5) == 1
            Rmed = getResponseMedian(R);
            newR = [newR Rmed'];
        end
        if featureModes(6) == 1
           mR = getMeanColorChannelValue(Ior, 1);
           mG = getMeanColorChannelValue(Ior, 2);
           mB = getMeanColorChannelValue(Ior, 3);
           Rcol = [mR; mG; mB];
           newR = [newR Rcol'];
        end
        
        Rs = [Rs; newR];
        fileName = strcat(fileName, '                                                                .');
        fileName = fileName(1:50);
        fileNames = vertcat(fileNames, fileName);
        
    end
    
end

function kNN = getKNN(RsAll, rowIndex)
    kNN = knnsearch(RsAll, rowIndex, 'k', 10, 'distance', 'seuclidean');
    kNN = kNN(2:end);
end

function visualizeKNN(RsAll, fsA, rowIndex)
    knn = getKNN(RsAll, RsAll(rowIndex, :));
    figure;
    subplot(4, 3, 2);
    imshow(strtrim(fsA(rowIndex, :)));
    for i=1:size(knn, 2)
        subplot(4, 3, 3+i);
    imshow(strtrim(fsA(knn(i), :)));
    end
    
    
end

function F = getFilters()
    F = makeLMfilters();
end

function visualizeFilters(F, mode)
    figure, % visualize the filters for k=1:size(F,3);
    for k=1:size(F,3)
        subplot(8,6,k);
        colormap(mode);
        imagesc(F(:,:,k)); colorbar;
    end
end

function visualizeResponses(R, mode)
    figure;
    smallest = min(min(min(R)));
    largest = max(max(max(R)));
    for k = 1:size(R,3)
        subplot(8,6,k);
        C = R(:,:,k);
        colormap(mode);
        imagesc(C, [smallest largest]); % colorbar;
        % imagesc(C);
    end
end

function R = getResponses(I, F)
    rSize = size(conv2(I, F(:,:,1), 'valid')); 
    R = zeros(rSize(1), rSize(2), size(F,3));
    for k = 1:size(F,3)
        R(:,:,k) = conv2(I, F(:,:,k), 'valid');
    end
end

function Rm = getResponseMeans(R)
    Rm = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rm(k) = mean(Rv);
    end
end

function Rsd = getResponseSd(R)
    Rsd = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rsd(k) = std(Rv);
    end
end

function Rmin = getResponseMin(R)
    Rmin = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rmin(k) = min(Rv);
    end
end

function Rmax = getResponseMax(R)
    Rmax = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rmax(k) = max(Rv);
    end
end

function Rmed = getResponseMedian(R)
    Rmed = zeros(size(R, 3), 1);
    for k = 1:size(R,3)
        Rv = reshape(R(:,:,k), [1 numel(R(:,:,k))]);
        Rmed(k) = median(Rv);
    end
end

function cm = getMeanColorChannelValue(I, channel)
    Iv = reshape(I(:,:,channel), [1, numel(I(:,:,channel))]);
    cm = mean(Iv);
end

function showHorVerHistograms(F)
    RmHor = [];
    RmVer = [];
    RsdHor = [];
    RsdVer = [];
    for k = 1:30
       I = imread(strcat('texturesimages/forest/forest_', int2str(k) , '.jpg'));
       I = im2double(I);
       I = rgb2gray(I);
       Fhor = F(:,:, [1, 7, 13, 19, 25, 31]);
       Fver = F(:,:, [4, 10, 16, 22, 28, 34]);
       Rhor = getResponses(I, Fhor);
       Rver = getResponses(I, Fver);
       RmHor = [RmHor getResponseMeans(Rhor)];
       RmVer = [RmVer getResponseMeans(Rver)];
       RsdHor = [RsdHor getResponseSd(Rhor)];
       RsdVer = [RsdVer getResponseSd(Rver)];
    end
    figure;
    subplot(1, 2, 1);
    histogram(RmHor);
    hold on;
    histogram(RmVer);
    subplot(1, 2, 2);
    histogram(RsdHor);
    hold on;
    histogram(RsdVer);
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

