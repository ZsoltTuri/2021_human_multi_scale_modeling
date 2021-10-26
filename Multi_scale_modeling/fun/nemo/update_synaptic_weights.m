function next_weight = update_synaptic_weights(var)
arguments
    var.tested_weights      
    var.action_potential_history
end
% determine next weight after the first step
if length(var.tested_weights) == 1 
    if var.action_potential_history == 1
        next_weight = var.tested_weights(end) * 0.5; 
    else 
        next_weight = var.tested_weights(end);
    end
% determine next weight afterwards
else 
    ap_sec_last = var.action_potential_history(end - 1);
    ap_last = var.action_potential_history(end);
    ids = find(var.action_potential_history == 1);
    % if there are still no action potentials after the first step
    if isempty(ids)
        next_weight = var.tested_weights(end) * 1.5;
    else    
        last_good_weight = var.tested_weights(ids(end));
        % after two consecutive action potentials: decrease weight
        if ap_sec_last == 1 && ap_last == 1
            amount = (var.tested_weights(end - 1) - var.tested_weights(end)) * 0.5;
            next_weight = var.tested_weights(end) - amount;
        % after two consecutive failures: increase weight
        elseif ap_sec_last == 0 && ap_last == 0
            next_weight = (last_good_weight + var.tested_weights(end)) * 0.5; 
        % otherwise: find iterim value (i.e., calculate the average of the last two weights)
        else
            next_weight = (var.tested_weights(end) + var.tested_weights(end - 1)) * 0.5;
        end   
    end
end
end