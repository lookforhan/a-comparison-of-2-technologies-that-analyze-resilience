function [ length ] = Get_link_value( link_id )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
length = 0;
link_id_k=libpointer('cstring','link_id_k');
value_len=libpointer('singlePtr',0);%ָ�����--ֵ
num = numel(link_id);
for i =1:num
    index =i;
    [c,value_len] = calllib('epanet2','ENgetlinkvalue',index,1,value_len);
    [c,value_status] = calllib('epanet2','ENgetlinkvalue',index,4,value_len);
    if value_status ==0
%         length 
    else
        length = length +value_len;
    end
end

end

