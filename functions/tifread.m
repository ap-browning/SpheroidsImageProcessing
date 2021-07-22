%TIFREAD    Read 4-D tif image
function [img,meta] = tifread(fname,varargin)

    % Add directory if needed
    if nargin == 2
        fname = sprintf("%s/%s",varargin{1},fname);
    end

    % Add extension if needed
    if ~strcmp(extractBetween(fname,strlength(fname)-2,strlength(fname)),'tif')
        fname = sprintf("%s.tif",fname);
    end
    
    ch1     = imread(fname);
    ch2     = imread(fname,2);
    ch3     = imread(fname,3);
    ch4     = imread(fname,4);
    
    ch1     = double(ch1);
    ch2     = double(ch2);
    ch3     = double(ch3);
    ch4     = double(ch4);
    
    ch1     = ch1 / max(ch1,[],'all');
    ch2     = ch2 / max(ch2,[],'all');
    ch3     = ch3 / max(ch3,[],'all');
    ch4     = ch4 / max(ch4,[],'all');
    
    img     = cat(3,ch1,ch2,ch3,ch4);
    img(isnan(img)) = 0;
 
    info    = imfinfo(fname);
    meta.Resolution = info(1).XResolution;
    meta.CreationDate = info(1).ImageDescription;
    
end