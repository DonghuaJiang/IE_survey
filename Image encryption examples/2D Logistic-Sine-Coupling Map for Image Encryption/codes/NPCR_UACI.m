function [ NP,UA ] = NPCR_UACI( P1,P2 )
% NPCR and UACI values

P1 = double(P1);
P2 = double(P2);
[M,N] = size(P1);
D = (P1~=P2);
NP = sum(sum(D))/(M*N)*100;
%fprintf('NPCR=%f%%.',NP);
UA = sum(sum(abs(P1-P2)))/(255*M*N)*100;
%fprintf('UACI=%f%%.',UA);

end

