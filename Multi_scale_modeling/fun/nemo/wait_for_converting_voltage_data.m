function wait_for_converting_voltage_data(var)
arguments
    var.folder
end  
file_created = struct([]);
current_state = struct([]);
next_state = struct([]);

created = false;
while created == false
    file_created = dir(var.folder);
    if isempty(file_created)
        created = false;
    else 
        created = true;
    end
end
disp('Conversion started...')
copy_process = true;
while copy_process == true
    current_state = dir(var.folder);
    size_current = size(current_state, 1);
    pause(1)
    next_state = dir(var.folder);
    size_next = size(next_state, 1);
    delta = size_current - size_next;
    if delta == 0
        copy_process = false;
    else
        copy_process = true;
    end
end
disp('Conversion completed.')
end