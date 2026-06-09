function [medianKcreg, medianKcCorr] = calcuKcreg(dataSet)
%函数功能：01测试进行100次，随机选择常数cont，得到Kcreg修正值
%输入参数：dataSet测试数据集
%输出参数：medianKcreg计算出来的Kcreg的中位数
    for Numcalcu = 1:1
        cont = pi/5+3*pi/5.*rand(1); 
        [~,Kcreg,KcCorr] = ZeroOneTest(dataSet,cont);  
        Kcreg1(Numcalcu) = Kcreg;  
        KcCorr1(Numcalcu) = KcCorr;
    end
    medianKcreg = median(Kcreg1,2);
    medianKcCorr = median(KcCorr1,2);
end