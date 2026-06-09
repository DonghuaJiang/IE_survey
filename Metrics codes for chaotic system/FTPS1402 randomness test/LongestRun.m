function x = LongestRun(BitStream)
%the length of the longest run is examined which appear in 20,000bit.
%x is the length of the longest run in bit stream of 20,000 bit, both of
%one and sero
%accepteance region: x<26
%the 4th test of FIPS 140-2
%lss,2012-07-11

 BitNumVec =  BitStream;
%  BitNumVec =  BitStream2NumVec(BitStream);
 %BitNumVec = diff(BitNumVec);
 
 c = 0;
 x = 0;
 t = 1;
 
 count = length(BitNumVec);
 for i=1:count-1
     if (BitNumVec(i)==BitNumVec(i+1))
         c = c+1;
     else
         LongRunMat(t) = c;
         c = 0;
         t = t+1;
     end 
 end
 
 x = max(LongRunMat);