% 4. Shape Particle Filters In the next step we formulate a function that models costs
% of fitting a shape to a target image. We are looking for a point in a parameter
% space (described by shape parameters, rotation, scaling, and translation) which
% describes an optimal fitted shape, that segments the contours of a target object.

% (a) Create a function train that trains a classifier on all training images (30)
% and creates a PCA shape model. Furthermore, implement a function called
% predictSegmentation that takes a test image (1 from 20) and the trained classifier as input and predicts a segmentation. (Hint: you can use the
% Matlab function predict.) (6 points)



function [rf, pcashape] = train(images, masks, aligned)

    % Define vectors to store features and labels

    training_features = [];

    training_labels = [];



    % Loop over the first 30 images in images (= the training images)

    for i = 1:30

        % Compute features for the current image

        current_features = computeFeatures(images{i});



        % Get mask of current image

        current_mask = masks{i};



        % Flatten mask to ensure correct assignment to calculated features

        current_mask = current_mask(:)';



        % Get number of contour pixels

        num_cont = sum(current_mask == 10);



        % Get indices of background pixels

        background_pixels = find(current_mask == 0);



        % Select random background pixels (as many as there are contour pixels)

        selected_background_pixels = background_pixels(randperm(length(background_pixels), num_cont));



        % Set selected background pixels to 5 to differentiate them

        current_mask(selected_background_pixels) = 5;

        % Get indices of selected pixels

        selected_indices = find(current_mask>0);

        % Set value of background pixels back to 0

        current_mask(selected_background_pixels) = 0;



        % Add features and labels to the training set

        training_features = [training_features, current_features(:, selected_indices)];

        training_labels = [training_labels, current_mask(selected_indices)];

    end



    % Train the random forest
    % Number of Trees: 20, as there was no significat loss decrease after
    % 20 trees

    rf = TreeBagger(20, training_features', training_labels', 'OOBVarImp', 'on');

    % Add PCA Shape model
    D = reshape(aligned,size(aligned,1)*size(aligned,2), size(aligned,3));
    [eigenValues,eigenVectors,mean] = ourPca(D);

    pcashape = [mean,eigenValues,eigenVectors];
    
end

