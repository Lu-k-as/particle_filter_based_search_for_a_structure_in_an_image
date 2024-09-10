clear all;
load handdata.mat;

tic
[rf, pcashape] = cache(@train,images, masks, aligned);
toc

ind = 41;
testImage=images{ind};

% plot test sample and predicted mask
figure;
imshow(testImage, []);
title('image')


%predict mask for test image
[predicted_labels, predicted_mask, score, features] = predictsegmentation(rf,testImage);

% plot predicted mask
figure;
imshow(predicted_mask, []);
title('mask')

% score (prob 0, prob 1)


theta = 0; % radiant 2*pi/3
s = 1;
x = 0;
y = 0;

p = [s, theta, x, y];

%cost_value = cost(pcashape, score, p)
%step by step

meanPCA = pcashape(:,1);
eigenValues = pcashape(:,2);
eigenVectors = pcashape(:,3:end);

bnew=ones(sum((eigenValues/sum(eigenValues))>0.001),1);

r = [cos(p(2))   -sin(p(2));
    sin(p(2))  cos(p(2)) ];

%[reconstruction,mean,stddeviation] = extendedGenerateShape(b,p(1),r,p(3),p(4));
[reconstruction,mean,stddeviation] = GenerateShape(bnew,pcashape(:,2),pcashape(:,3:end),pcashape(:,1),p(1),r,p(3),p(4));

% plot mean and reconstruction
figure;
scatter(mean(:, 1), mean(:, 2),'red','filled');
hold on
scatter(reconstruction(:,1),reconstruction(:,2),'blue','filled');
legend('Mean', 'New Shape','Location','southeast');
hold off

stdeviation = stddeviation.';
b(1,1) = stddeviation(1,1);

% prob/ score to have pixel in background
predscore_1 = reshape(score(:,1),size(testImage,1),size(testImage,2));
predscore_1 = uint8(predscore_1.*255);

% prob/score to have pixel in shape
figure;
subplot(1,2,1)
imshow(predscore_1)
title('score 1')

predscore_2 = reshape(score(:,2),size(testImage,1),size(testImage,2));
predscore_2 = uint8(predscore_2.*255);

subplot(1,2,2)
imshow(predscore_2)
title('score 2')

%cost function to get overall costs

cost_value = costfunct(pcashape, predscore_1, p);