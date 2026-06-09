#================================================================================
#These are some functions about image encryption using the reference in
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

import numpy as np
import matplotlib.pyplot as plt


def Hist_gray(im):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is plot the histogram of grayscale image
# P: im
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    P = np.asarray(im);

  #  num_bins = 256;
   # for i in range(0,256*256):
    #    if i in P:
     #       num_bins += 1;
    
    plt.figure(figsize=(8, 8.05))
    plt.hist(P.flatten(), 256, edgecolor = "black",facecolor='black', alpha=0.5)
    plt.subplots_adjust(left=0.17, right=0.985, top=0.97, bottom=0.06)
    plt.ylabel('Count',fontsize=26)
    plt.xticks(fontsize=26)
    plt.xticks([0, 10000,20000, 30000, 40000, 50000, 60000],['0', '1E4','2E4','3E4','4E4','5E4','6E4'])
   # plt.yticks([0, 5000,10000, 15000, 20000],['0', '5E3','1E4','1.5E4','2E4'])
    plt.yticks(fontsize=26)

    plt.xlim(0,256*256);
    #plt.ylim(0,20000);
    

def Hist_bin(im):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is plot the histogram of binary image
# P: im
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P = np.asarray(im);
    num_bins = 2
    plt.figure(figsize=(8, 8.05))
    plt.hist(P.flatten(), num_bins, edgecolor = 'black',facecolor='black', alpha=0.5)
    plt.subplots_adjust(left=0.2, right=0.99, top=0.98, bottom=0.04)
    plt.ylabel('Count',fontsize=26)
    plt.xticks(fontsize=22)
    plt.yticks(fontsize=22)
    plt.xlim(0,1);
    
    ax=plt.gca()  
    ax.set_xticks(np.linspace(0.25,0.75,2))  
    ax.set_xticklabels( ('0', '1'))  
    
    
def Hist_rgb(im):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is plot the histogram of RGB color image
# P: im
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P = np.asarray(im);
    P1 = P[:,:,0];
    P2 = P[:,:,1];
    P3 = P[:,:,2];
    
    r = len(P1);
    c = len(P1[1,:]);
    
    Values = np.zeros([r*c,3],int);
    
    ii = 0;
    for i in range(0,r):
        for j in range(0,c):
            Values[ii,0] = P1[i][j];
            Values[ii,1] = P2[i][j];
            Values[ii,2] = P3[i][j];
            ii += 1;
    
    n_bins = 64
    
    
    plt.figure(figsize=(8, 8.05))
    colors = ['red', 'green', 'blue']
    plt.hist(Values, n_bins, histtype='bar', alpha=0.5, color=colors, label=colors)
    plt.legend(prop={'size': 22})
    plt.subplots_adjust(left=0.18, right=0.98, top=0.98, bottom=0.04)
    plt.ylabel('Count',fontsize=26)
    plt.xticks(fontsize=22)
    plt.yticks(fontsize=22)
    plt.xlim(0,255);

def NPCR(C1,C2):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the NPCR of two images
# (C1,C2): two input images
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = C1.shape;
    r = size[0]; c = size[1]; 
    D = np.ones([r,c],int);
    for i in range(0,r):
        for j in range(0,c):
            if C1[i,j] == C2[i,j]:
                D[i,j] = 0;
                
    npcr = float(np.sum(D))/(r*c);
    return npcr;
    
def UACI(C1,C2):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the UACI of two images
# (C1,C2): two input images
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = C1.shape;
    r = size[0]; c = size[1];
    if np.max(C1) > 2:
        L = 256;
    else:
        L = 2;
    N = 0;
    for i in range(0,r):
        for j in range(0,c):
            N = N + np.abs(C1[i,j] - C2[i,j]);
    uaci = float(N)/(r*c*(L-1));
    return uaci;
    
    
