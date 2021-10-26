function [threshold, tested_weights] = determine_synaptic_weight(var)
arguments
    var.path 
    var.model_name 
    var.syn_weight_max
    var.mso
end
% -------------------------------------------------------------------------
neuron_threshold_determined = false;
start_weight = var.syn_weight_max; 
tested_weights = start_weight;
while ~neuron_threshold_determined  
    current_weight = round(tested_weights(end), 7);
    disp(['current weight: ', sprintf('%.7f', current_weight)])
    % update params.txt
    cd([var.path filesep 'Models' filesep var.model_name filesep 'Code' filesep 'NEURON'])
    params_path = [var.path filesep 'Models' filesep var.model_name filesep 'Results' filesep 'NEURON'];
    params_file = 'params.txt';
    tms_amp = var.mso;
    syn_freq = '3.000000';
    syn_noise = '0.500000';
    syn_weight = '0.000000';
    syn_weight_sync  = sprintf('%.7f', current_weight);
    tms_offset = '2.000000';    
    create_paramstxt_file('params_path', params_path, 'params_file', params_file, ...
                          'tms_amp', tms_amp, 'syn_freq', syn_freq, 'syn_noise', syn_noise, ...
                          'syn_weight', syn_weight, 'syn_weight_sync', syn_weight_sync, 'tms_offset', tms_offset)               
    code_path = [var.path filesep 'Models' filesep var.model_name filesep 'Code' filesep 'NEURON'];
    sim_path = [var.path filesep 'Models' filesep var.model_name filesep 'Results' filesep 'thresholds'];
    action_potential = estimate_activation_threshold('code_path', code_path, 'sim_path', sim_path);     
    if action_potential
        if length(tested_weights) == 1 
            action_potential_history = 1;
        else
            action_potential_history(end + 1) = 1;
        end
    else
        if length(tested_weights) == 1 
            action_potential_history = 0;
        else
            action_potential_history(end + 1) = 0;
        end
    end
    % determine next weight
    next_weight = update_synaptic_weights('tested_weights', tested_weights, 'action_potential_history', action_potential_history);
    next_weight = round(next_weight, 7);
    % decide if threshold was determined
    if ismember(next_weight, tested_weights)
        if next_weight == start_weight
            threshold(1, 1) = start_weight;
            neuron_threshold_determined = true;
        elseif next_weight < 0
            threshold(1, 1) = min(tested_weights(ids));  
            neuron_threshold_determined = true;
        else
            ids = find(action_potential_history == 1);
            threshold(1, 1) = min(tested_weights(ids));  
            neuron_threshold_determined = true;
        end
    else
        neuron_threshold_determined = false;
        tested_weights(end + 1) = next_weight;
    end    
end
end