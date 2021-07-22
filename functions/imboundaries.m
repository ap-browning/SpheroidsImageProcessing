%IMBOUNDARIES   Plot image with boundaries
function img = imboundaries(img,msks,varargin)

    if nargin == 3 && numel(varargin{1}) == 1
        linewidth = varargin{1};
        col = [1.0,1.0,1.0];
    elseif nargin == 3 && numel(varargin{1}) == 3
        linewidth = 3;
        col = varargin{1};
    elseif nargin == 4 && numel(varargin{1}) == 1
        linewidth = varargin{1};
        col = varargin{2};
    elseif nargin == 4 && numel(varargin{1}) == 3
        linewidth = varargin{2};
        col = varargin{1};
    else
        linewidth = 3;
        col = [1.0,1.0,1.0];
    end
        
    for i = 1:length(msks)
        bd     = imdilate(bwmorph(msks{i},'remove'),strel('disk',linewidth,8));
        img_bd = cat(3,col(1)*bd,col(2)*bd,col(3)*bd);
        img    = (img .* ~bd) + (img_bd .* bd);
    end
   
end