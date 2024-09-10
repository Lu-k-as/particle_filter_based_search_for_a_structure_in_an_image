% (1) Extend your function generateShape.m so that it allows roattion,
%    scaling and translation of shapes according to the parameters r,s,x,y


function [reconstruction,mean,eigenVect,stddeviation] = extendedGenerateShape(b,s,r,x,y)
    load handdata.mat;
    D = reshape(aligned,size(aligned,1)*size(aligned,2), size(aligned,3));
    [eigenVal, eigenVect, meanPCA] = ourPca(D);

    sizeOfB = size(b,1);
    eigenVectorSet = eigenVect(:,1:sizeOfB);

    offsetPCA = eigenVectorSet*b;  
    offset = reshape(offsetPCA,size(aligned,1),size(aligned,2));

    mean = reshape(meanPCA,size(aligned,1),size(aligned,2));
    
    rotationReconstruction = (r*(mean.')).';
    scalingReconstruction = s* rotationReconstruction;
    translateReconstruction = zeros(size(scalingReconstruction));
    translateReconstruction(:,1) = scalingReconstruction(:,1)+x;
    translateReconstruction(:,2) = scalingReconstruction(:,2)+y;
    reconstruction = translateReconstruction + offset;
    stddeviation = sqrt(abs(eigenVal(1:sizeOfB)));
    
end