def LocalEntropy_Bin(C):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the Local Entropy of an binary image
# C: input image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = C.shape;
    r = size[0]; c = size[1];
    KK = np.zeros([2,30],int);

    for i in range(0,30):
        m = np.random.randint(0,r-1);
        n = np.random.randint(0,c);
        KK[0,i] = C[m,n];
        KK[1,i] = C[m+1,n];

            
    H = np.zeros([30,1],float);
    for i in range(0,30):
        pr1 = 0; pr2 =0;
        if KK[0,i] == 0:
            pr1 = 1;
        else:
            pr2 = 1;
        if KK[1,i] == 0:
            pr1 = pr1 + 1;
        else:
            pr2 = pr2 + 1;
        p1 = float(pr1)/2; p2 = float(pr2)/2;
        h =0;
        if p1 > 0:
            h = -p1*np.log2(p1);
        if p2 > 0:
            h = h -  p2*np.log2(p2);
        H[i] = h;
    LH = np.mean(H);
    return LH; 

    
def LocalEntropy(C):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the Local Entropy of an grayscale image
# C: input image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = C.shape;
    r = size[0]; c = size[1];
    KK = np.zeros([44,44,30],int);
    if r > 270:
        C1 = C[0:220,0:264];
        for i in range(0,30):
            a = i % 5;
            b = int(i/5);
            KK[:,:,i] = C1[44*a:44*(a+1), 44*b:44*(b+1)];
    else:
        C1 = C.reshape((r*c,1));
        C2 = C1[0:58080];
        KK = C2.reshape((44,44,30));
            
    H = np.zeros([30,1],float);
    for i in range(0,30):
        H[i] = Entropy(KK[:,:,i]);
    LH = np.mean(H);
    return LH;
    
def Entropy(C):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the  Entropy of an  image
# C: input image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = C.shape;
    r = size[0]; c = size[1];
    Pr = np.zeros([256,1],int);
    for i in range(0,r):
        for j in range(0,c):
            Pr[C[i,j]] = Pr[C[i,j]] + 1;
    
    
    h = 0;
    for i in range(0,256):
        t = float(Pr[i])/(r*c);
        if t == 0:
            h = h;
        else:
            h = h - t*np.log2(t);
    return h;
#    

def Correlation(P):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the correlation of an image
# P: input image
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    size = P.shape;
    r= size[0]; c = size[1];
    Ho = np.zeros([r*(c-1),2],float);
    Ve = np.zeros([(r-1)*c,2],float);
    Da = np.zeros([(r-1)*(c-1),2],float);
    i = 0; j = 0; k = 0;
    for m in range(0,r):
        for n in range(0,c):
            if m != (r-1):
                Ve[i,0] = P[m,n];
                Ve[i,1] = P[m+1,n];
                i = i+1;
            if n != (c-1):
                Ho[j,0] = P[m,n];
                Ho[j,1] = P[m,n+1];
                j = j+1;
            if (m!=(r-1)) and (n!=(c-1)):
                Da[k,0] = P[m,n];
                Da[k,1] = P[m+1,n+1];
                k = k+1;
            
    Corrs = np.zeros([3,1]);
    Corrs[0] = Corr2(Ho[:,0],Ho[:,1]);
    Corrs[1] = Corr2(Ve[:,0],Ve[:,1]);
    Corrs[2] = Corr2(Da[:,0],Da[:,1]);
    return Corrs;
        
def Corr2(V1,V2):
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This function is to cauculate the correlation of two vectors 
# (V1,V2): two input vectors
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M1 = np.mean(V1);
    M2 = np.mean(V2);
    
    S1 = np.std(V1);
    S2 = np.std(V2);
    size = V1.shape;
    r= size[0];
    
    SS = np.zeros([r,1]);
    for m in range(0,r):
        SS[m] = (V1[m] - M1)*(V2[m] - M1);
    Corre = np.mean(SS)/(S1*S1);
    return Corre
    
    
    
    
    
    
    
    
    
    
    
    