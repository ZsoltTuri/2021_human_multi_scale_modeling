function create_calciumshellscript(var)
arguments
    var.ug4_path
    var.ex
    var.grid 
    var.numRefs 
    var.setting 
    var.dt 
    var.endTime
    var.pstep 
    var.vmData 
    var.outName 
    var.solver 
    var.minDef 
    var.numNewton
    var.vSampleRate 
    var.filename
end
space = 32;
command = [var.ug4_path space, '-ex', space, var.ex, space, '-grid', space, var.grid, space, '-numRefs', space, var.numRefs, space, '-setting', space, var.setting, space, '-dt', space, var.dt, space, ...
           '-endTime', space, var.endTime, space, '-vtk', space, '-pstep', space, var.pstep, space, '-vmData', space, var.vmData, space, '-outName', space, var.outName, space, '-solver', space, ...
           var.solver, space, '-minDef', space, var.minDef, space, '-numNewton', space, var.numNewton, space, '-vSampleRate', space, var.vSampleRate];
fid = fopen(var.filename, 'wt');
fprintf(fid, '#!/bin/bash \n');
fprintf(fid, [command '\n']);
fclose(fid);
end