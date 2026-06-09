function  x = theRunTest(BitStream, n, BitValue)
%A run is defined as a sequence of consecutive values of one or zero. 
%The number of runs in bit stream of 20,000 bits is counted. 
%n is the run length, a integer from range of [1,6]
%BitValue is the value of consecutive value, '1' or '0'.
%the 3rd test of FIPS 140-2
%lss,2012-07-11
x = 0;

if (n<1)
    error('n should be a integer from range of [1,6]');
end

if(BitValue~='1'&& BitValue~='0')
    error('BitValue should be either 1 or 0 as a string');
end

count = length(BitStream);

% BitNumVec =  BitStream2NumVec(BitStream);
% BitNumValue = bit2num(BitValue);
% 
% BitNumVec = diff(BitNumVec);
    for i = 1:n+1
        CmpStr(i)=BitValue;
    end

    i=1;
    while i<=count-n
        segment = num2str(BitStream(i:i+n));
        c = strrep(segment, ' ', '');
        if(strcmp(c,CmpStr))
            x = x+1;
            i = i+n+1;
        else
            i = i+1;
        end 
    end
   
