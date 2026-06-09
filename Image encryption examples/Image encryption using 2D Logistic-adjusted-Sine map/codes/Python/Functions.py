#================================================================================
#This functionto is to do image encryption using the reference in
#         [1]. Hua, Zhongyun, et al. "Image encryption using 2D Logistic-adjusted-Sine map." 
#              Information Sciences 339 (2016): 237-253.
#All copyrights are reserved by Zhongyun Hua. E-mial:huazyum@gmail.com
#All following source code is free to distribute, to use, and to modify
#    for research and study purposes, but absolutely NOT for commercial uses.
#If you use any of the following code in your academic publication(s), 
#    please cite the corresponding paper. 
#If you have any questions, please email me and I will try to response you ASAP.
#It worthwhile to note that all following source code is written unser Spyder (Python 2.7)
#================================================================================

import math
import numpy as np


def ImageCipher(P,K,para):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This is the main function to implement image cipher
# P:    the input image;
# para: operation type, 'en' or 'de';
# K:    the key, if para = 'en', it can be given or can not be given; 
#       if para = 'de', it must be given;
# varargout: if K is not given, return the result and the randomly
#            generated key; if K is given, return the result.
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0 = 0.0; y0 = 0.0; a = 0.0; T = 0.0; G = [0 for x in range(2)];
    
    for i in range(0,52):
        x0 += K[i]*pow(2,i);
        y0 += K[i+52]*pow(2,i);
        a  += K[i+104]*pow(2,i);
        T  += K[i+156]*pow(2,i);
    x0 = x0/pow(2,52); y0 = y0/pow(2,52); a = a/pow(2,52); T = T/pow(2,52);
    for i in range(0,12):
        G[0] += K[i+208]*pow(2,i);
        G[1] += K[i+220]*pow(2,i);
    
    
    X = [0 for x in range(2)];Y = [0 for x in range(2)];A = [0 for x in range(2)];
    
    for i in range(0,2):
        X[i] = float((x0+T*G[i]) % 1);
        Y[i] = float((y0+T*G[i]) % 1);
        A[i] = float((a+T*G[i]) % 0.4 + 0.5);
            
    

    r = len(P);
    c = len(P[1,:]);
    
    if para == 'en':
        C = ImageExtend(P,r,c);
        r = r + 2;
        c = c + 2;
    else:
        C = P;
    S1  =  ChaoticSeq(X[0],Y[0],A[0],r,c);
    S2  =  ChaoticSeq(X[1],Y[1],A[1],r,c);
    
    if para == 'en':
       C = ImageShuffling(C,S1,'en');
       C = ImageSub(C,S1,'en');
       C = ImageShuffling(C,S2,'en');
       C = ImageSub(C,S2,'en');
    elif para == 'de':
       C = ImageSub(C,S2,'de');
       C = ImageShuffling(C,S2,'de');
       C = ImageSub(C,S1,'de');
       C = ImageShuffling(C,S1,'de');
       
       C = C[1:(r-1),1:(c-1)]; 
    else:
        print('Error!');

    return C;

def ImageExtend(P,r,c):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is add random values to surroundings of the image
# P: input image
# (r,c); image size
# C: output image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if np.max(P) > 1:
        b = 256;
    else:
        b = 2;
    Rows = np.random.randint(0,b,(2,c));
    Coloumns = np.random.randint(0,b,(r+2,2));
    C = np.zeros([r+2,c+2],int);
    C[1:r+1,1:c+1] = P;
    C[0,1:c+1] = Rows[0,:];
    C[r+1,1:c+1] = Rows[1,:];
    C[0:r+2,0] = Coloumns[:,0];
    C[0:r+2,c+1] = Coloumns[:,1];
    
    return C;
    
    
