%% 大修改：29-Jan-2018;hanzhao;将检查和修复次序合并。不再区分 
% =================================================================
% 增加输入对应个体的适应度值，
% 增加输出如果没有改变个体的的适应度值
% 2018-1-1,韩朝：修改函数名，增加管道检查部分的的交叉
% 上一个版本区别是输入参数pop个体中只有管道修复次序。
% 而本版本的输入参数pop个体的前一半是管道检查次序，后一半世管道修复次序。
% 如果交叉点在前一半，则检查次序交叉，修复次序不变
% 如果交叉点在后一半，怎检查次序不变，修复次序交叉
% 如果交叉点在中间，则交换修复次序。
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%遗传算法子程序
% 交叉(crossover)，群体中的每个个体之间都以一定的概率 pc 交叉，即两个个体从各自字符串的某一位置
% （一般是随机确定）开始互相交换，这类似生物进化过程中的基因分裂与重组。例如，假设2个父代个体x1，x2为：
% 这样2个子代个体就分别具有了2个父代个体的某些特征。利用交又我们有可能由父代个体在子代组合成具有更高适合度的个体。
% 事实上交又是遗传算法区别于其它传统优化方法的主要特点之一。
%遗传算法子程序
%Name: crossover5.m
%交叉
%{
pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
pc=0.5
[newpop]=crossover2(pop,pc)
%}
function [newpop,record]=crossover5(pop,pc)
popsize=numel(pop);%种群大小
record=zeros(popsize,1);%记录个体交叉为1，不交叉为0
newpop=pop;
gen_length=numel(pop{1});%个体长度
if mod(popsize,2)==0
    loop_n=popsize;
else
    loop_n=popsize-1;
end
r=rand(loop_n,1);
for i=1:2:loop_n
    if r(i)<pc%小于交叉概率则交叉，
        record(i)=1;
        record(i+1)=1;
        parent_1=pop{i};%组合的第一个个体
        parent_2=pop{i+1};%组合的第二个个体   
        cross_point=randperm(gen_length-1,1);%选择交叉点
        pop_parents_i{1}=parent_1;
        pop_parents_i{2}=parent_2;
        [children1,children2]=sub_crossover(pop_parents_i,cross_point);
        newpop{i}=children1;
        newpop{i+1}=children2;
    else%不交叉
        newpop{i}=pop{i};
        newpop{i+1}=pop{i+1};
    end
    
end

end