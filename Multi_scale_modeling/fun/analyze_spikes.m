%% Info
% Analyze synaptic weights and the spike properties of voltage and calcium data.

clear; close all; clc;
repository = '2021_human_msm';
path = ['C:' filesep 'Prg-Win' filesep 'simulations' filesep repository];
addpath([path filesep 'fun']);
addpath(['C:' filesep 'Prg-Win' filesep 'SIMNIBS_323' filesep 'matlab']);
cd(path)
compartments = {'soma', 'basal', 'apical'}';
ws = 'rTMS';


%% Voltage data
for c = 1:size(compartments, 1)
    compartment = compartments{c, 1};
    if strcmp(compartment, 'apical')
        threshold = -40;
    else
        threshold = 0;
    end
    folder = fullfile(path, 'data_for_analysis', ws, strcat('v_', compartment));
    if not(isfolder(folder))
        mkdir(folder)
    end
    files = dir(fullfile(path, 'data_for_analysis', ws, strcat('voltage_', compartment, '_*.mat')));
    files_name = {files.name}';
    data_idx_range = [40 80]; % get n1 and n2 time points before and after the spikes
    spikes = zeros(size(files_name, 1), 2);
    for i = 1:size(files_name, 1)
        file = files_name{i, 1};
        v_data = load(fullfile(path, 'data_for_analysis', ws, file));
        v_data = cell2mat(struct2cell(v_data));
        t = (1:length(v_data)) * 0.025;
        %time = milliseconds(t);
        time = t * 0.001;
        % find peaks
        if strcmp(compartment, 'apical')
            [peak_values, pk_locs] = findpeaks(v_data, 'minpeakheight', -40, 'MinPeakDistance', 1000);
        else
            [peak_values, pk_locs] = findpeaks(v_data, 'minpeakheight', threshold);
        end
        peak_values = peak_values';
        peak_nr = size(peak_values, 1);
         % optional: find peak start and end at full width half maximum
        for j = 1:length(pk_locs)
            data = v_data(pk_locs(j) - data_idx_range(1):pk_locs(j) + data_idx_range(2));
            % find the half max value.
            halfMax = (min(data) + max(data)) / 2;
            % find where the data first drops below half the max.
            index1 = find(data >= halfMax, 1, 'first');
            % find where the data last rises above half the max.
            index2 = find(data >= halfMax, 1, 'last');
            fwhm(j, 1) = index2 - index1 + 1; % FWHM in indexes.
        end
        % peak duration (at full width half maximum)
        fwhm_duration = fwhm * 0.005;
        fwhm_frq = 1000 ./ fwhm_duration;
        % merge, save results and figure
        spikes(i, 1) = peak_nr;
        spikes(i, 2) = mean(peak_values);
        % spikes(i, 3) = mean(fwhm_duration);
        fname = fullfile(path, 'data_for_analysis', ws, strcat('v_', compartment), strcat('v_', compartment));
        save(strcat(fname, '.mat'), 'spikes')
        writematrix(spikes, strcat(fname, '.xlsx'))
        % figure
        tms_time = [50:100:1950] * 0.001;
        f = figure('visible', 'off');
        plot(time, v_data, 'LineWidth', 2)
        set(gca, 'box', 'off') 
        ylim([-90, 50])
        yticks(-90:10:50)
        xlim([0, 2.15])
        xticks(0:0.25:2.15)
        hold on
        for k = 1:length(tms_time)
            plot([tms_time(k) tms_time(k)], [-90 50] , 'black', 'LineWidth', 0.1)
        end
        ylabel('Vm (mV)')
        xlabel('Time (Seconds)')
%         hold on 
%         plot(time(pk_locs), v_data(pk_locs), 'r*')
        saveas(f, fullfile(path, 'data_for_analysis', ws, strcat('v_', compartment), strcat('v_', compartment, file(1:end-4), '.png')));
    end
end

%% Calcium data
for c = 1:size(compartments, 1)
    compartment = compartments{c, 1};
    folder = fullfile(path, 'data_for_analysis', ws, strcat('ca_', compartment));
    if not(isfolder(folder))
        mkdir(folder)
    end
    files = dir(fullfile(path, 'data_for_analysis', ws, strcat('calcium_', compartment, '_*.mat')));
    files_name = {files.name}';
    data_idx_range = [40 80]; % get n1 and n2 time points before and after the spikes
    spikes = zeros(size(files_name, 1), 2);
    for i = 1:size(files_name, 1)
        file = files_name{i, 1};
        ca_data = load(fullfile(path, 'data_for_analysis', ws, file));
        ca_data = cell2mat(struct2cell(ca_data));
        t = (1:length(ca_data)) * 0.05;
        time = t * 0.001;
        % find peaks
        if strcmp(compartment, 'apical')
            [peak_values, pk_locs] = findpeaks(ca_data, 'MinPeakDistance', 1000);
        else
            [peak_values, pk_locs] = findpeaks(ca_data);
        end
        peak_values = peak_values';
        peak_nr = size(peak_values, 1);
        % optional: find peak start and end at full width half maximum
        for j = 1:length(pk_locs)
            data = ca_data(pk_locs(j) - data_idx_range(1):pk_locs(j) + data_idx_range(2));
            % find the half max value.
            halfMax = (min(data) + max(data)) / 2;
            % find where the data first drops below half the max.
            index1 = find(data >= halfMax, 1, 'first');
            % find where the data last rises above half the max.
            index2 = find(data >= halfMax, 1, 'last');
            fwhm(j, 1) = index2 - index1 + 1; % FWHM in indexes.
        end
        % peak duration 
        fwhm_duration = fwhm * 0.05;
        fwhm_frq = 1000 ./ fwhm_duration;
        % merge, save results and figure
        spikes(i, 1) = peak_nr;
        spikes(i, 2) = mean(peak_values);
        % spikes(i, 3) = mean(fwhm_duration);
        fname = fullfile(path, 'data_for_analysis', ws, strcat('ca_', compartment), strcat('ca_', compartment));
        save(strcat(fname, '.mat'), 'spikes')
        writematrix(spikes, strcat(fname, '.xlsx'))
        % figure
        tms_time = [50:100:1950] * 0.001;
        f = figure('visible', 'off');
        plot(time, ca_data, 'LineWidth', 2)
        set(gca, 'box', 'off') 
        ylim([0, 3])
        yticks(0:0.5:3)
        xlim([0, 2.15])
        xticks(0:0.25:2.15)
        hold on
        for k = 1:length(tms_time)
            plot([tms_time(k) tms_time(k)], [0 3] , 'black', 'LineWidth', 0.1)
        end
        ylabel('[Ca^{2+}] (\mumol/l)')
        xlabel('Time (Seconds)')
%         hold on 
%         plot(time(pk_locs), ca_data(pk_locs), 'r*')
        saveas(f, fullfile(path, 'data_for_analysis', ws, strcat('ca_', compartment), strcat('ca_', compartment, file(1:end-4), '.png')));
    end
end