function rf = trainRF(images, masks)
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
    rf = TreeBagger(100, training_features', training_labels', 'OOBVarImp', 'on');
end