%% Info
% Analyze synaptic weights and the spike properties of voltage and calcium data.

clear; close all; clc;
repository = '2021_human_msm';
path = ['C:' filesep 'Prg-Win' filesep 'simulations' filesep repository];
addpath([path filesep 'fun']);
addpath(['C:' filesep 'Prg-Win' filesep 'SIMNIBS_323' filesep 'matlab']);
cd(path)
compartments = {'soma', 'basal', 'apical'}';
sim = 'rTMS';

%% Voltage data
for c = 1:size(compartments, 1)
    compartment = compartments{c, 1};
    if strcmp(compartment, 'apical')
        threshold = -40;
    else
        threshold = 0;
    end
    folder = fullfile(path, 'data', 'bwhpc', sim, strcat('v_', compartment));
    if not(isfolder(folder))
        mkdir(folder)
    end
    files = dir(fullfile(path, 'data', 'bwhpc', sim, strcat('voltage_', compartment, '_*.mat')));
    files_name = {files.name}';
    for i = 1:size(files_name, 1)
        file = files_name{i, 1};
        v_data = load(fullfile(path, 'data', 'bwhpc', sim, file));
        v_data = cell2mat(struct2cell(v_data));
        t = (1:length(v_data)) * 0.025;
        time = t * 0.001;
        % figure
        tms_time = [50:100:1950] * 0.001;
        f = figure('visible', 'off');
        plot(time, v_data, 'LineWidth', 2)
        set(gca, 'box', 'off') 
        ylim([-90, 50])
        yticks(-90:10:50)
        xlim([0, 2.15])
        xticks(0:0.25:2.15)
        ylabel('Vm (mV)')
        xlabel('Time (Seconds)')
        saveas(f, fullfile(path, 'data', 'bwhpc', sim, strcat('v_', compartment), strcat('v_', compartment, file(1:end-4), '.svg')));
    end
end

%% Calcium data
for c = 1:size(compartments, 1)
    compartment = compartments{c, 1};
    folder = fullfile(path, 'data', 'bwhpc', sim, strcat('ca_', compartment));
    if not(isfolder(folder))
        mkdir(folder)
    end
    files = dir(fullfile(path, 'data', 'bwhpc', sim, strcat('calcium_', compartment, '_*.mat')));
    files_name = {files.name}';
    for i = 1:size(files_name, 1)
        file = files_name{i, 1};
        ca_data = load(fullfile(path, 'data', 'bwhpc', sim, file));
        ca_data = cell2mat(struct2cell(ca_data));
        t = (1:length(ca_data)) * 0.05;
        time = t * 0.001;
        % figure
        f = figure('visible', 'off');
        plot(time, ca_data, 'LineWidth', 2)
        set(gca, 'box', 'off') 
        ylim([0, 4.5])
        yticks(0:0.5:4.5)
        xlim([0, 2.15])
        xticks(0:0.25:2.15)
        ylabel('[Ca^{2+}] (\mumol/l)')
        xlabel('Time (Seconds)')
        saveas(f, fullfile(path, 'data', 'bwhpc', sim, strcat('ca_', compartment), strcat('ca_', compartment, file(1:end-4), '.svg')));
    end
end