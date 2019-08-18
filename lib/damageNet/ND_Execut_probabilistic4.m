%% 1.本函数根据管线的经验震害率、管长，生成管网中每条管线的泄漏/断开点的如下属性信息:
%     1.管线是否破坏; 2. 管线破坏点在管长中的比例位置; 3.管线破坏点的类型（泄漏/断开）;
%     4.如果破坏点为泄漏点时,泄漏点的扩散器系数,扩散器系数计算见文献[1]。
%     5.根据管线管材不同生成不同泄漏类型，不同泄漏类型的泄漏面积计算公式不同[2].
%[1] 侯本伟，杜修力. 地震破坏管线漏损分析模型对比研究[J]. 地震工程与工程振动.2013(05):67-75.
%[2] GIRAFFE USER'S MANUAL4.2
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-6 21：43；删除PDD_main.m、PDD_Set.m、PDD_hydraulic.m、User_Number.m、PcR.m函数，原函数功能转移至主程序；
% 韩朝；2017-07-26 14:49:30；将72行文件名改为变量parameter_pro_of_leak_area_filename由函数传递；
% 韩朝；2018-06-25 14:49:30；增加等效直径；
% 韩朝；2019-08-18 14:51:54；将输出参数改为table类型，方便理解每列数据的含义。
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
%% 4.2 文件
%% 5.调用此程序（函数）的程序？
% Net_Damage.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% input_RR_filename, 字符串，管线的经验震害率数据文件名;
% net_data,cell,Read_File函数读取'input_net_filename'文件内容,第1列,数据名称(汉字); 第2列,对应数据内容cell,与net.inp文件相关;
% pipe_break_rate,管线破坏点中断开点所占的比例;
% pipe_damage_num_max,每条管线可能产生的破坏点数量最大值;
% C,漏水点单位转换系数;
% mu,孔口流量系数;
% AL_para,漏口面积系数;
% n_seed,模拟随机漏点的随机数限值。
%% 6.2输出变量
% t,double,t=0表示程序运行无错误
% damage_pipe_info,元胞数组,存放4类数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
%% 6.3中间变量
% [1]input_RR_name，字符串，RR文件存贮路径，文件parametric.txt读入
% [2]C ，double，单位转换系数，文件parametric.txt读入
% [3]mu ，double，孔口流量系数，文件parametric.txt读入
% [4]AL1 ，double，孔口面积系数，文件parametric.txt读入
% [5]n_seed，double ，控制随机数生成的种子，文件parametric.txt读入
% [6]D1 ，%生成管道破坏向量，0代表无破坏，1代表该管道破坏
% [7]D2 ，%破坏位置矩阵；每一行，第一列为第一个破坏点距起始点的长度与管线总长的比例；
%                                              第二列为第二个破坏点距第一个破坏点的长度与管线总长的比例...
% [8]D3 ，%破坏类型矩阵；每一行，第一列为第一个破坏点的类型：1渗漏/2断开；
%                                              第二列为第二个破坏点的类型：1渗漏/2断开；...
% [9]D4 ，%扩散器系数系数型矩阵
% [10] M1 ，D1非零行
% [11]pipe_break_rate,断开与渗漏和比例
% [12]AL,double,管线渗漏截面积（m2）
% [13]RR_data,cell,修复率数据,
% [14]pipe_damage_num_max,double,管线最大破坏个数
% [15]d,double,管线直径（m）
% [16]cross_area,double,管线截面积（m2）
% [17]mu1,随机数
% [18]L1,破坏长度（m）
%%
function [t,output]=ND_Execut_probabilistic4(net_pipe_id,damage_data,pipe_damage_num_max,C,mu)
pipe_damage_data = damage_data;
% pipe_num = numel(net_pipe_id);% 管道数量
damage_num=numel(pipe_damage_data{1}); %破坏点的数量；
damage_pipe_id=deblank(pipe_damage_data{2}); %破坏所在管线编号；
damage_pipe_num=numel(unique(damage_pipe_id));%含有破坏点的管道数量；
damage_pipe_node=pipe_damage_data{3}; %破坏点在该管线上的破坏次序；
damage_pipe_length=pipe_damage_data{4}; %破坏点与点之间的长度比例；
damage_node_kind=pipe_damage_data{5}; %破坏点的类型；
damage_node_diameter=pipe_damage_data{6}; %破坏点的等效直径
damage_node_area=(pi*damage_node_diameter.^2)/4;%开口面积；
damage_node_e=damage_node_area*C*mu; %破坏点的扩散器系数；

