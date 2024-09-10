% Task 1 - Covariance matrix
% (a) Implement a function ourCov.m, that computes the covariance matrix C of a data
%     matrix D. Using the matlab built-in function cov for implementation is prohibited but
%     it can be used to compare your results (cov takes a n × d matrix as input). (3 points)
% (b) Compute C for all matrices in daten.mat. Visualize the data utilizing plot in separate figures 
%     and set the axis to equal scale (axis equal). Interpret the resulting
%     covariance matrices C of all datasets! Which position in C holds which information?
%     (3 points)

function [C,mean] = ourCov(D)
    % Create some new Correaltion Matrix, e.g.: 2x2 for 2D data
    C = zeros(size(D,1), size(D,1));
    % Calculate the mean for x and y
    mean = sum(D,2)/size(D,2);
    for i = 1:size(D,1)
        for j = 1:size(D,1)
            % Temporary Variable to sum the terms
            tmp=0;
            for n = 1:size(D,2)
                tmp = tmp + (D(i,n)-mean(i))*(D(j,n)- mean(j));
            end
            C(i,j)=tmp/(size(D,2)-1);
        end
    end
end