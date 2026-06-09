clc
clear

syms x y z;
global delt b r;
delt = 10; b = 8/3; r = 28;
q1 = -10*(x-y) == 0;
q2 = -x*z+28*x-y == 0;
q3 = x*y-8/3*z == 0;
[x1,y1,z1] = solve([q1,q2,q3],[x,y,z]);
answer = [x1,y1,z1];
a1 = [-delt, delt, 0; r-answer(1,3), -1, -answer(1,1); answer(1,2), answer(1,1), -b];
a2 = [-delt, delt, 0; r-answer(2,3), -1, -answer(2,1); answer(2,2), answer(2,1), -b];
a3 = [-delt, delt, 0; r-answer(3,3), -1, -answer(3,1); answer(3,2), answer(3,1), -b];
e1 = vpa(eig(a1));
fprintf('The eigenvalue 1 is :\n');                                                                                                           
disp(e1);
e2 = vpa(eig(a2));
fprintf('The eigenvalue 2 is :\n');                                                                                                           
disp(e2);
e3 = vpa(eig(a3));
fprintf('The eigenvalue 3 is :\n');                                                                                                           
disp(e3);