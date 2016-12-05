function show_results(I, labels, centroids)
    width = size(I,2);
    height = size(I,1);
    labels = reshape(labels, height, width) - min(labels);
    
    
    subplot(1,3,1)
    imshow(I)
    title('Original (RGB)')
    
    ax1 = subplot(1,3,2);
    imshow(labels/max(max(labels)))
    colormap(ax1, 'gray')
    title('Labels (grayscale)')
    
    ax2 = subplot(1,3,3);
    colors = centroids(:,1:3)/255.0;
    colormap(ax2, colors)
    imagesc(labels)
    axis image
    axis off
    title('Labels (colored with centroid)')
    %colorbar
end