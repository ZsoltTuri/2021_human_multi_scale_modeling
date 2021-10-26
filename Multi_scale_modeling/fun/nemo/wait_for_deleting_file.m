function wait_for_deleting_file(var)
arguments
    var.file    
end

deleted = false;
while deleted == false
    if isfile(var.file)
        deleted = false;
        delete var.file;
    else 
        deleted = true;
    end
end
end