AA=dlmread('mysbox8.txt');

where this AA is an 8x8 sbox either a 2D or 1D array holding the sbox values in decimal. 
The different sbox metrics functions are as follows:

[nl_avg, nl_arr]=nonlinearity(AA)

where,
nl_arr is a 1x8 array holding all 8 NLS of an 8x8 sbox & nl_avg is their average score.


[avg, table]=sac(AA)

where,
table is 8x8 (dependency matrix) table representing the sac scores, avg is the average of bic-sac table i.e. the SAC of 8x8 sbox. 


[avg, table]=bicsac(AA)

where,
table is 8x8 table representing the bic-sac scores, avg is the average of bic-sac table. 


[avg, table]=bicnn(AA)

where,
table is 8x8 table representing the bic-nl scores, avg is the average of bic-nl table. 


[du, table]=DP(AA)

where,
table is 16x16 I/O XOR distribution table for 8x8 sbox, du is the DU of sbox and the DP is DU/256.


[maxlp]=LP(AA)

where, maxlp is the LP of input 8x8 sbox.
 