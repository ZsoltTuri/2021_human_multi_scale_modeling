function index = find_optimal_coilparameters(var)
arguments
    var.participant
    var.analysis_path
    var.optimize_for
    var.stat
end
  
switch var.optimize_for
    case 'EFabs_GMsurf'
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFabs_GMsurf_stat.mat')));
    case 'EFabs_GMvol'
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFabs_GMvol_stat.mat')));
    case 'EFtan_GMsurf'
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFtan_GMsurf_stat.mat')));
    case 'EFperp_GMsurf'
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFperp_GMsurf_stat.mat')));
    case 'EFperppos_GMsurf'
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFperppos_GMsurf_stat.mat')));
    otherwise
        resdir = dir(fullfile(var.analysis_path, strcat(var.participant, '*EFperpneg_GMsurf_stat.mat')));
end
resdir_names = {resdir(:).name}';
resdir_folders = {resdir(:).folder}';
res = zeros(length(resdir_names), 4);
for i = 1:length(resdir_names)
    folder = resdir_folders{i, 1};
    name = resdir_names{i, 1};
    results = load(fullfile(folder, name));
    res(i, :) = cell2mat(struct2cell(results));
end
switch var.stat
    case 'max'
        column = 1;
    case 'min'
        column = 2;
    case 'mean'
        column = 3;
    otherwise
        column = 4;
end
[~, index] = max(abs(res(:, column)));
end