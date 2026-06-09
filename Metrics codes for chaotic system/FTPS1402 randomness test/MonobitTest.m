function x = MonobitTest(BitStream)
%x is the number of ones in a bit stream of 20,000 bits
%acceptance region: 9725<x<10275
%the first test of FIPS 140-2
%lss, 2012-7-10

OnesIndex = find(BitStream==1);
x = length(OnesIndex);