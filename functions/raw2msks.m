%MAKEINNERMASK  Input msk and cvx mask, output convex necrotic core mask.
function [msk,cvx,innermsk,innercvx,all,filt,msk0] = raw2msks(raw,varargin)

    radius = 15;
    if nargin == 2
        radius = varargin{1};
    end

    % Get binary mask based upon std filter
    all  = sum(raw(:,:,[2,3]),3);
    filt = imadjust(stdfilt(all));
    msk0  = imbinarize(filt.^1.1);
    
    % Dilate then erode using strel('disk',radius)
    se   = strel('disk',radius,8);
    msk  = imdilate(msk0,se);
    msk  = imerode(msk,se);
    msk  = bwareaopen(msk,10000);

    % Find spheroid
    msk1 = imfill(msk,'holes');
    cvx1 = bwconvhull(msk1);
    
    % Find necrotic core
    msk2 = ~msk & msk1;
    msk2 = bwareaopen(msk2,2*nnz(se.Neighborhood));
    msk2 = bwareafilt(msk2,1);
    cvx2 = bwconvhull(msk2);
    
    % Output
    msk  = msk1;
    cvx  = cvx1;
    
    innermsk = msk2;
    innercvx = cvx2;

      
end