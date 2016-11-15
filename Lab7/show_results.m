function show_results(width, height, labels, colors)
    colors = colors/255.0;
    colormap(colors)
    labels = reshape(labels, height, width);
    imagesc(labels)
    colorbar
end