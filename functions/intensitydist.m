%%INTENSITYDIST
% Get pixel intensity distribution of spheroid using given channel.
function [I,R,D] = intensitydist(ch,cvx,varargin)

    % Optional inputs
    p = inputParser;
    addOptional(p,'nbins',100);
    addOptional(p,'Scale',1);
    addOptional(p,'Mask',ones(size(ch)));
    addOptional(p,'Clip',0);
    parse(p,varargin{:});

    % Clip bottom 'Clip'
    ch = imadjust(ch,[p.Results.Clip,1]);
    
    % Calculate distance of each pixel to edge of convex hull
    D  = double(bwdist(~cvx,'euclidean'));
    Dmax = max(D,[],'all');
    
    % Create histogram
    nbins = p.Results.nbins;
    dr    = Dmax / nbins;
    R     = linspace(dr/2, Dmax - dr/2, nbins); R = R(:);
    I     = zeros(length(R),1);
    for i = 1:nbins
        inbin = ((D > R(i) - dr / 2) & (D <= R(i) + dr / 2)) & p.Results.Mask;
        n     = nnz(inbin);
        if n > 0
            I(i) = sum(ch(inbin)) / n;
        end
    end
    
    % Scale
    I     = I  - min(I);
    I     = I ./ max(I);

    R = R ./ p.Results.Scale;
    D = D ./ p.Results.Scale;
    
end