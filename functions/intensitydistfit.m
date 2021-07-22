%%INTENSITYDISTFIT
% Fit Gompertz curve to green channel inteensity distribution.
function [pout,fout] = intensitydistfit(R,I,varargin)

    % Exclude first bin
    R = R(2:end);
    I = I(2:end);

    % Maximum distance
    Dmax = (R(2) - R(1))/2 + R(end);
    
    % Function to fit
    fun = @(r,p) p(1) * exp(-exp(p(2) * (r - p(3))));
    
    % Residual  function
    res = @(p) sum((I - fun(R,p)).^2);
    
    % Start points to try
    if nargin == 2
        P = [0.5,0.1,0.2*Dmax; 0.5,0.1,0.5*Dmax;  0.5,0.1,0.8*Dmax];
    else
        P = varargin{1};
    end
    
    % Fit using fminsearch (for each starting point)
    resids = zeros(size(P,1),1);
    for i = 1:size(P,1)
        [p,resid] = fminsearch(res,P(i,:),optimset('Display','none'));
        P(i,:)    = p;
        resids(i) = resid;
    end
    
    % Find best fit
    [~,idx] = min(resids);
    pout = P(idx,:);
    fout = @(r) fun(r,pout);
    
    % Remove influential points/outliers and fit again (> 3 * std(eps))
%     eps    = fun(R,pout) - I;
%     ignore = abs(eps) > 3 * std(eps);
%     if any(ignore)
%         [pout,fout] = intensitydistfit(R(~ignore),I(~ignore),pout);
%     end
    
   
end