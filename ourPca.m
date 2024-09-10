% Task 2 -PCA
% (a) Implement a function pca.m, that computes the PCA for a data matrix D. The computation 
%     has to be independent from the dimensionality of the data. The function should
%     return the Eigenvalues in descending order as well as the corresponding normalized
%     Eigenvectors (sorted according to the Eigenvalues!). You can use the Matlab function
%     eig to compute Eigenvectors and values. (3 points)
% (b) Use plot2DPCA.m to plot results for all matrices of daten.mat. (2 point)
% (c) What do Eigenvectors represent? Where can one see that information in the plot? (2
%     points)
% (d) What do Eigenvalues represent? Where can one see that information in the plot? Is
%     there a relation to the total variance of the data? (3 points)
% (e) How does a missing substraction of mean values (on D) affect the computation? (2
%     point)

function [eigenValues,eigenVectors,mean] = pca(D)
    [C,mean] = ourCov(D);
    [eigenVectors,eigenValues] = eig(C,"vector");
    % sortingIndex is a temporary array for shifting the eigenVectors
    [eigenValues, sortingIndex] = sort(eigenValues,"descend");
    eigenVectors=eigenVectors(:, sortingIndex);
end