function show_results(I, labels, centroids)
% Authors: A. Suarez & J. Heidecke
    width = size(I,2);
    height = size(I,1);
    labels = reshape(labels, height, width);
    
    
    subplot(1,3,1)
    imshow(I)
    title('Original (RGB)')
    
    subplot(1,3,2)
    gs = (labels - min(min(labels)))/max(max(labels));
    subimage(gs)
    axis off
    title('Labels (grayscale)')
    
    subplot(1,3,3)
    colors = centroids(:,1:3)/255.0;
    subimage(labels, colors)
    axis off
    title('Labels (colored with centroid)')
    %colorbar
end