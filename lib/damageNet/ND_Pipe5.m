%% 本函数根据管线破坏点属性信息，生成破坏管段信息（编号、起始点编号、终止点编号 长度、直径、粗糙系数）
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-6 21：43；删除PDD_main.m、PDD_Set.m、PDD_hydraulic.m、User_Number.m、PcR.m函数，原函数功能转移至主程序；
% 韩朝；2017-07-26 10:56:01；为适应main12.m修改36行pipe_new_add结构，原八属性改为七属性。原第八属性为管线状态;
% 韩朝；2018-06-25 10:56:01；修改泄露破坏点的模拟方法;

%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]Net_Damage.m

%% 4.2 文件

%% 5.调用此程序（函数）的程序？
% [1]Net_Damage
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% damage_node_data,cell,存储管线中每个破坏点的属性信息,每个元素存储每个破坏点的属性信息结构体damage_node_character；
%   每个damage_node_character结构体包括破坏点的如下信息：'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]；
% damage_pipe_info,元胞数组,存放4类行数相同的数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
% pipe_data,cell,初始管网中管线的属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数;
%% 6.2输出变量
% t,double,t=0表示程序运行无错误
% pipe_new_add，结构体，存放每1段新增破坏管段属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
%% 6.3中间变量
% [2]pipe_new_add,struct,存放新管道信息的结构体
% [3]D2,double,破坏点在管线上的比例
% [4]M1,double,破坏管线的位置
% [8]add_pipe_count，double,%新增加的管段计数器；
% [9]damage_pipe_loc,%破坏点的所在管线在管网中所有管线信息矩阵中的行位置编号
% [10]pipe_damage_num,double,管线上破坏点个数
%%
function [t,pipe_new_add,pipe_relative]=ND_Pipe5(damage_node_data,damage_pipe_info,pipe_data)

pipe_new_add=struct('id',[],'N1',[],'N2',[],'Length',[],'Diameter',[],'Roughness',[],'MinorLoss',[],'Statues','Open'); 
%pipe_new_add结构体，存放每1段新增破坏管段属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
M1=damage_pipe_info{1,1};%破坏管线的位置号(向量)
m1_ID = pipe_data(M1,1);
D2=damage_pipe_info{1,2};
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
n1=numel(M1);%n1管网中破坏管线的数量；
if isempty(damage_node_data)
    t =0;
    pipe_new_add = [];
    pipe_relative = pipe_data(M1,1);
    return
end
%% 在每条破坏管线上建立破坏管段属性信息；
pipe_damage_num=zeros(n1,1); %在每条管线上应该分割成的管段数量；
add_pipe_count=0; %新增加的管段计数器；
m3_ID=cell(n1,1);
for i=1:n1 %对破坏的管道添加新管段
    damage_pipe_loc=M1(i);%破坏点的所在管线在管网中所有管线信息矩阵中的行位置编号
    pipe_damage_num(i)=sum(D2(i,:)>0); %在每条管线上应该分割成的管段数量；
    for j=1:pipe_damage_num(i) %在每条管线上应该分割成的管段数循环；
        add_pipe_count=add_pipe_count+1;
        pipe_new_add(add_pipe_count,1).id=['addP-',damage_pipe_info{1,5}{i,1},'-',num2str(j)];%新生成的管段编号
        m2_ID{1,j}=pipe_new_add(add_pipe_count,1).id;
        m3_ID{i,1} =m2_ID;
        switch j
            case 1 %第1个管线连接原管线起点
                pipe_new_add(add_pipe_count,1).N1=pipe_data{damage_pipe_loc,2};
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
            case pipe_damage_num(i) %最后管线连接原管线终点
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=pipe_data{damage_pipe_loc,3};
            otherwise %其他情况
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
        end
        pipe_new_add(add_pipe_count,1).Length=pipe_data{damage_pipe_loc,4}*D2(i,j);%管线的长度（m）
        pipe_new_add(add_pipe_count,1).Diameter=pipe_data{damage_pipe_loc,5};%管线的直径（mm）
        pipe_new_add(add_pipe_count,1).Roughness=pipe_data{damage_pipe_loc,6};%管线的粗糙系数
        pipe_new_add(add_pipe_count,1).MinorLoss=pipe_data{damage_pipe_loc,7};%管线的局部损失系数  
    end
    clear m2_ID
end

pipe_relative = [m1_ID,m3_ID];
t=0;
end