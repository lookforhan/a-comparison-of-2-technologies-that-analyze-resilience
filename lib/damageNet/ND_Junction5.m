%% 1.本函数的功能为根据破坏信息及管网水力模型生成破坏节点的数据（编号、高程、坐标、需水量、扩散器系数）
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-8 21：43；调整选择结构,switch 代替if；
% 韩朝；2017-6-16 9：43；ismember代替findmatch；
% 韩朝；2018-6-25 9：43；修改泄露点的模拟方法（采用节点和虚拟水库）；
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
%% 4.2 文件
%% 5.调用此程序（函数）的程序？
% [1]Net_Damage.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% net_data,cell,Read_File函数读取的'input_net_filename'文件内容,第1列,数据名称(汉字); 第2列,对应数据内容cell,与net.inp文件相关;
% damage_pipe_info,元胞数组,存放4类行数相同的数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
%% 6.2输出变量
% t,double,t=0表示程序运行无错误
% damage_node_data,cell,存储管线中每个破坏点的属性信息,每个元素存储每个破坏点的属性信息结构体damage_node_character；
% 每个damage_node_character结构体包括破坏点的如下信息：'id',[],'x',[],'y',[],'Elve',[],'type',{},'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]；
%% 6.3中间变量
% [1]D2,double,破坏点在管线上的比例
% [2]D3,double,破坏点的扩散系数
% [3]D4,double,破坏点的类型
% [4]M1,double,破坏管线的位置
% [5]M2,double,D2行累加,
% [6]Elve_data,cell,节点高程
% [7]node_new_add,struct,存放新节点信息的结构体
% [8]num_1_pipe,double,管线破坏点个数,
% [9]rate,破坏点的长度比例
% [10]bro_pipe,double,破坏管线在的下标
% [11]N1,cell,破坏管线的起点
% [12]N2,cell,破坏管线的终点
% [13]N1_elve,double,破坏管线的起点的高程（水头）
% [14]N2_elve,double,破坏管线的终点的高程（水头）
% [15]N1_x,double,破坏管线的起点的x坐标
% [16]N1_y,double,破坏管线的起点的y坐标
% [17]N2_x,double,破坏管线的终点的x坐标
% [18]N2_y,double,破坏管线的终点的y坐标
%%
function [t,damage_node_data]=ND_Junction5(net_data,damage_pipe_info) 
%% 数据准备
M1=damage_pipe_info{1,1};%破坏管线编号的下标
D2=damage_pipe_info{1,2};
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
M2=cumsum(D2,2);%D2行累加,破坏点位置点管线长度的比例
D3=damage_pipe_info{1,3};
%D3管线破坏点破坏类型矩阵；第1列为第1个破坏点的类型：1渗漏/2断开；第2列为第2个破坏点的类型：1渗漏/2断开...；
 D4=damage_pipe_info{1,4};
%D4管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的泄漏扩散器系数，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
D5=damage_pipe_info{1,6};
%D5管线泄漏点的泄露面积等效直径：第1列为第1个破坏点的泄漏面积，若此点为断开点，则此值为0；按照漏水量LPS单位计算；
D6=damage_pipe_info{1,7};
%D5管线泄漏点的泄露面积等效直径：第1列为第1个破坏点的泄漏面积，若此点为断开点，则此值为0；按照漏水量LPS单位计算；
 if isempty(net_data{4,2})
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2)]]; %管网中所有节点（用户节点，水厂节点，水池节点）的：1编号，2高程；水厂节点高程用的总水头！！！！
 else
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1);net_data{4,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2);net_data{4,2}(:,2)]]; %管网中所有节点（用户节点，水厂节点，水池节点）的：1编号，2高程；水厂节点高程用的总水头！！！！
 end

pipe_data=net_data{5,2};%管线编号,起点编号,终点编号,长度(m),直径(mm),摩阻系数,局部损失系数
coordinate_data=net_data{23,2};%节点编号，x坐标，y坐标
%% 变量预定义
damage_node_character=struct('id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[],'Diameter',[],'Roughness',[]);%存放新节点信息的结构体
[n1,n2]=size(D2);%n1管网中破坏管线的数量；n2管线的实际破坏点的数量最大值；
pipe_damage_num=zeros(n1,1); %在每条管线上产生破坏点的数量；
damage_node_data=cell(n1,n2-1); %存储管线中每个破坏点的属性信息,每个元素存储每个破坏点的属性信息结构体damage_node_character；
%% 对所有含破坏点的管线，产生破坏点；
for i=1:n1 %破坏管线的数量
    damage_pipe_loc=M1(i); %破坏管线在管网中所有管线数据矩阵的行位置号，非破坏管线的编号（字符型）；
    pipe_damage_num(i)=sum(D2(i,:)>0)-1;
    %% 初始管线属性信息准备
    %管线起止点编号
    N1=pipe_data{damage_pipe_loc,2};%管线起点编号
    N2=pipe_data{damage_pipe_loc,3};%管线终点编号
    %管线起止点高程
    N1_elve=Elve_data{ismember(Elve_data(:,1),N1),2};%N1高程
    N2_elve=Elve_data{ismember(Elve_data(:,1),N2),2};%N2高程
    %管线起止点的坐标
    num_id1=ismember(coordinate_data(:,1),N1);%N1在节点坐标数据矩阵中的行号位置
    num_id2=ismember(coordinate_data(:,1),N2);%N2在节点坐标数据矩阵中的行号位置
    N1_x=coordinate_data{num_id1,2};%破坏管线的起点的x坐标
    N1_y=coordinate_data{num_id1,3};%破坏管线的起点的y坐标
    N2_x=coordinate_data{num_id2,2};%破坏管线的终点的x坐标
    N2_y=coordinate_data{num_id2,3};%破坏管线的终点的y坐标
    for j=1:pipe_damage_num(i) %在第i个破坏管线上创建第j个破坏点     
        %% 管线中的破坏点属性赋值
        %管线破坏点高程
        L_ratio=M2(i,j);%破坏点距管线起点长度与管线长度的比例
        damage_node_character(1).Elve=((1-L_ratio)*N1_elve+L_ratio*N2_elve);%破坏点高程
        %管线破坏点的坐标
        damage_node_character(1).x=(1-L_ratio)*N1_x+L_ratio*N2_x;%破坏点的x坐标
        damage_node_character(1).y=(1-L_ratio)*N1_y+L_ratio*N2_y;%破坏点的y坐标
        damage_node_character(1).order=j;%破坏点的秩（第几个）
        damage_node_character(1).length=D2(i,j);%破坏点的长度比例
        damage_node_character(1).Coefficient=D4(i,j);%破坏点的扩散系数
        damage_node_character(1).Diameter=D5(i,j);%破坏点的直径
        damage_node_character(1).Roughness=D6(i,j);%破坏点的直径
        damage_node_character(1).pipe=pipe_data{damage_pipe_loc,1};%破坏点的所在管线编号
        damage_node_character(1).pipe_index=damage_pipe_loc;%破坏点的所在管线的位置编号
        damage_node_character(1).id=['add_node-',damage_pipe_info{1,5}{i,1},'-',num2str(j)];%破坏点新增编号
        if D3(i,j)==1
            damage_node_character(1).type=1;%破坏点类型为渗漏
        else
            damage_node_character(1).type=2;%破坏点类型为断开
        end
        %% 单个破坏点属性存储
        damage_node_data{i,j}=damage_node_character(1);%将破坏点的属性信息放入元胞数组中；
    end
end
t=0;
end
