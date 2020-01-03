%% 1.本函数的功能，为无需删除孤立节点时，调整水力模型数据格式。准备写入破坏管网水力模型inp 文件的数据
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；

%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]
%% 4.2 文件
% 无
%% 5.调用此程序（函数）的程序？
% [1]data_pipe
% [2]data_new_node
% [3]dataC1
% [4]net_data

%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [1]out
%% 6.2输出变量
% [1]t,double,t=0表示程序运行无错误
% [2]outdata,cell,管网水力模型数据
%% 6.3中间变量
% [1]num
% [2]num1
% [3]pipes
% [4]old_j
% [5]num3
% [6]old_r
% [7]old_t
% [8]old_d
% [9]old_e

%%
function [t,outdata]=ND_Out_no_delete(data_pipe,data_new_node,dataC1,net_data)
outdata{1}=data_pipe;%管道
if ~isempty(net_data{2,2})%
    outdata{2}=net_data{2,2};%原节点
else
    outdata{2}=[];
end
if ~isempty(data_new_node)%新节点
    outdata{3}=data_new_node;
else
    outdata{3}=[];
end
if ~isempty(net_data{3,2})%水源
    outdata{4}=net_data{3,2};
else
    outdata{4}=[];
end
if ~isempty(net_data{4,2})%水池
    outdata{5}=net_data{4,2};
else
    outdata{5}=[];
end
if ~isempty(net_data{15,2})%demand
    outdata{6}=net_data{15,2};
else
    outdata{6}=[];
end
if ~isempty(net_data{8,2})%emitters
    outdata{7}=net_data{8,2};
else
    outdata{7}=[];
end
outdata{8}=dataC1;
t=0;
end