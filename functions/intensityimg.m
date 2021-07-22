%%INTENSITYIMG      Create "smooth intesity image" to plot and identify
%%boundary
function img = intensityimg(fun,D)

    img   = (D > 0) .* (fun(D) / fun(0));

end