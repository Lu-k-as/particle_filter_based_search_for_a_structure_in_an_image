% (4) Shape Particle Filters In the next step we formulate a function that models costs
% of fitting a shape to a target image. We are looking for a point in a parameter
% space (described by shape parameters, rotation, scaling, and translation) which
% describes an optimal fitted shape, that segments the contours of a target object.

clear all;
load handdata.mat;

% (a) Create a function train that trains a classifier on all training images (30)
% and creates a PCA shape model. Furthermore, implement a function called
% predictSegmentation that takes a test image (1 from 20) and the trained classifier as input and predicts a segmentation. (Hint: you can use the
% Matlab function predict.) (6 points)

% extend trainRF to train, adding input aligned (shapes) + getting output
% put rf and pcashape in cache
tic
[rf, pcashape] = cache(@train,images, masks, aligned);
toc

% predictSegmentation

ind = 31;
[predicted_labels, predicted_mask, score, features] = predictsegmentation(rf,images{ind});

% plot test sample and predicted mask
figure;
subplot(1, 3, 1)
imshow(images{ind}, []);
title('original image')

subplot(1, 3, 2)
imshow(predicted_mask, []);
title('predicted mask')




% (b) Create a cost function that takes a parameter vector p and the classification
% result of an image as input, and returns a scalar value, which describes how
% well the (from p) generated shapes fits the classification result. (The better
% the shape fits the classification result, the lower the returned value). Describe
% the implemented cost function in your report! (5 points)

% costfunct.m
% makeCostFunction.m


% (c) Optimize this function for all test images (20). We are using a stochastic optimization approach called Differential Evolution3
% for this purpose. This method is very simple, robust and converges fast. We provide an implementation of this approach in optimize.m. An example to create and use a cost
% function for an optimization process can be found in optimizeDEMO.m.
% You can also use the Matlab-Function ga which implements a generic algorithm. (3 points)

% function to cache the optimization results
%for testing performance
%function 

%tic
%optimized_parameters = optimizeSegmentationCost(images, rf, pcashape);
%toc

%save optimized parameters for visual checks
%save('optimized_parameters.mat', 'optimized_parameters')

%optimized_parameters = cache(@optimizeSegmentationCost,images, rf,
%pcashape); somehow does not work


% visualizing results for a test image

%load optimized parameters
load optimized_parameters.mat

% adapting the p_initial to the most recent optimization results
p_initial = [1;0;0;0];
% p_initial = [1;0;0;0]; no transformation happening

bnew=ones(sum((pcashape(:,2)/sum(pcashape(:,2)))>0.001),1);

p = p_initial;
r = [cos(p(2))   -sin(p(2));
    sin(p(2))  cos(p(2)) ];
bnew=ones(sum((pcashape(:,2)/sum(pcashape(:,2)))>0.001),1);

subplot(1, 3, 3)
imshow(images{ind}, []);
hold on

% annotated landmarks from handdata
truelandmarks = landmarks{ind}.';
scatter(truelandmarks(:,1),truelandmarks(:,2),'green','filled');

% PCA landmarks initial vector
[reconstruction,mean,stddeviation] = GenerateShape(bnew,pcashape(:,2),pcashape(:,3:end),pcashape(:,1),p(1),r,p(3),p(4));
scatter(reconstruction(:,1),reconstruction(:,2),'red','filled');

% use optimized parameters to calculate landmarks
p=optimized_parameters(ind-30, 1:4);
r = [cos(p(2))   -sin(p(2));
    sin(p(2))  cos(p(2)) ];
optlandmarks = GenerateShape(bnew,pcashape(:,2),pcashape(:,3:end),pcashape(:,1),p(1),r,p(3),p(4));
scatter(optlandmarks(:,1),optlandmarks(:,2),'cyan','filled');
title('segmentation')
legend('True','PCA Shape','Optimized', 'Location','southoutside')


exportgraphics(gcf,'FigureCombined31.png','Resolution',300)