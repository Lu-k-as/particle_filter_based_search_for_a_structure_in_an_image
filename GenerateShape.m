% (1) Extend your function generateShape.m so that it allows rotation,
%    scaling and translation of shapes according to the parameters r,s,x,y


function [reconstruction,mean,stddeviation] = GenerateShape(b,eigenValues,eigenVectors,meanPCA,s,r,x,y)

    sizeOfB = size(b,1);
    eigenVectorSet = eigenVectors(:,1:sizeOfB);

    % what is this offset for?
    offsetPCA = eigenVectorSet*b;  
    offset = reshape(offsetPCA,64,2); % reshape to aligned

    mean = reshape(meanPCA,64,2); % reshape to aligned

    reconstruction = offset + mean;

    rotationReconstruction = (r*(reconstruction.')).';
    scalingReconstruction = s* rotationReconstruction;

    translateReconstruction = zeros(size(scalingReconstruction));
    translateReconstruction(:,1) = scalingReconstruction(:,1)-x;
    translateReconstruction(:,2) = scalingReconstruction(:,2)+y;

    reconstruction = translateReconstruction;
    stddeviation = sqrt(abs(eigenValues(1:sizeOfB)));

end