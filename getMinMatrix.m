% find minimum for each position
function y = getMinMatrix(x1, x2)
    y = zeros(size(x1));
    
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
           y(i, j) = min(x1(i, j), x2(i, j)); 
        end
    end
end