function x = PokerTest(BitStream)
%the 20,000 bit stream is divided into non-overlapping consecutive 4 bits
%segments. the total number of patterns of 4 bits segments is 2^4=16. The
%number of occurrences of each of the 16 possible patterns is counted. g(i)
%is the number of occurences of each pattern.
% x = (16/5,000)*\sum_{i=1}^16 g(i)^2 - 5,000
% acceptance region is 2.16<x<46.17
% second test of FIPS 140-2
% lss, 2012-7-10

count = 5000;
g = zeros(1,16);

for i = 1:count
%     for j=1:4
%         segment(j) = num2str(BitStream(i*4-3+j-1));
%     end
    segment = num2str(BitStream(i*4-3:i*4));
    DecSegments = bin2dec(segment);
    g(DecSegments+1) = g(DecSegments+1)+1;
end

x = sum(g.^2)*16/5000 - 5000;