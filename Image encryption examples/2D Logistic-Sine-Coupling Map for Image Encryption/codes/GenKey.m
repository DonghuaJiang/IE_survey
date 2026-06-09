function [x, y, r1, r2, r3, r4] = GenKey( key )
% Generate the parameters of the chaotic system


calculate = @(key,st,ed) sum(key(st:ed).*2.^(-(1:(ed-st+1))));
integer = @(key,st,ed) sum(key(ed:-1:st).*2.^(0:(ed-st)));

if length(key)==256
    x = calculate(key,1,52);
    y = calculate(key,53,104);
    r = calculate(key,105,156);
    A1 = integer(key,157,181);
    A2 = integer(key,182,206);
    A3 = integer(key,207,231);
    A4 = integer(key,232,256);
    
    r1 = mod(r*A1,1);
    r2 = mod(r*A2,1);
    r3 = mod(r*A3,1);
    r4 = mod(r*A4,1);
    

end


end

