function wait_for_saving_file(var)
arguments
    var.file
end

created = false;
while created == false
    if isfile(var.file)
        created = true;
    else 
        created = false;
    end
end
end