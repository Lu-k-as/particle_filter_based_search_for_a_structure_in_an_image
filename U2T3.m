%Task 3: Classification & Feature-Selection Use features of the training images to train
%a classifier that is able to classify edges of objects to be segmented. Use the Random Forest classifier2
%for this purpose which is implemented in the Matlab class
%TreeBagger.
%(a) Implement a function trainRF(images, masks) that computes features for all images (50) and trains a Random Forest features of all training
%images (30) and their masks as class labels. The function call to train a Random Forest should look like
%rf = TreeBagger(100,features’,labels’,’OOBVarImp’,’on’);
%Hint: To speed up the training process you should use all pixels of the bone contours but only a randomly sampled subset of the background pixels
%(equal amount of fore- (bone contours) and background (non- bone contours)). (8 points)
%(b) Evaluate and interpret the impact of the number of trees using oobError. (5 points)
%(c) Evaluate and interpret the importance of different features using
%plot(rf.OOBPermutedVarDeltaError). (5 points)
clear all;
load handdata.mat;


% a) train random forest - use trainRF function
tic
rf = cache(@trainRF,images, masks);
toc

% b) oob error
figure;
subplot(2, 1, 1)
plot(oobError(rf))
title('oob error')
xlabel 'Number of trees';
ylabel 'Out-of-bag classification error';



% c) delta error

subplot(2, 1, 2)

plot(rf.OOBPermutedVarDeltaError)

title('delta error')
xlabel 'Feature';
ylabel 'FeatureImportance';
h = gca;
h.XTickLabel = ({'Gray Values','Grad-x','Grad-y','Grad-Magnitude','HL based on Gray','HL based on GradMag','x-Coord','y-Koord'});
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

exportgraphics(gcf,'FigureOBBError_Features_Importance.png','Resolution',300)

% predict mask for test sample

ind = 31;

features = computeFeatures(images{ind});

predicted_labels = predict(rf, features');

transformed_labels = str2double(predicted_labels);

predicted_mask = reshape(transformed_labels, size(images{ind}, 1), size(images{ind}, 2));



% plot test sample and predicted mask
figure;

subplot(1, 2, 1)

imshow(images{ind}, []);

title('image')



subplot(1, 2, 2)

imshow(predicted_mask, []);

title('mask')