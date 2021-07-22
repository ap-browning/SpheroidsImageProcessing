%FILTERFILES    Filter file names in a directory
%
% Receives cell array of files in a directory and returns filtered array
% containing only files with the length-3 extension given.
%
% Example:
%   tiffiles = FILTERFILES(dir(),'tif');
function files = filterfiles(files,extension)

    ignore = false(length(files),1);

    for i = 1:length(files)
        fname = files(i).name;
        ignore(i) = length(fname) < 4 || ~strcmp(fname(end-2:end),extension);
    end
    files = files(~ignore);
    files = {files.name};
    
end