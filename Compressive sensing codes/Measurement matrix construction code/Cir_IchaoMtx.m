function [Pht]=Cir_IchaoMtx(M,N)
u = 2.0;
x = zeros(1,N);
x(1) = 0.37;

for k = 1:N-1
    x(k+1) = 1-u*x(k)*x(k);
end
for k = 1:N
    if x(k)<0
        x(k)=-1;
    elseif x(k)==0
        x(k)=0;
    else x(k)=1;
    end
end

Phi_t = toeplitz(circshift(x,[1,1]),fliplr(x(1:N)));
Pht = Phi_t(1:M,:);
end