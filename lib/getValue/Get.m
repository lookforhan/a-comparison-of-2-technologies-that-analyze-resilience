
%% 1.程序（函数）的功能，依据的原理，参考文献；
%% 2.编程思路，程序特点；
%% 3.程序编写人；修改时间：更新内容；
% 韩朝；2017-5-13 19：43；增加文件头部说明；
% 韩朝；2017-6-2 9：43；增加文件头部说明中中间变量说明；输出报告文件名
% 韩朝；2017-6-5 9：43；取代所有全局变量，输入参数由文件读入；
% 韩朝；2017-6-6 9：43；每行增加注释；
% 韩朝；2017-6-6 21：43；删除PDD_main.m、PDD_Set.m、PDD_hydraulic.m函数，原函数功能转移至主程序；
%% 4.正常运行需要调用的其他自编（自定义）程序（函数）或文件
%% 4.1 程序
% [1]epanet2.dll
% [2]epanet2.h

%% 4.2 文件

%% 5.调用此程序（函数）的程序？
% [1]main_s.m
%% 6.变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
%% 6.1输入变量
% [1]junction_num,double,用户节点数目
% [2]n,double,ENgetnodevalue节点相关属性参数
%% 6.2输出变量
% [1]t,double,t=0表示程序运行无错误
% [2]value1,double,节点相关属性
%% 6.3中间变量
% [1]value,lib.pointer,中间变量
function [t,value1]=Get(junction_num,n)
value=libpointer('singlePtr',0);%指针参数--值
value1=zeros(junction_num,1);
    for i=1:junction_num
        [~,value]=calllib('epanet2','ENgetnodevalue',i,n,value);%11代表水压
        value1(i,1)=double(value);        
    end
    t=0;
end