function [ output_args ] = Set_chosen_node_value_EPANETx64PDD(lib_name,node_id,keyCode,Value)
%Set_chosen_node_value_EPANETx64PDD 设置指定节点的值
%   lib_name,动态链接库的名称
%   node_id，指定节点的id
%   kyeCode，需要设置的节点的值的类型，与动态链接库设置相同
%   Value此处显示详细说明
if numel(node_id)~=numel(Value)
   output_args = 1;
   disp([mfilename,'node_id与Value数量不一致！']);
   keyboard
    return
end
num_node_needed_adjust = numel(node_id);
node_index_k1=libpointer('int32Ptr',0);
for k1 = 1:num_node_needed_adjust
     [code,node_id{k1,1},node_index_k1]=calllib(lib_name,'ENgetnodeindex',node_id{k1,1},node_index_k1);%指定节点id的index
     if code >=100
         output_args = 1;
         disp([mfilename,'ENgetnodeindex出错！'])
         keyboard
         return
     end
     code = calllib(lib_name,'ENsetnodevalue',node_index_k1,keyCode,Value(k1));
     if code ~= 0
         output_args = 1;
         disp([mfilename,'ENgetnodeindex出错！'])
         keyboard
         return
     end
end
output_args = 0;
end

