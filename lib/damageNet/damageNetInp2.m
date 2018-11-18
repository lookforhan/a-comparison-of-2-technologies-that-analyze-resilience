function  [t_W,pipe_relative]=damageNetInp2(net_data,damage_pipe_info,EPA_format,output_net_filename)
%damageNetInp2 生成破坏后管网管网
%   该函数需调用Read_File_dll_inp4.m；epanet2.dll；epanet2.h；EPA_F.mat等文件
%   输入：[1]net_data-管网数据
%   输入：[2]damage_pipe_info-破坏信息
%   输入：[3]EPA_format-输出文件格式
%   输入：[4]output_net_filename-输出文件地址
%   输出：[1]inp文件
%   输出：[2]pipe_relative-新增管道与原管道联系
%%
[t_j,damage_node_data]=ND_Junction5(net_data,damage_pipe_info);%生成管线中的破坏点数据
[t_p,pipe_new_add,pipe_relative]=ND_Pipe5(damage_node_data,damage_pipe_info,net_data{5,2});%生成管线破坏点的邻接管段数据
[t,all_add_node_data,pipe_new_add]=ND_P_Leak4(damage_node_data,damage_pipe_info,pipe_new_add);
pipe_data=net_data{5,2}; %cell,初始管网中管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
%     pipe_data(damage_pipe_info{1,1},:)=[]; %删除破坏管线的原始管线信息,damage_pipe_info{1,1}是破坏管线在原始管线属性矩阵中的行位置号(向量)；
for i = 1:numel(pipe_data(:,1))
    if ismember(i,damage_pipe_info{1,1})
        pipe_data{i,8}='Closed;';
    end
end
mid_data=(struct2cell(pipe_new_add))';
all_pipe_data=[pipe_data;mid_data];%cell,初始管网中管线+破坏管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)]; %所有节点坐标（包括水源、水池、用户节点）；
[~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
t_W=Write_Inpfile5(net_data,EPA_format,outdata,output_net_filename);% 写入新管网inp
end
