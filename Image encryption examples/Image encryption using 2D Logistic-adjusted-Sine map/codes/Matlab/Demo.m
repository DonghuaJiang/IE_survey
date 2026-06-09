%%================================================================================
%This functionto is to demonstrate image encryption using the reference in
%         [1]. Hua, Zhongyun, et al. "Image encryption using 2D Logistic-adjusted-Sine map." 
%              Information Sciences 339 (2016): 237-253.
%All copyrights are reserved by Zhongyun Hua. E-mial:huazyum@gmail.com
%All following source code is free to distribute, to use, and to modify
%    for research and study purposes, but absolutely NOT for commercial uses.
%If you use any of the following code in your academic publication(s), 
%    please cite the corresponding paper. 
%If you have any questions, please email me and I will try to response you ASAP.
%It worthwhile to note that all following source code is written under MATLAB R2010a
%    and that files may call built-in functions from specific toolbox(es).
%%================================================================================
%%
clear all
close all
clc
%% 1. Load plaintext images
% Image 1
P = imread('cameraman.tif');
%%=========================================================================

%% 2. Encryption
[C,K] = ImageCipher(P,'en');
%%=========================================================================

%% 3. Decryption
D = ImageCipher(C,'de',K);
%%=========================================================================

figure,
subplot(231),imshow(P,[]),subplot(232),imshow(C,[]),subplot(233),imshow(D,[]),
subplot(234),imhist(P),subplot(235),imhist(C),subplot(236),imhist(D)
%%=========================================================================
