function [ output_args ] = Set_chosen_node_value_EPANETx64PDD(lib_name,node_id,keyCode,Value)
%Set_chosen_node_value_EPANETx64PDD ����ָ���ڵ��ֵ
%   lib_name,��̬���ӿ������
%   node_id��ָ���ڵ��id
%   kyeCode����Ҫ���õĽڵ��ֵ�����ͣ��붯̬���ӿ�������ͬ
%   Value�˴���ʾ��ϸ˵��
if numel(node_id)~=numel(Value)
   output_args = 1;
   disp([mfilename,'node_id��Value������һ�£�']);
   keyboard
    return
end
num_node_needed_adjust = numel(node_id);
node_index_k1=libpointer('int32Ptr',0);
for k1 = 1:num_node_needed_adjust
     [code,node_id{k1,1},node_index_k1]=calllib(lib_name,'ENgetnodeindex',node_id{k1,1},node_index_k1);%ָ���ڵ�id��index
     if code >=100
         output_args = 1;
         disp([mfilename,'ENgetnodeindex����'])
         keyboard
         return
     end
     code = calllib(lib_name,'ENsetnodevalue',node_index_k1,keyCode,Value(k1));
     if code ~= 0
         output_args = 1;
         disp([mfilename,'ENgetnodeindex����'])
         keyboard
         return
     end
end
output_args = 0;
end

