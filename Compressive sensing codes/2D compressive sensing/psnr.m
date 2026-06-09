function [PSNR] = psnr(P1,P2)
% 计算两幅图像数据之间的峰值信噪比
    [M,N] = size(P1);
    B = 8;                                                                 % 编码一个像素用多少二进制位
    MAX = 2.^B-1;                                                          % 图像有多少灰度级
    MES = sum(sum((double(P1)-double(P2)).^2))/(M*N);                      % 均方差
    averageMES = sum(MES(:))/3;
    PSNR = 20*log10(MAX/sqrt(averageMES));                                 % 图像的峰值信噪比
end

