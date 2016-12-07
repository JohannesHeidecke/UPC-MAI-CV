
%% read and scale down

img=imread('images/dishes/PB070012.JPG') ;

s = 0.25; % scale factor. We scale down the image to accelerate a bit the process

img = imresize(img, s);
img_gray = double(rgb2gray(img));

%% apply snakes

% Initial contour: 
t = (0:0.5:2*pi)';
x = 80 + 3*cos(t); 
y = 70 + 3*sin(t);


% imagesc(img) ; hold on ;
% axis image ; axis off ;
% plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; 
% hold off ;
% waitforbuttonpress

f=img_gray;
f=f-min(f(:)) ; f=f/max(f(:)) ;
h=fspecial('gaussian',20,3*s) ;
f=imfilter(f,h,'symmetric') ;

% figure
% imagesc(f) ; colormap(jet) ; colorbar ;
% axis image ; axis off ;
% waitforbuttonpress

[px,py] = gradient(-f);

% figure; imshow(px/max(px(:)));
% figure; imshow(py/max(py(:)));
% waitforbuttonpress

kappa=1/(max(max(px(:)),max(py(:)))) ;

% [x_,y_]=snake(x,y,0.1,0.1,0.3*kappa,-0.05,px,py,0.1,0,f);
%[x_,y_]=snake(x,y,0.1,0.03,0.8*kappa,-0.08,px,py,0.4,0,f);
[x_,y_]=snake(x,y,0.1,0.1,0.2*kappa,0.05,px,py,0.4,1,f);
% [x_,y_]=snake(x,y,0.1,0.1,0.8*kappa,-0.08,px,py,0.4,0,f);
clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
plot([x_;x_(1)],[y_;y_(1)],'r','LineWidth',2) ; hold off ;

%% apply level sets

[height, width] = size(img_gray);
[x,y] = meshgrid(1:width, 1:height);
f = sqrt((x-80).^2 + (y-70).^2)-2.5;
g = ones(height,width);

figure(1) ; clf ;
imagesc(img_gray) ; colormap(gray) ; axis equal ; axis tight ; hold on ; 
contour(f,[0 0],'r') ; hold off ; colorbar ;
print -depsc output_images/levelset_input_dish.eps
figure(2) ;imagesc(f) ; colorbar ;
hold on ; 
contour(f,[0 0],'k') ; hold off ; 
print -depsc output_images/levelset_lsetinput_dish.eps

f1=levelset(f,img_gray,0,250,100,200,0.5,0.5,0.05,g,1) ;
%g=ones(size(f)) ;
%f1=levelset(f,img,0,0,10,110,1,1,0.1,g) ;

figure(3) ;imagesc(img_gray) ; colormap(gray) ; axis equal ; axis tight ; hold on ; 
contour(f1,[0 0],'r') ; hold off ; colorbar ;

print -depsc output_images/levelset_output_dish.eps
figure(4) ;imagesc(f1,[-100 100]) ; colorbar ;
hold on ; 
contour(f1,[0 0],'k') ; hold off ; 
print -depsc output_images/levelset_lsetoutput_dish.eps

