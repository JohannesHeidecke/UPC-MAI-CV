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
[xN,yN]=snake(x,y,0.1,0.01,0.2*kappa,0.06,px,py,0.4,1,img);


figure(3) ;
clf ; imagesc(img) ; colormap(gray) ; hold on ;
axis image ; axis off ;
plot([xN;xN(1)],[yN;yN(1)],'r','LineWidth',2) ; hold off ;


