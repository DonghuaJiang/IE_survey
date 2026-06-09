#================================================================================
#This functionto is to demonstrate image encryption using the reference in
#         [1]. Hua, Zhongyun, et al. "Image encryption using 2D Logistic-adjusted-Sine map." 
#              Information Sciences 339 (2016): 237-253.
#All copyrights are reserved by Zhongyun Hua. E-mial:huazyum@gmail.com
#All following source code is free to distribute, to use, and to modify
#    for research and study purposes, but absolutely NOT for commercial uses.
#If you use any of the following code in your academic publication(s), 
#    please cite the corresponding paper. 
#If you have any questions, please email me and I will try to response you ASAP.
#It worthwhile to note that all following source code is written under Spyder (Python 2.7)
#================================================================================

from PIL import Image
import numpy as np
import Functions as fn
import Functions_hua as fns
from pylab import *

im = Image.open('5.1.09.tiff'); 
P = np.asarray(im);
Size = P.shape;
P2 = np.zeros([Size[0],Size[1]],int);


for i in range(0,Size[0]):
    for j in range(0,Size[1]):
        P2[i,j] = P[i,j];
    
        
r = np.random.randint(0,Size[0]);
c = np.random.randint(0,Size[1]);

if P2[i,j] == 0 :
    P2[r,c] =  1;
else:
    P2[r,c] = 0;
        

K = load('K.npy');


# Deomonstration of encryption and decryption
C_1 = fn.ImageCipher(P,K,'en');
D_1 = fn.ImageCipher(C_1,K,'de');
#############################################

# Calculate time cost
from time import clock
start=clock()
C_2 = fn.ImageCipher(P,K,'en');
finish=clock()
print (finish-start)
#############################################


#calcualte NPCR and UACI
C = fn.ImageCipher(P,K,'en');
C2 = fn.ImageCipher(P2,K,'en');
D = fn.ImageCipher(C,K,'de');
CC = fns.Correlation(C);
print(fns.NPCR(C,C2))
print(fns.UACI(C,C2))
#############################################