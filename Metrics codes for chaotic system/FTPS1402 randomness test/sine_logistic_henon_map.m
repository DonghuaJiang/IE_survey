function sequence = sine_logistic_henon_map(x, t)
%x is the initial vector with four elements, randged in (0,1)
%P is the set of parameters, vecoter of 4 elements, in order are mu1, mu2,mu3 ,mu4 
%0<=mu1<=1,0<=mu2<=3,mu3¡¢mu4¡ÊR
%t is the interation times
%sequence is the produced chaotic sequence, two vectors
%lss, 2020/12/11

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);

% mu1 = 0.8;
% mu2 = 2.6;
mu1 = 1;
mu2 = 3;
% mu3=3.599;
% mu4 = 0.7;
mu3=8;
mu4 =3;
% mu3=12;
% mu4 =3;

%if(mu1<0)condition desision

sequence = zeros(4,t);
sequence(1,1) = x1;
sequence(2,1) = x2;
sequence(3,1) = x3;
sequence(4,1) = x4;

for i=2:t
%     sequence(1,i) = mu1*(sin(pi*sequence(2,i-1)^2)+mu2)*(1-sequence(1,i-1))*sequence(1,i-1);
%     sequence(2,i) = mu1*(sin(pi*sequence(1,i)^2 ) +mu2)*(1-sequence(2,i-1))*sequence(2,i-1);
%     sequence(3,i) = mod((1-mu3*(sin(pi*sequence(3,i-1)))^2+sequence(4,i-1)),1);
%     sequence(4,i) = mod(mu4*sin(pi*sequence(3,i-1)),1);
    sequence(1,i) = mu1*(sin(pi*sequence(2,i-1))+mu2)*(1-sequence(1,i-1))*sequence(1,i-1);
    sequence(2,i) = mu1*(sin(pi*sequence(1,i)) +mu2)*(1-sequence(2,i-1))*sequence(2,i-1);
    sequence(3,i) = mod((1-mu3*sin(sequence(3,i-1))^2+sequence(4,i-1)),1);
    sequence(4,i) = mod(mu4*sequence(3,i-1),1);
end