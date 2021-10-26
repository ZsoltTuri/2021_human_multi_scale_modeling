function [matrix, matrix_raw] = get_efield_statistics_in_roi(field, roi)

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
% Written by Zsolt Turi (2020).
    
    matrix = zeros(1, 4);
    matrix_raw = field(roi);
    matrix(1, 1) = prctile(field(roi), 99.9);
    matrix(1, 2) = prctile(field(roi), 0.01);
    matrix(1, 3) = mean(field(roi));
    matrix(1, 4) = median(field(roi));

end