%RAW2IMG     Convert raw file (from tif) to an image using specified LUT
%
% Currently, DAPI and DRAQ7 channels are ignored
function img = raw2img(raw,varargin)
    
    ch  = [1,1,1];
    lut = 'bright';
    if nargin == 2
        if isstring(varargin{1}) || ischar(varargin{1})
            lut = varargin{1};
        else
            ch  = varargin{1};
        end
    elseif nargin == 3
        if isstring(varargin{1})
            lut = varargin{1};
            ch  = varargin{2};
        else
            ch  = varargin{1};
            lut = varargin{2};
        end
    end
    
    switch lut
        case 'none'
            f = @(x) x;
        case 'bright'
            f = @(x) x.^0.5;
        case 'middle'
            f = @(x) x.^0.8;
    end

    blank   = 0*raw(:,:,1);
    red     = cat(3,raw(:,:,3),blank,blank);
    grn     = cat(3,blank,raw(:,:,2),blank);
    mag     = cat(3,raw(:,:,4),blank,raw(:,:,4));
    
    img     = ch(1) * grn + ch(2) * red;% + ch(3) * mag;
    img     = f(img);

end