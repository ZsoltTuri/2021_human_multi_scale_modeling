function roi = get_spherical_roi(compartment, coordiante, radius)

% This function extracts spherical region of interest (ROI) of a given
% radius.

% Input arguments:
% - compartment: a mesh compartment (e.g. gray matter volume)
% - coordinate: the center of the ROI (defined by the user)
% - radius: radius of the spherical ROI in mm

% Usage: roi = get_spherical_roi(compartment, coordiante, radius);
% Modified by Zsolt Turi (2020) based on SimNIBS tutorials.

    roi = sqrt(sum(bsxfun(@minus, compartment, coordiante).^2, 2)) <= radius;
    
end