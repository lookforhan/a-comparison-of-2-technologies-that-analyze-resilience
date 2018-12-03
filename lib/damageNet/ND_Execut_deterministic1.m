%% 1.本函数根据管线的管线破坏文件damage.txt，生成管网中每条管线的泄漏/断开点的如下属性信息:
%     1.管线是否破坏; 2. 管线破坏点在管长中的比例位置; 3.管线破坏点的类型（泄漏/断开）;

%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；

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
function [t,damage_pipe_info]=ND_Execut_deterministic1(net_data,damage_data)

Pipe_id_data=net_data{5,2}(:,1);
damage_num=numel(damage_data{1});
mid_M1=zeros(damage_num,1);
damage_pipe_id=deblank(damage_data{2});
damage_pipe_node=damage_data{3};
damage_pipe_length=damage_data{4};
damage_node_kind=damage_data{5};
damage_node_diameter=damage_data{6};
damage_node_area=(pi*damage_node_diameter.^2)/4;
damage_node_e=damage_node_area*1e-6*0.62*4427;
    n_h=0;
disp('ND_Execut_deterministic:产生破坏信息');
for i=1:damage_num
    mid_t=ismember(Pipe_id_data,damage_pipe_id{i});
    if ~any(mid_t)
        disp('errors==================');
        disp('ND_Execut_deterministic');
        disp('67行');
        disp('damage.txt中破坏管道编号与inp文件中不一致。');
        disp(damage_pipe_id{i});
        disp(num2str(i));
        t =1;
        damage_pipe_info=0;
        return
    end
    mid_M1(i)=find(mid_t);
    if damage_pipe_node(i)==1
        n_h=n_h+1;
    end
    n_l=damage_pipe_node(i);
    mid_D2(n_h,n_l)=damage_pipe_length(i);
    mid_D3(n_h,n_l)=damage_node_kind(i);
    mid_D4(n_h,n_l)=damage_node_e(i);
    
    mid_D5(n_h,n_l) = sqrt(damage_node_area(i)*4/pi);
    diameter=mid_D5(n_h,n_l)*0.001;
    mid_D6(n_h,n_l)=(damage_node_e(i)/((diameter)^2.435*(10.67^(-0.5))*1000))^(1/0.926);
end
% M1=unique(mid_M1,'stable');
[M1,ia]=unique(mid_M1);
damage_pipe_id_2=Pipe_id_data(M1);
damage_pipe_num=numel(M1);
mid2_D2=cumsum(mid_D2,2);
mid3_D2=1-mid2_D2(:,end);
D2=mid_D2;
for i=1:damage_pipe_num
    damage_pipe_node_num=sum(mid_D2(i,:)~=0,2);
    D2(i,damage_pipe_node_num+1)=mid3_D2(i);
end
D3=mid_D3;
D4=mid_D4;
D5=mid_D5;
D6 = mid_D6;
damage_pipe_info=[{M1},{D2(ia,:)},{D3(ia)},{D4(ia)},{damage_pipe_id_2},{D5(ia)},{D6(ia)}];
disp('ND_Execut_deterministic:结束');
t=0;
end