def ChaoticSeq(x0,y0,a,r,c):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is generate chaotic sequence
# (x0,y0,a): initial state
# (r,c): image size
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Z = np.zeros([r,c],int);
    x = x0;
    y = y0;
        
    for i in range(0,r):
        for j in range(0,c):
             x = math.sin(math.pi*a*(y+3)*x*(1-x));
             y = math.sin(math.pi*a*(x+3)*y*(1-y));
             Z[i,j] = int((x+y)*pow(2,30) % 256);
    return Z     
             

def ImageShuffling(P, S, para):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to bit manipulation confusion 
# P: input image
# S: chaotic sequence
# para: operation type, 'en' or 'de'
# C: output image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r = len(P);
    c = len(P[1,:]);
    b_i = int(np.ceil(np.log2(r*c)));
    if np.max(P) > 1:
        b_p = 8;
    else:
        b_p = 1;
    C = np.zeros([r,c],int);
    C_t = np.zeros([r,c],int);
    T = np.zeros([r,c],long);
    TT = np.array(range(r*c), dtype='a46').reshape(r,c);
    if para == "en":
        for i in range(0,r):
            for j in range(0,c):
                index_bin = bin(i*c+j)[2:].zfill(b_i);
                P_bin = bin(P[i][j])[2:].zfill(b_p);
                
                
                s = bin(S[i,j])[2:].zfill(8);
                temp_bin = s + index_bin + P_bin;
                TT[i,j] = temp_bin;
    
                
        TT.sort();
     
        for i in range(0,c):
            TT[:,i].sort();
            
        for i in range(0,r):
            for j in range(0,c):
                C[i,j] = int(TT[i,j][(8+b_i):(8+b_i+b_p)], 2);
                
    elif para == 'de':
        for i in range(0,r):
            for j in range(0,c):
                index_bin = bin(i*c+j)[2:].zfill(b_i);
                
                s = bin(S[i,j])[2:].zfill(8);
                temp_bin = s + index_bin;
                T[i][j] = int(temp_bin,2);
        index_r = np.zeros([r,c],int);
        for i in range(0,r):
            ss = sorted(range(c), key=lambda k: T[i,:][k])
            temp = np.asarray(ss);
            for j in range(0,len(temp)):
                index_r[i][j] = temp[j];

        T.sort();
        
        index_c = np.zeros([r,c],int);
        for j in range(0,c):
            ss = sorted(range(r), key=lambda k: T[:,j][k])
            temp = np.asarray(ss);
            for i in range(0,len(temp)):
                index_c[i][j] = temp[i];

        for i in range(0,r):
            for j in range(0,c):
                C_t[index_c[i][j]][j] = P[i][j];
        for i in range(0,r):
            for j in range(0,c):
                C[i][index_r[i][j]] = C_t[i][j];
    else:
        print('Error!');
    return C;
    
def ImageSub(P,S,para):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to bit manipulation diffusion 
# P: input image
# S: chaotic sequence
# para: operation type, 'en' or 'de'
# C: output image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r = len(P);
    c = len(P[1,:]);
    
    if np.max(P) > 1:
        b = 256;
    else:
        b = 2;
    if para == 'en':
        C = np.zeros([r,c],int);
        for i in range(0,r):
            for j in range(0,c):
                t = S[i,j] % b;

                if (i == 0) and (j == 0):

                    C[0,0] = P[r-1,c-1]^t^P[i,j];
                elif j == 0:
                    C[i,j] = C[i-1,c-1]^t^P[i,j];
                else:
                    C[i,j] = C[i,j-1]^t^P[i,j];
        return C;
    elif para == 'de':
        C = P;
        D = np.zeros([r,c],int);
        for i in xrange(r-1,-1,-1):
            for j in xrange(c-1,-1,-1):
                t = S[i,j] % b;
                if (i==0) and (j==0):
                    D[0,0] = C[0,0]^t^P[r-1,c-1];
                elif j==0:
                    D[i,j] = C[i,j]^t^C[i-1,c-1];
                else:
                    D[i,j] = C[i,j]^t^C[i,j-1];
        return D;
    else:
         print('Error!');

                    
            
            
        
        