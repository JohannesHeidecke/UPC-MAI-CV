function PCAImagesDim = apply_pca(images, dim)
% APPLY_PCA 
% PCAImagesDim It returns the matrix with reduced attributes.
% Each column is an image
% 

%% PCA
% Use princomp.m to compute:
[PCACoefficients, PCAImages, PCAValues] = princomp(images);

%% Show the 30 first eigenfaces
show_eigenfaces(PCACoefficients);

%% Plot the explained variance using 100 dimensions
PoVs = zeros(1, size(PCAValues,1));
denominator = sum(PCAValues);
numerator = 0;
for i = 1:1:size(PCAValues,1)
    numerator = numerator + PCAValues(i, :);
    PoVs(i) = numerator / denominator;
end
figure;
plot(1:1:size(PCAValues,1), PoVs);
xlabel('Dimensions');
ylabel('Proportion of Explained Variance')

%% Keep the first 'dim' dimensions where dim is given or computed as the
%% dimensions necessary to preserve 90% of the data variance.
if dim>0
    PCAImagesDim = PCAImages(:,1:dim);
else
    % Compute the number of dimensions necessary to preserve 95% of the data variance.
    requiredDims = find(PoVs >= 0.95, 1);
    PCAImagesDim = PCAImages(:,1:requiredDims);
    
end
end
