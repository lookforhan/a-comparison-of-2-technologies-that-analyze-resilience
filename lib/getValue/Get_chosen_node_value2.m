%% ���ָ��id�Ľڵ��ѹ������ˮ��
%% ����
% original_junction_num �ڵ�����
% node_id �ڵ��id
%% ���
% pre ѹ��
% dem ��ˮ��
function [t,value_out]=Get_chosen_node_value2(node_id,paramcode)
   node_id_k=libpointer('cstring','node_id_k');
%     paramcode = libpointer('int32Ptr',value_type);
    value=libpointer('singlePtr',0);%ָ�����--ֵ
%      value_dem=libpointer('singlePtr',0);%ָ�����--ֵ
     original_junction_num= numel(node_id);
     value1=zeros(original_junction_num,1);
     value2=zeros(original_junction_num,1);
    for k1=1:original_junction_num
        node_index_k1=libpointer('int32Ptr',0);
        node_id_k1=libpointer('cstring',node_id{k1,1});
        [code,~,node_index_k1]=calllib('epanet2','ENgetnodeindex',node_id_k1,node_index_k1);%ָ���ڵ�id��index
        if code~=0
           value1(k1,1)=0;
           value2(k1,1)=0;
%            value3(k1,1)=0;
           continue
        end

        [~,value]=calllib('epanet2','ENgetnodevalue',node_index_k1,paramcode,value);%index ��ѹ��
%         [~,value_dem]=calllib('epanet2','ENgetnodevalue',node_index_k1,9,value_dem);%index ����ˮ��
%         [~,value_length]=calllib('epanet2','ENgetnodevalue',node_index_k1,1,value_length);%index ����ˮ��
        [~,node_id_k]=calllib('epanet2','ENgetnodeid',node_index_k1,node_id_k);
        value1(k1,1)=value;
%         value2(k1,1)=value_dem;
%         value3(k1,1)=value_length;
%         clear node_index_k1
    end
%     pre=double(value1);
%     dem=double(value2);
    value_out = double(value1);
    t = 0;
end