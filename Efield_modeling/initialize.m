%% Add paths
path = fullfile(); % add project path
cd(path);
% SimNIBS Matlab functions
addpath(fullfile());
% own functions
addpath(genpath(fullfile()));
% Alex Opitz's lab functions
addpath(fullfile()); % not shared

%% Add variables
participants = [1 2 6 8 9 12 13 14 15 16 17 19 21 22 24 25];
cell_name = 'Aberra_human_L5';