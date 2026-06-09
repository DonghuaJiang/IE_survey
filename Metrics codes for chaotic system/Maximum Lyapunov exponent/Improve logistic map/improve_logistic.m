function newx = improve_logistic(x)
	newx = x(2)*x(1)*(1-x(1))*2^(14)-floor(x(2)*x(1)*(1-x(1))*2^(14));
end