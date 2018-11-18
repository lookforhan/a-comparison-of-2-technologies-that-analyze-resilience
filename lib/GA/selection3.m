% 增加输出对应个体的适应度值new_fitvalue
% 修改选择方式
% %% hanzhao
% 参考文献：
% [1]刘国华,包宏,李文超.用MATLAB实现遗传算法程序[J].计算机应用研究,2001(08):80-82
% [2] 周明, 孙树栋. 遗传算法原理及应用[M]. 国防工业出版社, 1999.(3.3节)
% 特点：在选择算子中采用最优保存策略和比例选择法相结合的思路
% 精英个体不参与遗传操作
% 输出evo_gen中不包含最优和最差个体
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%遗传算法子程序
%Name: selection.m
%选择复制
%{
fitvalue_0={28;24;22;20;18}
Fitvalue={97.500;95;92.500;90;87.500}
pop{1}=1
pop{2}=2
pop{3}=3
pop{4}=4
pop{5}=5
% pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
% pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
% pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
% pop{4}={52;60;34;7;42;11;58;8;8;58;11;42;60;34;7;52}
% pop{5}={52;58;8;42;7;34;60;11;7;60;58;11;42;34;8;52}
[newpop,new_fitvalue,best_indiv,max_fitness]=selection(pop,Fitvalue,fitvalue_0)
%}
function [newpop,best_indiv,second_best_indiv]=selection3(pop,Fitvalue)
popsize=numel(pop(:,1));
fitvalue=cell2mat(Fitvalue);
% fitvalue2=cell2mat(fitvalue_0);
%% 最优保存策略
% newpop=cell(n,1);
[~,index1]=max(fitvalue);%最优个体适应度值
fitvalue(index1)=0;
best_indiv=pop(index1,:);
[~,index2]=max(fitvalue);%最差个体适应度值
second_best_indiv=pop(index2,:);
index=1:popsize;index(index1)=0;index(index2)=0;%删除掉最优和第二优个体的位置
index=nonzeros(index);%删除掉最优和第二优个体的位置
evo_pop=pop(index,:);%删除最优和第二优个体的位置
evo_fitvalue=fitvalue(index);%删除最优和第二优个体的位置
% evo_fitvalue1=fitvalue2(index);%删除掉最优和最差个体的适应度
evo_popsize=popsize-2;%剩下的个体数
%% 轮盘赌（比例选择法）
totalfit=sum(evo_fitvalue); %求适应值之和
Ppop=evo_fitvalue/totalfit; %单个个体被选择的概率
Ppop_sum=cumsum(Ppop); %如 fitvalue=[1 2 3 4]，则 cumsum(fitvalue)=[1 3 6 10] 
r=rand(1,evo_popsize);
loc_selected=[sum(Ppop_sum*ones(1,evo_popsize)<ones(evo_popsize,1)*r)+1]';%选择
% new_fitvalue=evo_fitvalue1(loc_selected);%选择种群对应的适应度值
newpop=evo_pop(loc_selected,:);%选择的种群
end