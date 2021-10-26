function next_intensity = update_intensity(var)
arguments
    var.tested_intensities      
    var.action_potential_history
end
% determine next intensity after the first step
if length(var.tested_intensities) == 1 
    if var.action_potential_history == 1
        next_intensity = var.tested_intensities(end) * 0.5; 
    else 
        next_intensity = var.tested_intensities(end); %next_intensity = var.tested_intensities * 1.5;
    end
% determine next intensity afterwards
else 
    ap_sec_last = var.action_potential_history(end - 1);
    ap_last = var.action_potential_history(end);
    ids = find(var.action_potential_history == 1);
    % if there are still no action potentials after the first step
    if isempty(ids)
        next_intensity = var.tested_intensities(end) * 1.5;
    else    
        last_good_intensity = var.tested_intensities(ids(end));
        % after two consecutive action potentials: decrease intensity
        if ap_sec_last == 1 && ap_last == 1
            amount = (var.tested_intensities(end - 1) - var.tested_intensities(end)) * 0.5;
            next_intensity = var.tested_intensities(end) - amount;
            next_intensity = floor(next_intensity); % avoid to stuck at 1% MSO above the threshold
        % after two consecutive failures: increase intensity
        elseif ap_sec_last == 0 && ap_last == 0
            next_intensity = (last_good_intensity + var.tested_intensities(end)) * 0.5; 
        % otherwise: find iterim value (i.e., calculate the average of the last two intensities)
        else
            next_intensity = (var.tested_intensities(end) + var.tested_intensities(end - 1)) * 0.5;
        end   
    end
end
next_intensity = round(next_intensity);
end