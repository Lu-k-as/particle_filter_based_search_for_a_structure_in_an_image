
function plotExtendedShape(mean, eigenVect,b,s,r,x,y)
    load("handdata.mat")
    D = reshape(aligned,size(aligned,1)*size(aligned,2), size(aligned,3));
    [eigenVal, eigenVect, meanPCA] = ourPca(D);
    sizeOfB = size(b,1);
    eigenVectorSet = eigenVect(:,1:sizeOfB);
    offsetPCA = eigenVectorSet*b;  
    % shapePCA=(r*eigenVectorSet.').';
    % if b ~= 0
    %     shapePCA = shapePCA*b;
    % else
    %     shapePCA = shapePCA*(b+1);
    % end
    % if s ~= 0
    %     shapePCA = s*shapePCA;
    % end    
    % translatePCA = zeros(size(shapePCA));
    % translatePCA(1:size(aligned,1),1) = shapePCA(1:size(aligned,1),1)+x;
    % translatePCA(size(aligned,1)+1:2*size(aligned,1),1) = shapePCA(size(aligned,1)+1:2*size(aligned,1),1)+y;
    % shapePCA = translatePCA;
    offset = reshape(offsetPCA,size(aligned,1),size(aligned,2));
    mean = reshape(meanPCA,size(aligned,1),size(aligned,2));
    rotationReconstruction = (r*(mean.')).';
    scalingReconstruction = s* rotationReconstruction;
    translateReconstruction = zeros(size(scalingReconstruction));
    translateReconstruction(:,1) = scalingReconstruction(:,1)+x;
    translateReconstruction(:,2) = scalingReconstruction(:,2)+y;
    reconstruction = translateReconstruction + offset;

    scatter(mean(:, 1), mean(:, 2),'red','filled');
    hold on
    scatter(reconstruction(:,1),reconstruction(:,2),'blue','filled');
    legend('Mean', 'New Shape','Location','southeast');
    hold off
end