function [ length ] = Get_chosen_link_value( link_id )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
funcName =' Get_chosen_link_value';
length = 0;
link_id_k=libpointer('cstring','link_id_k');
value_len=libpointer('singlePtr',0);%ָ�����--ֵ
num = numel(link_id);
for i =1:num
    index =i;
    [c1,value_len] = calllib('epanet2','ENgetlinkvalue',index,1,value_len);
    [c2,value_status] = calllib('epanet2','ENgetlinkvalue',index,11,value_len);%��ǰ�ܵ�״̬
    if c1||c2
        disp([funcName,'c1',num2str(c1),'c2',num2str(c2)])
    end
    if value_status ==0
%         length 
    else
        length = length +double(value_len);
    end
end

end

