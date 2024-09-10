% (b) Create a cost function that takes a parameter vector p and the classification
% result of an image as input, and returns a scalar value, which describes how
% well the (from p) generated shapes fits the classification result. (The better
% the shape fits the classification result, the lower the returned value). Describe
% the implemented cost function in your report! (5 points)

function cost_value = costfunct(pcashape, predscore, p)

% Extract PCA shape components
mean_pca = pcashape(:,1);
eigenValues = pcashape(:,2);
eigenVectors = pcashape(:,3:end);
significant_indices = (eigenValues / sum(eigenValues)) > 0.001;
bnew = ones(sum(significant_indices), 1);

% Rotation matrix based on angle p(2)
r = [cos(p(2)) -sin(p(2));
     sin(p(2))  cos(p(2))];

% Generate the transformed shape
[reconstruction, mean_adjusted, stddeviation] = GenerateShape(bnew, eigenValues(significant_indices), eigenVectors(:, significant_indices), mean_pca, p(1), r, p(3), p(4));

cost_value = 0;
max_probability = 1;

% Loop over all points in the reconstructed shape
for i = 1:size(reconstruction, 1)
    % Sample predicted score at coordinates of reconstructed shape
    % https://de.mathworks.com/help/images/ref/improfile.html
    [c1, c2, probability] = improfile(predscore, reconstruction(i, 1), reconstruction(i, 2), 'nearest');
    if isempty(probability) || isnan(probability)
        % Use maximum cost for missing or out-of-bound points
        cost = max_probability;
    else
        % Inverse probability so that lower probability increases the cost
        cost = 1 - probability;
    end
    % Add current cost to overall cost value
    cost_value = cost_value + cost;
end

% Normalize cost value
cost_value = cost_value / size(reconstruction, 1);
end