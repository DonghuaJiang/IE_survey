function logarr = logsample(arr, rmin, rmax, xc, yc, nr, nw)
%logarr=logsample(初始图像，执行变换区域的内部半径，执行变换区域的外部半径，中心x，中心y，环数，楔形数）
%若rmin,rmax,nr,rw是空的，则采用下面所述的“圆采样”
% LOGSAMPLE  Compute log-polar transform of image
%     LOGARRAY = LOGSAMPLE(ARRAY, RMIN, RMAX, XC, YC, NR, NW) returns an
%     array of samples on a logarithmic grid. 
% 
%     ARRAY is the initial image array. 
%         
%     RMIN and RMAX are the radii of the innermost and outermost rings of
%     the log-polar sampling pattern, in terms of pixels in the original
%     image.  XC and YC are the position of the centre of the pattern in
%     the original image, in terms of the array indices of ARRAY.
%  
%     NR and NW specify the number of rings and the number of wedges in the
%     log-sampling pattern.
%
%       Any one of RMIN, RMAX, NR or NW may be given as the empty array. In
%       this case, it will be calculated from the other three using the
%       "circular samples" condition (see below).
% 
%     LOGARR(W+1, R+1) will contain the sample value for ring R and wedge
%     W. Ring 0 lies at radius RMIN and ring (NR-1) lies at radius RMAX in
%     the original image. Wedge W lies in the direction of the positive
%     x-axis, and W increases clockwise for an image in which the y-axis
%     points down the screen (as is normal). The next section gives the
%     exact relationship between ring and wedge indices and position in
%     terms of the original image's x and y coordinates. The imtransform
%     default of bilinear interpolation is adopted, but this could be
%     changed later with a resampler structure.
% 
% The log-polar formulae
% ----------------------
% 
% For reference, the formulae relating positions in the log-polar array to
% positions in the original image are as follows. R and W are ring and
% wedge numbers in the log-polar array and X and Y are column and row
% numbers in the original array, all treated as if they could take
% non-integer values.  For a sample at (X, Y):
% 
%                                         2           2
%     Radius of sample: P = sqrt( (X - XC)  + (Y - YC) )
% 
%     Angle of sample:  T = arctan( (Y - YC) / (X - XC) )
% 
%     Ring number:      R = K * log( P / RMIN )
% 
%         where         K = (NR - 1) / log( RMAX / RMIN )
% 
%     Wedge number:     W = NW * T / (2 * PI)
%
% The "circular samples" condition is
%
%                       RMAX = RMIN * exp( 2*pi*(NR-1)/NW )
%
% If this is satisfied, the spatial separation of neighbouring pixels in
% the log-polar array is approximately the same along the wedges and round
% the rings.
% 
% See also LOGSAMPBACK, LOGTFORM

% Copyright David Young 2010

t = logtform(rmin, rmax, nr, nw);% makes a log-polar transform structure for imtransform
nr = t.tdata.nr;        % Get computed values, in case default used
nw = t.tdata.nw;
[U, V] = size(arr);% UData和VData是输入图像的二维空间坐标 
Udata = [1, V] - xc; % 转换 新的坐标，
Vdata = [1, U] - yc;
Xdata = [0, nr-1]; % XData和YData是输出图像的二维空间坐标，坐标从0开始。
Ydata = [0, nw-1];% 这个值决定了坐标变换时坐标的范围，x=[0,1,2...499,0,1,2...499...];
Size = [nw, nr];   % size的两个非负整数确定输出图像的大小
logarr = imtransform(arr, t,'nearest', ...      % imtransform为执行t的运算的程序
     'Udata', Udata, 'Vdata', Vdata, ...
     'Xdata', Xdata, 'Ydata', Ydata, 'Size', Size);% 这里的输出比较大，是imtransform 自动填充输出
% 在上函数使用中 arr 当然为输入图像 
% maketform是点变换后的位置 
% bilinear是双线性三次插值 bicubic 是双三次插值（效果最好，但是运行时间最多）
% UData和VData是输入图像的二维空间坐标 
% XData和YData是输出图像的二维空间坐标 size的两个非负整数确定输出图像的大小，FillValves就是变换后空白的地方用什么颜色填充

a=1;
end