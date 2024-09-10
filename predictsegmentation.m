% 4. Shape Particle Filters In the next step we formulate a function that models costs
% of fitting a shape to a target image. We are looking for a point in a parameter
% space (described by shape parameters, rotation, scaling, and translation) which
% describes an optimal fitted shape, that segments the contours of a target object.

% (a) Create a function train that trains a classifier on all training images (30)
% and creates a PCA shape model. Furthermore, implement a function called
% predictSegmentation that takes a test image (1 from 20) and the trained classifier as input and predicts a segmentation. (Hint: you can use the
% Matlab function predict.) (6 points)


function [predicted_labels, predicted_mask, score, features] = predictsegmentation(rf,image)

features = computeFeatures(image);

[predicted_labels, score] = predict(rf, double(features)');

transformed_labels = str2double(predicted_labels);
predicted_mask = reshape(transformed_labels, size(image, 1), size(image, 2));