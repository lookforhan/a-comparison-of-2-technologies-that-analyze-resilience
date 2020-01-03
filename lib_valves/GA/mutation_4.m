%与mutation.m区别在于,可以考虑管段不同破坏模式
%子程序：新种群变异操作，函数名称存储为mutation.m
function [snnew,temp]=mutation_4(snew,pmax_mut,pmin_mut,p_mut3,I_all,I_max,I_min,BitLength,manum)
%在管网抗震连通可靠度优化中manum即为damage_num*D_num
%基因编码由整数变为另1个整数的概率为p_mut3
global mut_type %基因变异的方法:1,采用固定的变异概率;2,根据个体灵敏度不同采用不同的变异概率;
chb=round(rand*(BitLength-1))+1;  %在[1,BitLength]范围内随机产生一个变异位
snnew=snew;
temp=0; %记录是否变异
if snew(chb)==0
    %基因编码由0变为整数的概率
    if mut_type==1
        p_mut1=p_mut3;
    else
        p_mut1=pmax_mut-(pmax_mut-pmin_mut)*(I_max-I_all(chb))/(I_max-I_min);
    end
    pmm=IfCroIfMut(p_mut1);  %根据变异概率决定是否进行变异操作，1则是，0则否
    if pmm==1
        snnew(chb)=round((manum-1)*rand)+1; %防止出现0
        temp=1;
    end
else
    %基因编码由整数变为0的概率
    if mut_type==1
        p_mut2=p_mut3;
    else
        p_mut2=pmax_mut-(pmax_mut-pmin_mut)*(I_all(chb)-I_min)/(I_max-I_min);
    end
    %基因编码由整数变为另1个整数的概率为p_mut3
    if (IfCroIfMut(p_mut2)+IfCroIfMut(p_mut3))>0 %存在变异
        p_mut=p_mut2/(p_mut2+p_mut3); %当产生的随机数小于p_mut时,执行由整数变为0
        pmm=IfCroIfMut(p_mut);
        if pmm==1 %执行整数变为0变异操作
            snnew(chb)=0;
            temp=1;
        else %执行整数变为整数变异操作
            if manum>1 %当manum=1时,其实为01编码.
                mid=round((manum-1)*rand)+1; %防止出现0
                if mid~=snnew(chb) %防止产生随机数与原编码数值相同
                    snnew(chb)=mid;
                elseif mid>1
                    snnew(chb)=mid-1;
                elseif mid==1
                    snnew(chb)=mid+1;
                end
                temp=1;
            end
        end
    end
end