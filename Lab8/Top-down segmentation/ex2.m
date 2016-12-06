img=imread('images/bird.png') ;

s = 0.5; % scale factor. We scale down the image to accelerate a bit the process

img = imresize(img, s);
% img = imnoise(img, 'gaussian', 0, 0.000125); % add white gaussian noise
img = imnoise(img, 'salt & pepper', 0.00001); % add salt and pepper noise


load birdxy

x = x*s;
y = y*s;


% clf ; imagesc(img) ; colormap(gray) ; hold on ;
% axis image ; axis off ;
% plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; 
% hold off ;
% waitforbuttonpress

f=double(img) ; f=f(:,:,1)*0.5+f(:,:,2)*0.5-f(:,:,3)*1 ;
f=f-min(f(:)) ; f=f/max(f(:)) ;
f=(f>0.25).*f ;
h=fspecial('gaussian',20,3*s) ;
f=imfilter(double(f),h,'symmetric') ;

% figure
% imagesc(f) ; colormap(jet) ; colorbar ;
% axis image ; axis off ;
% waitforbuttonpress

[px,py] = gradient(-f);
% figure; imshow(px/max(px(:)));
% figure; imshow(py/max(py(:)));
% waitforbuttonpress

kappa=1/(max(max(px(:)),max(py(:)))) ;
[x_,y_]=snake(x,y,0.1,0.1,0.3*kappa,-0.05,px,py,0.1,0,f);
% [x_,y_]=snake(x,y,0.1,0.1,0.4*kappa,-0.08,px,py,0.2,0,f);
% [x_,y_]=snake(x,y,0.1,0.1,0.8*kappa,-0.08,px,py,0.4,0,f);
clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;

% for alpha=[0.02, 0.05, 0.1, 0.15, 0.2]
%     [x_,y_]=snake(x,y,alpha,0.1,0.3*kappa,-0.05,px,py,0.4,0,f);
%     figure
%     clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
%     plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;
%     title(['\alpha=',num2str(alpha)])
% end

% for beta=[0.01, 0.03, 0.06, 0.09, 0.1]
%     [x_,y_]=snake(x,y,0.1,beta,0.3*kappa,-0.05,px,py,0.4,0,f);
%     figure
%     clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
%     plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;
%     title(['\beta=',num2str(beta)])
% end

% for kappa_coef=[0.25, 0.3, 0.4, 1]
%     [x_,y_]=snake(x,y,0.1,0.1,kappa_coef*kappa,-0.05,px,py,0.4,0,f);
%     figure
%     clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
%     plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;
%     title(['\kappa`=',num2str(kappa_coef)])
% end

% for lambda=[-0.02, -0.04, -0.05, -0.055, -0.06]
%     [x_,y_]=snake(x,y,0.1,0.1,0.3*kappa,lambda,px,py,0.4,0,f);
%     figure
%     clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
%     plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;
%     title(['\lambda=',num2str(lambda)])
% end

% for maxstep=[0.001, 0.01, 0.4, 1]
%     [x_,y_]=snake(x,y,0.1,0.1,0.3*kappa,-0.05,px,py,maxstep,0,f);
%     figure
%     clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
%     plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;
%     title(['maxstep=',num2str(maxstep)])
% end
