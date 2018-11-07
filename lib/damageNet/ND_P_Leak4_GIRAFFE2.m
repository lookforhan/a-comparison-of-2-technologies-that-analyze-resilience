%% 本函数用来设置破坏点的管网水力模型参数。具体功能有2：
% 1.将破坏点的属性信息damage_node_data，从二维元胞数据转化为一维元胞数组damage_node_data_solo，其中每个数组元素为1个结构体;
% 2.判别管线破坏点类型（渗漏/断开）,若为断开点则增加1个破坏点,将破坏点设置为虚拟水池；并改变断开点邻接管段的节点信息；
% 3.将破坏点的结构体属性信息转换为元胞数组，数据组的每个元素为1个属性类别；
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2018-6-25 9：43；修改模拟泄露破坏点的模拟方式。
% 韩朝；2018-6-25 9：43；修改模拟断开破坏点的模拟方式。
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]
%% 4.2 文件
% 无
%% 5.调用此程序（函数）的程序？
% [1]
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% damage_node_data,cell,存储管线中每个破坏点的属性信息,每个元素存储每个破坏点的属性信息结构体damage_node_character；
% 每个damage_node_character结构体包括破坏点的如下信息：'id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]；
% damage_pipe_info,元胞数组,存放4类行数相同的数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
% pipe_new_add，结构体矩阵，行数为所有新增的破坏管段数，存放每1段新增破坏管段属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
%% 6.2输出变量
% t,double,t=0表示程序运行无错误
% all_add_node_data，元胞数组，包含所有破坏点的属性信息，所有破坏点=管线破坏点+断开点新增的另1破坏点；属性信息包含：：id(字符串),x,y,Elve(m),type(渗漏1/断开2),pipe(所在管线编号字符串),pipe_index(所在管线位置号),order(所在管线的第几个破坏点),length(相邻破坏点间管段长度比例),Coefficient(如为渗漏点其对应的扩散器系数,转换为LPS流量单位)；
% pipe_new_add，已更新断开点的邻接管段的节点号，存放每1段新增破坏管段属性信息结构体矩阵，行数为所有新增的破坏管段数，第列数据为：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
%% 6.3中间变量
% [1]D2,double,破坏点在管线上的比例
% [2]M1,double,破坏管线的位置
% [3]n,double,计数
% [4]BRO_PIPEMUN,double,破坏管线
% [5]data5,cell,
% [6]c,cell,
% [7]c1,cell,
%%
function [t,all_add_node_data,pipe_new_add_new]=ND_P_Leak4_GIRAFFE2(damage_node_data,damage_pipe_info,pipe_new_add)
% pipe_relative_2 = pipe_relative;
M1=damage_pipe_info{1,1}; %破坏管线的位置号(向量)
D2=damage_pipe_info{1,2};
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
D3=damage_pipe_info{1,3};
%D3管线破坏点破坏类型矩阵；第1列为第1个破坏点的类型：1渗漏/2断开；第2列为第2个破坏点的类型：1渗漏/2断开...；
n1=numel(M1);%n1管网中破坏管线的数量；
% D5=damage_pipe_info{1,6};
D6=damage_pipe_info{1,7};
pipe_new_add_2=struct('id',[],'N1',[],'N2',[],'Length',0.15,'Diameter',[],'Roughness',[],'MinorLoss',0,'Statues','CV');
%% 将破坏点的属性信息damage_node_data，从二维元胞数据转化为一维元胞数组damage_node_data_solo;
damage_node_num=sum(sum(D2>0))-n1;%全部管线中全部破坏点的数量（不含断开点增加的另1节点）；
damage_node_data_solo=cell(damage_node_num,1); %存储破坏点属性信息结构体的元胞数据向量，每个元素为该破坏点的属性信息结构体；
damage_node_count=0; %破坏点计数器；
for i=1:n1
    pipe_damage_num=sum(D2(i,:)>0)-1; %在每条管线上破坏点的数量；
    for j=1:pipe_damage_num
        damage_node_count=damage_node_count+1;
        damage_node_data_solo{damage_node_count,1}=damage_node_data{i,j};
    end
