%%INTENSITYSUMMARY  Process fitted intensity distribution to obtain
%%distance cycling region extends from periphary
function periph = intensitysummary(p,Dmax,thresh)

    % Gompertz function
    fun  = @(r) p(1) * exp(-exp(p(2) * (r - p(3))));
    
    % Gompertz inverse function
    finv = @(i) p(3) + log(-log(i / p(1))) / p(2);
    
    % Check if green everywhere (i.e., phase 1)
    if fun(0) < fun(Dmax) || fun(Dmax) > thresh * fun(0)
        periph = Inf;
        
    % Otherwise, identify boundary
    else
        periph = finv(fun(0) * thresh);
        
    end

end