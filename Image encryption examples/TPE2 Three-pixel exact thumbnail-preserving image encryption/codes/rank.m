%rank º¯Êý
%group=ÏñËØ×é
function r=rank(group)
r=0;
s=sum(sum(group(:)));
    for j=0:1:s
       for z=0:1:s-j
          for k=0:1:s-j-z
              if j+z+k==s && j<=255 && z<=255 && k<=255
                 r=r+1;
                 if group(1)==j && group(2)==z
                     return;
                 end
              end
          end
       end
    end
    
    
% a=group(1);
% b=group(2);
% c=group(3);
% be_begin=begin_group(group);
% s=sum(sum(group(:)));
% if  s<=255
%     begin=s+1;
%     t1=a-1;
% 
% end


