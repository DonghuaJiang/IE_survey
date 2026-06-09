clc
clear all
%  rng(100)
 rng(200)
 D0 = randn(256,512);
 
% % load Do
% load test
% D0=Rx;
A_max=[];
% % % % % % % % % % Adam迭代200步
rho=0.01;
lambda=0.003;
iter=200;
Dt1=pcsnm_adam(D0,iter,rho,lambda); 


% % % % % % % % % % NADAM参数设置
% rho=0.01;
% lambda=0.03;
% iter=50;
%%%%%%%%%%%%%%%%%%%PSC
% rho=0.5;
% lambda=0.2;
% iter=200;
% Dt2=OP_Tong_f_pcsnm_nag(D0,iter,rho,lambda); 
%%%%%%%%%%%%%%%%%Lu
% iter=200;
% Dt3=OP_Lu_fct(D0,iter);
%%%%%%%%%%%%%%%%%Sadeghi
% iter=200;
% Dt=OP_Sade_f(D0,iter);
%%%%%%%%%%%%%%%Abol
iter=200;
Ka=iter;
Dt4=OP_Abol_f(D0,iter,Ka);

%%%%%%%%%%%%计算相干性
A=corrcoef(D0);
[m,n]=size(A);
C=eye(m);
A_cor=A-C;
A_max=max(max(abs(A_cor)))
% for i = 41:40:iter+1
%     i-1
% %     Dt=pcsnm_adam(D0,i-1,rho,lambda); 
% %     Dt=OP_Tong_f_pcsnm_nag(D0,i,rho,lambda); 
% %      Dt=OP_Lu_fct(D0,i);
% %     Dt=OP_Sade_f(D0,i);
%     Dt=OP_Abol_f(D0,i,i);
%     B=corrcoef(Dt);
%     B_cor=B-C;
%     D_max=max(max(abs(B_cor)));
%     A_max=[A_max D_max];
% end
% A_max=A_max';

B=corrcoef(Dt);
B_cor=B-C;
max(max(abs(B_cor)))
 