end
%% 判别破坏节点的类型，若为断开需增加新的破坏点，若为渗漏则不必处理；
break_node_num=sum(sum(D3==2)); %全部管线中断开破坏点的数量（需要增加的另1节点的数量）；
leak_node_num=sum(sum(D3==1));
break_node_data=cell(break_node_num,1); %存储断开破坏点新增另1节点的属性信息结构体的元胞数据向量，每个元素为该新增节点的属性信息结构体；
leak_node_data=cell(leak_node_num,1);
n2=0; %为断开点新增的破坏点计数器；
n3=0; %为泄露点新增的破坏点计数器；
for i=1:length(damage_node_data_solo) %所有破坏点循环；
    if damage_node_data_solo{i}.type==2 %发现断开节点
        n2=n2+1;%增加破坏节点计数；
        break_node_data{n2,1}=damage_node_data_solo{i};%新生成一个节点
        break_node_data{n2,1}.id=[damage_node_data_solo{i}.id,'-',num2str(2)];
        %         m2_ID{1,j} = break_node_data{n2,1}.id;
        %         pipe_relative_2{i,2} = [pipe_relative{i,2},m2_ID];
        for j=1:length(pipe_new_add) %对所有增加的管段循环，查找哪个新增管段的起点为此节点；
            if strncmp(pipe_new_add(j).N2,damage_node_data_solo{i}.id,255)
                pipe_new_add(j).Statues ='';
            end
            if strncmp(pipe_new_add(j).N1,damage_node_data_solo{i}.id,255)
                temp = pipe_new_add(j).N2;
                pipe_new_add(j).N2=break_node_data{n2,1}.id;
                pipe_new_add(j).N1 = temp;
                pipe_new_add(j).Statues ='';
            end            
        end
        %增加管道和水源点
    else % 渗漏破坏
        n3 = n3+1;
        damage_node_data_solo{i}.Coefficient =0;
        leak_node_data{n3,1}=damage_node_data_solo{i};
        leak_node_data{n3,1}.type = 'Reservoir';%类型改为水源点
        leak_node_data{n3,1}.id = [damage_node_data_solo{i}.id,'-R'];%类型改为水源点
        pipe_new_add_2(n3,1).id = [damage_node_data_solo{i}.id,'-pipe'];%新加管道id
        pipe_new_add_2(n3,1).N1 =damage_node_data_solo{i}.id;
        pipe_new_add_2(n3,1).N2 =leak_node_data{n3,1}.id;
        pipe_new_add_2(n3,1).Diameter = damage_node_data_solo{i}.Diameter;
        pipe_new_add_2(n3,1).Length=0.1524;%管道长度为1m
        pipe_new_add_2(n3,1).Roughness=1e6;
        pipe_new_add_2(n3,1).MinorLoss=2.7778;
        pipe_new_add_2(n3,1).Statues='CV';
        
    end
end
if (break_node_num~=n2) || (leak_node_num~=n3)
    keyboard
end 
%% 将破坏点的结构体属性信息转换为元胞数组；将破坏点的属性信息（上部）与断开点增加的另1破坏点属性信息（下部）合并[上部；下部]；
if isempty(damage_node_data_solo)
    keyboard
end
mid_data=(struct2cell(damage_node_data_solo{1}))'; %数据转换的中间变量；
% n4=numel(mid_data); %破坏节点属性信息结构体中属性的个数；
all_add_node_data=cell(damage_node_num+break_node_num+n3,numel(mid_data));
%----------------------------------------------------------
%结构体数据中间转换
for i=1:damage_node_num
    mid_data1(i)=damage_node_data_solo{i};
end
mid_data2=struct2cell(mid_data1);
mid_data3=reshape(mid_data2,[numel(mid_data),damage_node_num]);
%-----------------------------------------------------------
all_add_node_data(1:damage_node_num,:)=mid_data3';
%----------------------------------------------------------
%结构体数据中间转换
if break_node_num~=0
    for i=1:break_node_num
        mid_data111(i)=break_node_data{i};
    end
    mid_data2=struct2cell(mid_data111);
    mid_data3=reshape(mid_data2,[numel(mid_data),break_node_num]);
    %-----------------------------------------------------------
    all_add_node_data(damage_node_num+1:damage_node_num+break_node_num,:)=mid_data3';
end
if leak_node_num~=0
    for i_n3 =1:leak_node_num
        mid_data1111(i_n3)=leak_node_data{i_n3};
    end
    mid_data2=struct2cell(mid_data1111);
    mid_data3=reshape(mid_data2,[numel(mid_data),leak_node_num]);
    all_add_node_data(damage_node_num+break_node_num+1:end,:)=mid_data3';
end
pipe_new_add_new = [pipe_new_add;pipe_new_add_2];
t=0;
end