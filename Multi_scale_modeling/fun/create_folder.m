function create_folder(var)
arguments
    var.folder_name
end
if ~exist(var.folder_name, 'dir')
    mkdir(var.folder_name)
end  
end