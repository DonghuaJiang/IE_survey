function x=logistic(seed,u,n)
x=zeros(1,n);
for i=1:n
    x(i)=seed*u*(1-seed);
    seed=x(i);
end