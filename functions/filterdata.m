%%FILTERDATA    Removes rejected images and spheroids that were mounted in
% wrong mounting solution.
%
% Mounting solution batchs
% A - Causes expansion.
% B - Causes expansion. 
% C - No expansion.
% D - No expansion.
% E - No expansion.
% 
% 12-May-2021:              All B
% 14-May-2021, D7 Data: 	All B
% 14-May-2021, D10 Data: 	All C
% 18-May-2021               All D
%
function datafilt = filterdata(data)

    keep = false(length(data),1);
    for i = 1:length(data)
        
        keep(i) = data(i).Keep;
        
    end
    
    datafilt = data(keep);

end