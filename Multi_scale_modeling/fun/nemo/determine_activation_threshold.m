function threshold = determine_activation_threshold(var)
arguments
    var.path 
    var.model_name
    var.syn_weight
    var.mso_max
    var.counter
    var.params_file
    var.quasipotentials_file
end
% -------------------------------------------------------------------------
neuron_threshold_determined = false;
start_intensity = var.mso_max;  
tested_intensities = start_intensity;
% couple_scipt may stuck at certain positions
if var.counter < 1000
    threshold(1, 2) = var.counter;
else
    neuron_threshold_determined = true;
    threshold(1, 1) = 0;
    threshold(1, 2) = var.counter;
end
while ~neuron_threshold_determined
    current_intensity = tested_intensities(end);
    disp(['Current MSO is: ', num2str(current_intensity)])
    % update params.txt file
    cd([var.path filesep 'Models' filesep var.model_name filesep 'Code' filesep 'NEURON'])
    params_path = [var.path filesep 'Models' filesep var.model_name filesep 'Results' filesep 'NEURON'];
    params_file = var.params_file;
    tms_amp = num2str(current_intensity);
    syn_freq = '3.000000';
    syn_noise = '0.500000';
    syn_weight = '0.000000';
    syn_weight_sync = var.syn_weight;
    tms_offset = '2.000000';   
    quasipotentials_file = var.quasipotentials_file;
    create_paramstxt_file('params_path', params_path, 'params_file', params_file, ...
                          'tms_amp', tms_amp, 'syn_freq', syn_freq, 'syn_noise', syn_noise, ...
                          'syn_weight', syn_weight, 'syn_weight_sync', syn_weight_sync, 'tms_offset', tms_offset, 'quasipotentials_file', quasipotentials_file)
    code_path = [var.path filesep 'Models' filesep var.model_name filesep 'Code' filesep 'NEURON'];
    sim_path = [var.path filesep 'Models' filesep var.model_name filesep 'Results' filesep 'thresholds'];
    action_potential = estimate_activation_threshold('code_path', code_path, 'sim_path', sim_path);     
    if action_potential
        if length(tested_intensities) == 1 
            action_potential_history = 1;
        else
            action_potential_history(end + 1) = 1;
        end
    else
        if length(tested_intensities) == 1 
            action_potential_history = 0;
        else
            action_potential_history(end + 1) = 0;
        end
    end
    % determine next intensity
    next_intensity = update_intensity('tested_intensities', tested_intensities, 'action_potential_history', action_potential_history);
    % decide if threshold was determined
    if ismember(next_intensity, tested_intensities)
        if next_intensity == start_intensity
            threshold(1, 1) = start_intensity;
            neuron_threshold_determined = true;
        elseif next_intensity < 0
            threshold(1, 1) = min(tested_intensities(ids));  
            neuron_threshold_determined = true;
        else
            ids = find(action_potential_history == 1);
            threshold(1, 1) = min(tested_intensities(ids));  
            neuron_threshold_determined = true;
        end
    else
        neuron_threshold_determined = false;
        tested_intensities(end + 1) = next_intensity;
    end    
end
end