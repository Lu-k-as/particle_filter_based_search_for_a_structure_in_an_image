clear all;
load handdata.mat;

tic
[rf, pcashape] = cache(@train,images, masks, aligned);
toc

p_initial = [1;0;0;0];
minimums = [0.75;-30;-300;-300];
maximums = [1.25;30;300;300];

ind = 33;
testImage=images{ind};

%predict mask for test image
[predicted_labels, predicted_mask, score, features] = predictsegmentation(rf,testImage);

%scores for pixel in background (1st column in score,)
predscore_1 = reshape(score(:,2),size(testImage,1),size(testImage,2));

%cost_value = costfunct(eigenValues,eigenVectors,mean, predscore_1, p)
costFunction = makeCostFunction(pcashape,predscore_1,@costfunct);

%optimize
optparameters=optimize(costFunction,minimums,maximums);

%mit Ausgabe:
%imshow(testImage)
%hold on
%optparameters=optimize(costFunction,minimums,maximums,drawPop);
%hold off
p = p_initial;
r = [cos(p(2))   -sin(p(2));
    sin(p(2))  cos(p(2)) ];

bnew=ones(sum((pcashape(:,2)/sum(pcashape(:,2)))>0.001),1);
[reconstruction,mean,stddeviation] = GenerateShape(bnew,pcashape(:,2),pcashape(:,3:end),pcashape(:,1),p(1),r,p(3),p(4));

% PCA landmarks initial vector
%pcalandmarks = reshape(reconstruction, size(testImage, 1), size(testImage, 2));

% annotated landmarks from handdata
truelandmarks = landmarks{ind}.';
%truelandmarks = reshape(truelandmarks, size(testImage, 1), size(testImage, 2));

% use optimized parameters to calculate landmarks
p = optparameters;
r = [cos(p(2))   -sin(p(2));
    sin(p(2))  cos(p(2)) ];

optlandmarks = GenerateShape(bnew,pcashape(:,2),pcashape(:,3:end),pcashape(:,1),p(1),r,p(3),p(4));
%optlandmarks = reshape(predlandmarks, size(testImage, 1), size(testImage, 2));

figure;
imshow(testImage, []);
hold on
scatter(reconstruction(:,1),reconstruction(:,2),'blue','filled');
scatter(optlandmarks(:,1),optlandmarks(:,2),'green','filled');
scatter(truelandmarks(:,1),truelandmarks(:,2),'red','filled');
legend('Reconstruction','Optimized','True')