% treppeniterationQR.m – function implementing the treppeniteration 
% QR decomposition for product of matrices.
function [Q,R] = treppeniterationQR(matFact)
    [~,dimOde,nFactors] = size(matFact);
    R = zeros(dimOde,dimOde,nFactors);
    Q = eye(dimOde,dimOde);
    for jFactor = nFactors:-1:1
        C = matFact(:,:,jFactor)*Q;
        [Q,R(:,:,jFactor)] = qr_pos(C);
    end
end
