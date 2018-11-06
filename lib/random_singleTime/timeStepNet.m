%% 2017-12-15
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 功能：根据每个时间步管道状态向量生成破坏管网水力模型
%% 输入
% PipeStatus_timeStep ，(nB,1)管道状态向量
% damage_pipe_info_after，管道破坏信息。
% net_data,供水管网数据
%% 输出
% t
% outdata 水力模型文件
function [outdata]=timeStepNet(PipeStatus_timeStep,damage_pipe_info,net_data)
% 初始化数据


% 开始计算
[damage_pipe_info_after,close_pipe_info]=timeStepdamage(PipeStatus_timeStep,damage_pipe_info);% 根据管道状态矩阵生成每个状态的管道破坏信息
if isempty(damage_pipe_info_after{1})
%     disp('没有破坏')
    pipe_new_add=[];
    all_add_node_data=[];
    %     outdata=[];
else
    %% 生成破坏后管网信息
    [t_j,damage_node_data]=ND_Junction4(net_data,damage_pipe_info_after);%生成管线中的破坏点数据
    % t_j,double,t=0表示程序运行无错误
    % damage_node_data,cell,存储管线中每个破坏点的属性信息,每个元素存储每个破坏点的属性信息结构体damage_node_character；
    % 每个damage_node_character结构体包括破坏点的如下信息：'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]；
    if t_j==0
%         disp('ND_Junctions完成！')
    else
%         disp('ND_Junctions出错！')
        return
    end
    [t_p,pipe_new_add]=ND_Pipe4(damage_node_data,damage_pipe_info_after,net_data{5,2});%生成管线破坏点的邻接管段数据
    % pipe_new_add，结构体，行数为所有新增的破坏管段数，存放每1段新增破坏管段属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
    if t_p==0
%         disp('ND_Pipes完成！')
    else
%         disp('ND_Pipes出错！')
        return
    end
    %% 对于断开破坏点，新增另1节点，并改变其邻接管段的起始节点；
    [t,all_add_node_data,pipe_new_add]=ND_P_Leak3(damage_node_data,damage_pipe_info_after,pipe_new_add);
    % t,double,t=0表示程序运行无错误
    % all_add_node_data，元胞数组，包含所有破坏点的属性信息，所有破坏点=管线破坏点+断开点新增的另1破坏点；属性信息包含：id(字符串),x,y,Elve(m),type(渗漏1/断开2),pipe(所在管线编号字符串),pipe_index(所在管线位置号),order(所在管线的第几个破坏点),length(相邻破坏点间管段长度比例),Coefficient(如为渗漏点其对应的扩散器系数,转换为LPS流量单位)；
    % pipe_new_add，已更新断开点的邻接管段的节点号，存放每1段新增破坏管段属性信息结构体矩阵，行数为所有新增的破坏管段数，第列数据为：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
    % 附加说明：1. damage_node_data，元胞矩阵，每行表示破坏点所在管线位置号，每列为该管线中每个破坏点的所有属性信息结构体；
    %           2. all_add_node_data，元胞矩阵，每行为每个破坏点的编号，每列为该破坏节点的某个属性信息；
    if t==0
%         disp('ND_P_Leak成功！')
    else
%         disp('ND_P_Leak失败！')
    end
end
%% 合并所有管线信息
%删除破坏管线的原始管线信息；
pipe_data=net_data{5,2}; %cell,初始管网中管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
pipe_data(close_pipe_info,:)=[]; %删除破坏管线的原始管线信息,damage_pipe_info_after{1,1}是破坏管线在原始管线属性矩阵中的行位置号(向量)；
if isempty(pipe_new_add)
    mid_data=[];
else
    mid_data=(struct2cell(pipe_new_add))';
end
pipe_data(:,8) =[];
all_pipe_data=[pipe_data;mid_data];%cell,初始管网中管线+破坏管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
%% 破坏后管网拓扑结构连通性检查，判断并删除孤立点
dataP=all_pipe_data(:,1:3); %管线信息,cell,管线编号,起点编号,止点编号；
dataR=net_data{3,2}(:,1); %水源编号；
if isempty(all_add_node_data)
    dataC=net_data{23,2}(:,1);
    all_node_coordinate=net_data{23,2};
else
    dataC=[net_data{23,2}(:,1);all_add_node_data(:,1)]; %所有节点编号（包括水源、水池、用户节点）；
    all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)]; %所有节点坐标（包括水源、水池、用户节点）；!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end
if ~isempty(net_data{4,2}) %水池节点编号
    dataT=net_data{4,2}(:,1);
else
    dataT=[];
end
[isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(dataP,dataR,dataC,dataT);%检查破坏后管网拓扑结构是否全连通；
% isolated_node_num,double,孤立节点的数量；Nid,double,孤立节点的编号；Nloc,double,孤立节点的位置号；Pid,double,孤立管线的编号；Ploc,double,孤立管线的位置号；

if isolated_node_num==0
%     disp('破损管网连通性检查完成,不存在孤立节点！')
    [~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
else
%     disp(['破损管网连通性检查完成，存在', num2str(isolated_node_num),'个孤立节点，孤立节点及其邻接管段已删除！'])
    [~,outdata]=ND_Out_delete4(Nid,Nloc,Ploc,all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
end



end