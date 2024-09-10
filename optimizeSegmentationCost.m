function optimized_parameters = optimizeSegmentationCost(images, rf, pcashape)



% optimization init

minimums = [0.85;-3.2;-300;-300];

maximums = [1.15;3.2;300;300];



% test set 31-50

% for initial testing only 2 images

for i=31:50

    disp(['optimization ', num2str(i-30), ' start']);

    clear testImage predicted_labels predicted_mask score features predscore optparameters costFunction

    testImage=images{i};

    

    %predict mask for test image

    [predicted_labels, predicted_mask, score, features] = predictsegmentation(rf,testImage);



    %scores for pixel in background (1st column in score, 2nd column in

    %score) - needs to be checked, as the impact on the result is

    predscore = reshape(score(:,2),size(testImage,1),size(testImage,2));



    %cost_value = costfunct(eigenValues,eigenVectors,mean, predscore_1, p)

    costFunction = makeCostFunction(pcashape,predscore,@costfunct);



    %optimize

    optparameters=optimize(costFunction,minimums,maximums);



    % store parameters

    optimized_parameters((i-30),1:4)=optparameters(1:4);



end