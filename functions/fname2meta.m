%FNAME2META    Convert filenames to metadata
%
% Recives a cell array (or a single string) of filenames, returns the
% metadata that can be used to store processed data.
%
% Filenames should be in the form:
%   ExpL_983b_AB_D10_10000_2.extension
function meta = fname2meta(fname)

    meta = [];
    for i = 1:length(fname)
        info            = split(fname(i),"_");
        name            = split(fname(i),".");
        meta(i).fname      = name{1};
        meta(i).ExpID      = info{1};
        meta(i).CellLine   = info{2};
        meta(i).Plate      = info{3};
        meta(i).Day        = str2double(info{5}(2:end));
        meta(i).InitialCondition = str2double(info{6});
        meta(i).Replicate  = str2double(info{7}(1:end-4));
        meta(i).MountingSolution = info{4};
        
    end
    
end