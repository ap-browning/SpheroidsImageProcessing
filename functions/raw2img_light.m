%RAW2IMG     Convert raw file (from tif) to an image using specified LUT
%
% Currently, DAPI and DRAQ7 channels are ignored
function img = raw2img_light(raw,varargin)

    if nargin == 2
        drq = varargin{1};
    else
        drq = false;
    end

    grn = raw(:,:,2) .^ 0.6;
    gn_irgb = [1,0.2,1];
    gn_col  = 1 - cat(3,gn_irgb(1) * grn, gn_irgb(2) * grn, gn_irgb(3) * grn);

    red = 1.0 * raw(:,:,3) .^ 0.8;
    rd_irgb = [0,1,0];
    rd_col  =  1 - cat(3,rd_irgb(1) * red, rd_irgb(2) * red, rd_irgb(3) * red);

    if drq
        dq_irgb = [1,1,0]; 
    else
        dq_irgb = [0,0,0];
    end
    drq = raw(:,:,4) .^ 1.0;
    dq_col  =  1 - cat(3,dq_irgb(1) * drq, dq_irgb(2) * drq, dq_irgb(3) * drq);

        
    img     = 1 - (1 - gn_col + 1 - rd_col + 1 - dq_col);

end

% function img = raw2img_light(raw,drq)
% 
%     grn = raw(:,:,2) .^ 0.4;
%     gn_irgb = [1,0.2,1];
%     gn_col  = 1 - cat(3,gn_irgb(1) * grn, gn_irgb(2) * grn, gn_irgb(3) * grn);
% 
%     red = 1.0 * raw(:,:,3) .^ 1.0;
%     rd_irgb = [0,1,0];
%     rd_col  =  1 - cat(3,rd_irgb(1) * red, rd_irgb(2) * red, rd_irgb(3) * red);
% 
%     if drq
%         dq_irgb = [1,1,0]; 
%     else
%         dq_irgb = [1,1,1];
%     end
%     drq = raw(:,:,4) .^ 1.0;
%     dq_col  =  1 - cat(3,dq_irgb(1) * drq, dq_irgb(2) * drq, dq_irgb(3) * drq);
% 
%         
%     img     = 1 - (1 - gn_col + 1 - rd_col + 1 - dq_col);
% 
% end