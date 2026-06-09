%把块以行顺序转换成一行

function line=blo2line(block)
trans_block=block';%转置矩阵
lie_block=trans_block(:);%转置矩阵变为一列
line=lie_block';%变为一行