% rank_time=zeros(2,766);
for s=740:1:765
    rank_clock=0;
    fu_clock=0;
    if s<=510
        begin_a=0;
    else
        begin_a=s-510;
    end
    if s<=255
        end_a=s;
    else
        end_a=255;
    end
    for i=begin_a:1:end_a%第一个元素
        s2=s-i;
        all_r2=domain_2(s2);
        for j=0:1:all_r2-1
           [x,y]=rank_opposite_2(s2,j); %第二个第三个元素
           group=[x,y];
           group=[i,group];
           t1=clock;
           SN=rank(group);
           t2=clock;
           rank_clock=rank_clock+etime(t2,t1);
           t3=clock;
           fu_group=rank_opposite(SN,s);
           t4=clock;
           if fu_group~=group
              break; 
           end
           rank_clock=rank_clock+etime(t2,t1)*10000;
           fu_clock=fu_clock+etime(t4,t3)*10000;
        end
    end
    n=domain_num(s);
    aver_rank=rank_clock/n;
    aver_fu=fu_clock/n;
    rank_time(1,s+1)=aver_rank;
    rank_time(2,s+1)=aver_fu;
    s
    save('TPE2aver_timetest740','rank_time');
end

save('TPE2aver_timetest740','rank_time');