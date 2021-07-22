%RAWTIFREAD     Read tif images converted by FIJI
%
% Receives a file name, 'fname' (with or without extension) and reads the
% corresponding text file fname.txt that contains the OIR metadata to find
% information about the fluorescent excitation of each channel. Returns
% a 4-D image 'raw' where
%   raw(:,:,1) : DAPI channel
%   raw(:,:,2) : Green channel
%   raw(:,:,3) : Red channel
%   raw(:,:,4) : Draq7 channel
% If the channel is missing from the raw tif file, raw(:,:,i) = zeros(..).
% The raw(:,:,:) array returned is a double with scaled pixel intensities;
% i.e., max(raw,[],'all') <= 1.
%
% Also returns a struct meta containing the resolution (um to px scale),
% creation data, and creation time.
function [raw,meta] = rawtifread(fname)
    
    if strcmp(extractBetween(fname,strlength(fname)-2,strlength(fname)),"tif")
        fname = extractBetween(fname,1,strlength(fname)-4);
    end

    % Number of channels in the raw tif file (<= 4)
    fmeta = imfinfo(sprintf("%s.tif",fname));
    nch  = length(fmeta);

    % Use fname.txt to find creation data/time and fluorescent excitation
    % of each channel
    if exist(sprintf("%s.txt",fname),'file') == 0
        error("No text file for this image!");
    end
    
    % Load text file and convert to name value pairs
    info = readlines(sprintf("%s.txt",fname));
    names  = [];
    values = [];
    for i = 1:length(info)
        row = split(info(i),"=");
        if length(row) ~= 2
            continue;
        end
        names  = [names; strtrim(row(1))];
        values = [values; strtrim(row(2))];
    end

    % Find laser details in file (looking for "- Laser LD405"), for example
    lasers = [];
    for i = 1:length(names)
        name = names(i);
        if strlength(names(i)) > 13 && strcmp(extractBetween(name,1,7),"- Laser")
            lasers = [lasers; extractBetween(name,11,13)];
        end
    end
    lasers = str2double(unique(lasers));    % Lasers in correct order

    % Find laser wavelength at each channel
    ch_wavelength = zeros(nch,1);
    for ch = 1:nch
        laser_idx = str2double(values(find(strcmp(names,sprintf("- Channel CH%d linked laser index #1",ch)),1,'first')));
        ch_wavelength(ch) = lasers(laser_idx + 1);
    end

    % Get creation datetime
    creation = values(find(strcmp(names,"general creationDateTime #1"),1,'first'));
    creation = split(creation,"T");
    creationDate = datetime(creation(1));
    creationTime = creation(2);

    % Extract image for each channel (or zeros otherwise)
    %   1 - 405 - DAPI
    %   2 - 488 - Green
    %   3 - 561 - Red
    %   4 - 640 - DRAQ7
    ChWv = [405,488,561,640];
    raw  = zeros(fmeta(1).Width,fmeta(1).Width,4);
    for i = 1:4
        if any(ChWv(i) == ch_wavelength)
            tif_idx = find(ChWv(i) == ch_wavelength,1,'first');
            raw(:,:,i) = double(imread(sprintf("%s.tif",fname),tif_idx));
            raw(:,:,i) = raw(:,:,i) / max(raw(:,:,i),[],'all');
        end
    end

    % Get metadata
    meta.Resolution    = fmeta(1).XResolution;
    meta.CreationDate  = creationDate;
    meta.CreationTime  = creationTime;

end