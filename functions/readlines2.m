function res = readlines2(fname)
    
    fid  = fopen(fname,'r');
    line = fgetl(fid);
    res  = [string(line)];
    while ischar(line)
        line = fgetl(fid);
        res(end+1) = string(line);
    end
    res = res';

end