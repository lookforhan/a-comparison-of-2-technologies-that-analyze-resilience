%% ���ָ��id�Ľڵ��ѹ������ˮ��
%% ����
% original_junction_num �ڵ�����
% node_id �ڵ��id
%% ���
% pre ѹ��
% dem ��ˮ��
function [pre,dem]=Get_chosen_node_value(original_junction_num,node_id)
   node_id_k=libpointer('cstring','node_id_k');
    
    value_pre=libpointer('singlePtr',0);%ָ�����--ֵ
     value_dem=libpointer('singlePtr',0);%ָ�����--ֵ
     value1=zeros(original_junction_num,1);
     value2=zeros(original_junction_num,1);
    for k1=1:original_junction_num
        node_index_k1=libpointer('int32Ptr',0);
        node_id_k1=libpointer('cstring',node_id{k1,1});
        [code,node_id_k1,node_index_k1]=calllib('epanet2','ENgetnodeindex',node_id_k1,node_index_k1);%ָ���ڵ�id��index
        if code~=0
           value1(k1,1)=0;
           value2(k1,1)=0;
%            value3(k1,1)=0;
           continue
        end

        [~,value_pre]=calllib('epanet2','ENgetnodevalue',node_index_k1,11,value_pre);%index ��ѹ��
        [~,value_dem]=calllib('epanet2','ENgetnodevalue',node_index_k1,9,value_dem);%index ����ˮ��
%         [~,value_length]=calllib('epanet2','ENgetnodevalue',node_index_k1,1,value_length);%index ����ˮ��
        [~,node_id_k]=calllib('epanet2','ENgetnodeid',node_index_k1,node_id_k);
        value1(k1,1)=value_pre;
        value2(k1,1)=value_dem;
%         value3(k1,1)=value_length;
%         clear node_index_k1
    end
    pre=double(value1);
    dem=double(value2);
end