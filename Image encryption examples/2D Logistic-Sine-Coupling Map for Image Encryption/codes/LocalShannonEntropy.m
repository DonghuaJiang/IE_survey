function H = LocalShannonEntropy( I )
% Local œ„≈©Ïÿ

I = uint8(I);
HI=zeros(1,30);
format long eng
for i= 1:15
    row = (i-1)*16+1;
    blockI=I(row:(15+row),1:121); 
%     blockC=C(row:(15+row),1:121);
     p = imhist(blockI);
     p(p==0) = [];
     p = p ./ numel(blockI);
     EntropyI  = -sum(p.*log2(p));
     HI(2*i-1)=EntropyI;
%      b = imhist(blockC);
%      b(b==0) = [];
%      b = b ./ numel(blockC);
%      EntropyC  = -sum(b.*log2(b));
%      HC(2*i-1)=EntropyC;
    
    blockI=I(row:(15+row),122:242);
%     blockC=C(row:(15+row),122:242);
     p = imhist(blockI);
     p(p==0) = [];
     p = p ./ numel(blockI);
     EntropyI  = -sum(p.*log2(p));
     HI(2*i)=EntropyI;
%      b = imhist(blockC);
%      b(b==0) = [];
%      b = b ./ numel(blockC);
%      EntropyC  = -sum(b.*log2(b));
%      HC(2*i)=EntropyC;

end
H=mean(HI);

end