% D1=zeros(pipe_num,1); %管线是否存在破坏的判别矩阵：0无破坏; 1有破坏;
D1=cell(damage_pipe_num,1);%每个破坏管道的ID号；
D2=zeros(damage_pipe_num,pipe_damage_num_max);
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
D3=zeros(damage_pipe_num,pipe_damage_num_max);
%D3管线破坏点破坏类型矩阵；第1列为第1个破坏点的类型：1渗漏/2断开；第2列为第2个破坏点的类型：1渗漏/2断开...；
D4=zeros(damage_pipe_num,pipe_damage_num_max);
%D4管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的泄漏扩散器系数，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
D5=zeros(damage_pipe_num,pipe_damage_num_max);
%D5管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的泄漏扩散等效直径，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
D6=zeros(damage_pipe_num,pipe_damage_num_max);
%D6管线泄漏点的扩散器系数矩阵：第1列为第1个破坏点的粗糙度系数，若此点为断开点，则此例值为0；扩散器系数按照漏水量LPS单位计算；
%-------------
% 输入参数一致性检查
pipe_test = ismember(damage_pipe_id,net_pipe_id);%检查破坏文件与管网文件是否信息一致
    if ~all(pipe_test)
        disp('errors==================');
        disp(mfilename)
        disp('damage.txt中破坏管道编号与inp文件中不一致。');
        t = 1;
        output = l;
        return
    end
%--------------
n_h = 0;%含有破坏点的管道计数；
for i = 1:damage_num
%     pipe_loc = ismember(net_pipe_id,damage_pipe_id{i});
    if damage_pipe_node(i) == 1 %破坏次序
        n_h = n_h + 1;
        D1(n_h) = damage_pipe_id(i);
    end
    n_l=damage_pipe_node(i);
    D2(n_h,n_l)=damage_pipe_length(i);
    D3(n_h,n_l)=damage_node_kind(i);
    D4(n_h,n_l)=damage_node_e(i);
    D5(n_h,n_l)=damage_node_diameter(i);
    diameter = damage_node_diameter(i)*0.001;%单位转换
    D6(n_h,n_l) = (damage_node_e(i)/((diameter)^2.435*(10.67^(-0.5))*1000))^(1/0.926);% 粗糙度系数
%     D6(n_h,n_l)=D4(i,j)/(((D5(i,j)*0.001)^2.63)*(10.67)^(-0.54)*1000);%粗糙度系数
end
%-------------
%-------------

[~,M1]=ismember(D1,net_pipe_id);%每个破坏管道ID号在所有管线中的排序号；
mid_D2=1-sum(D2,2);
for i=1:damage_pipe_num
    damage_pipe_node_num=sum(D2(i,:)~=0,2);
    D2(i,damage_pipe_node_num+1)=mid_D2(i); %破坏管道所在行的最后1个非零数值为最1个破坏点距管道终点的长度比例。
end
pipe_damage_node_num=sum(sum(D2)>0); %sum(D2)为1*pipe_damage_num_max，为了判别管线的实际破坏点的数量最大值；
% pipe_id = net_pipe_id(M1);
% damage_pipe_info=[{M1},{D2(M1,1:pipe_damage_num)},{D3(M1,1:pipe_damage_num)},{D4(M1,1:pipe_damage_num)},{pipe_id},{D5(M1,1:pipe_damage_num)},{D6(M1,1:pipe_damage_num)}];
%damage_pipe_info,元胞数组,存放4类数据：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵);
%damage_pipe_info采用元胞数组存储，是为了方便调用D2~D4中每列的数据，这样不必计算每列的具体列号；
t=0;
damage_pipe_info.Pipe_loc = M1;
damage_pipe_info.Interval_Length = D2(:,1:pipe_damage_node_num);
damage_pipe_info.Damage_Type = D3(:,1:pipe_damage_node_num-1);
damage_pipe_info.Emitter_Coeff = D4(:,1:pipe_damage_node_num-1);
damage_pipe_info.Pipe_ID = D1;% pipe_id
damage_pipe_info.Pipe_Diameter = D5(:,1:pipe_damage_node_num-1);
damage_pipe_info.Pipe_Roughness = D6(:,1:pipe_damage_node_num-1);
damage_pipe_info_table = struct2table(damage_pipe_info);
% 将计算结果改为table格式的变量，方便说明每列变量的含义。
output = damage_pipe_info_table;
end