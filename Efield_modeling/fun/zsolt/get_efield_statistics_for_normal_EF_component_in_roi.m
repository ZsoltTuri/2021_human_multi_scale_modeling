function [matrix_pos, matrix_neg, matrix_raw_pos, matrix_raw_neg] = get_efield_statistics_for_normal_EF_component_in_roi(field, roi)
% This function calcualtes the following statistics for a given region of interest (ROI).
% Input arguments:
% - field: matrix of electric field strength values
% - roi: matrix of logical defining the roi
% Statistics:
% - robust maximum: 99.9th percentile
% - robust minimum: 0.01th percentile
% - mean
% - median
% Usage: matrix = get_efield_statistics(field, roi);
% Written by Zsolt Turi (2021).
% Last change: 15.04.2021.

    matrix = zeros(2, 4);
    data = field(roi);
    
    % Positive
    positive = data > 0;
    if sum(positive) == 0 % if there are only negative values
        matrix_raw_pos = 0;
        matrix_pos(1, 1:4) = 0;
    else
        matrix_raw_pos = data(positive);
        matrix(1, 1) = prctile(data(positive), 99.9);
        matrix(1, 2) = prctile(data(positive), 0.01);
        matrix(1, 3) = mean(data(positive));
        matrix(1, 4) = median(data(positive));
        matrix_pos = matrix(1, :);
    end
    
    % Negative
    negative = data < 0;
    if sum(negative) == 0 % if there are only positive values
        matrix_raw_neg = 0;
        matrix_neg(1, 1:4) = 0;
    else
        matrix_raw_neg = data(negative);
        matrix(2, 1) = prctile(data(negative), 99.9);
        matrix(2, 2) = prctile(data(negative), 0.01);
        matrix(2, 3) = mean(data(negative));
        matrix(2, 4) = median(data(negative));
        matrix_neg = matrix(2, :);
    end
end

