img=imread([ ImageDir 'bird.png']) ;

% Add Noise:

% Gaussian:
% img = imnoise(img,'gaussian',0, 0.0001);
% img = imnoise(img,'gaussian',0, 0.0002);

% Salt & Pepper:
img = imnoise(img,'salt & pepper',0.0001);
% img = imnoise(img,'salt & pepper',0.0002);


% Twist parameters:
% (Default: 0.1, 0.1, 0.3, -0.05, 0.4)
alpha = 0.1;
beta = 0.1;
k = 0.6;
lambda = -0.05;
maxstep = 0.4;


load birdxy;

figure(1) ;
clf ; imagesc(img) ; colormap(gray) ; hold on ;
axis image ; axis off ;
plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; 
hold off ;
exportfig(gcf,'output_images/snake_input2.eps') ;

f=double(img) ; f=f(:,:,1)*0.5+f(:,:,2)*0.5-f(:,:,3)*1 ;
f=f-min(f(:)) ; f=f/max(f(:)) ;
f=(f>0.25).*f ;
h=fspecial('gaussian',20,3) ;
f=imfilter(double(f),h,'symmetric') ;

figure(2) ;
imagesc(f) ; colormap(jet) ; colorbar ;
axis image ; axis off ; 
exportfig(gcf,'output_images/snake_energy2.eps') ;

[px,py] = gradient(-f);
kappa=1/(max(max(px(:)),max(py(:)))) ;
[x,y]=snake(x,y,alpha,beta,k*kappa,lambda,px,py,maxstep,1,f);

figure(3) ;
clf ; imagesc(img) ;  axis image ; axis off ; hold on ;
plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; hold off ;
exportfig(gcf,'output_images/snake_output2.eps') ;
