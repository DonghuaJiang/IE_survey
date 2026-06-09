function A = NewMap(len,a,cx0,cy0)
% This 2d map is proposed in the Ref:"Image encryption algorithm for crowd 
% data based on a new hyperchaotic system and Bernstein polynomial", which
% is employed to construct the measurement matrix. Also, you can change it
% with other chaotic map.
    cx = zeros(1,1000+len); cy = zeros(1,1000+len); 
    cx(1) = cx0; cy(1) = cy0; 
    for j = 1 : 1000+len-1
        cx(j+1) = sin(pi*(cos((4-a)*acos(cx(j)))+sin(a/cy(j))));
        cy(j+1) = sin(pi*(cos((4-a)*acos(cy(j)))+sin(a/cx(j))));
    end
    A = (cx(1001:end)+cy(1001:end))/2;
end

