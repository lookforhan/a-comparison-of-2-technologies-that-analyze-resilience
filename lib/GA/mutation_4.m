%��mutation.m��������,���Կ��ǹܶβ�ͬ�ƻ�ģʽ
%�ӳ�������Ⱥ����������������ƴ洢Ϊmutation.m
function [snnew,temp]=mutation_4(snew,pmax_mut,pmin_mut,p_mut3,I_all,I_max,I_min,BitLength,manum)
%�ڹ���������ͨ�ɿ����Ż���manum��Ϊdamage_num*D_num
%���������������Ϊ��1�������ĸ���Ϊp_mut3
global mut_type %�������ķ���:1,���ù̶��ı������;2,���ݸ��������Ȳ�ͬ���ò�ͬ�ı������;
chb=round(rand*(BitLength-1))+1;  %��[1,BitLength]��Χ���������һ������λ
snnew=snew;
temp=0; %��¼�Ƿ����
if snew(chb)==0
    %���������0��Ϊ�����ĸ���
    if mut_type==1
        p_mut1=p_mut3;
    else
        p_mut1=pmax_mut-(pmax_mut-pmin_mut)*(I_max-I_all(chb))/(I_max-I_min);
    end
    pmm=IfCroIfMut(p_mut1);  %���ݱ�����ʾ����Ƿ���б��������1���ǣ�0���
    if pmm==1
        snnew(chb)=round((manum-1)*rand)+1; %��ֹ����0
        temp=1;
    end
else
    %���������������Ϊ0�ĸ���
    if mut_type==1
        p_mut2=p_mut3;
    else
        p_mut2=pmax_mut-(pmax_mut-pmin_mut)*(I_all(chb)-I_min)/(I_max-I_min);
    end
    %���������������Ϊ��1�������ĸ���Ϊp_mut3
    if (IfCroIfMut(p_mut2)+IfCroIfMut(p_mut3))>0 %���ڱ���
        p_mut=p_mut2/(p_mut2+p_mut3); %�������������С��p_mutʱ,ִ����������Ϊ0
        pmm=IfCroIfMut(p_mut);
        if pmm==1 %ִ��������Ϊ0�������
            snnew(chb)=0;
            temp=1;
        else %ִ��������Ϊ�����������
            if manum>1 %��manum=1ʱ,��ʵΪ01����.
                mid=round((manum-1)*rand)+1; %��ֹ����0
                if mid~=snnew(chb) %��ֹ�����������ԭ������ֵ��ͬ
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