ImageDir='images/';%directory containing the images

img = imread( [ImageDir 'heart.pgm'] );
t = [0:0.5:2*pi]';
x = 70 + 3*cos(t);
y = 90 + 3*sin(t);

% figure(1) ;
% imagesc(img);  colormap(gray);  axis image;  axis off;  hold on;
% plot( [x;x(1,1)], [y;y(1,1)], 'r', 'LineWidth',2 );  hold off;

h = fspecial( 'gaussian', 20, 3 );
f = imfilter( double(img), h, 'symmetric' );
f = f-min(f(:));  f = f/max(f(:));

% figure(2) ;
% imagesc(f) ; colormap(jet) ; colorbar ;
% axis image ; axis off ; 

[px,py] = gradient(-f);
kappa=1/max(abs( [px(:) ; py(:)])) ;
% alpha,beta,kappa, lambda
% [x,y]=snake(x,y,0.1,0.01,0.2*kappa,0.05,px,py,0.4,1,img);
[xN,yN]=snake(x,y,0.1,0.01,0.2*kappa,0.05,px,py,99999999999,1,img);


figure(3) ;
clf ; imagesc(img) ; colormap(gray) ; hold on ;
axis image ; axis off ;
plot([xN;xN(1)],[yN;yN(1)],'r','LineWidth',2) ; hold off ;

pxN = (px - min(min(px))) * (1.0 / (max(max(px)) - min(min(px))));
pyN = (py - min(min(py))) * (1.0 / (max(max(py)) - min(min(py))));

figure;
subplot(1,2,1);
imshow(pxN);
subplot(1,2,2);
imshow(pyN);

