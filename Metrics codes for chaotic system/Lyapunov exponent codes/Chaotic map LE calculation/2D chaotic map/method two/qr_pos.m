% qr pos.m – function implementing the QR decomposition with positive diagonal elements in R.
function [Q,R] = qr_pos(A)
    [Q,R] = qr(A);
    D = diag(sign(diag(R)));
    Q = Q*D; 
    R = D*R;
end