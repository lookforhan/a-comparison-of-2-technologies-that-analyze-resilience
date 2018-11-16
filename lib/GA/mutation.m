% 2018-1-1,韩朝：修改函数名，增加管道检查部分的的变异
% 上一个版本区别是输入参数pop个体中只有管道修复次序。
% 而本版本的输入参数pop个体的前一半是管道检查次序，后一半世管道修复次序。
% 首先，用随机判断是否变异，
% 如果变异，则用随机数确定是修复次序变异还是检查次序变异
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%遗传算法子程序
%Name: mutation.m
%变异
%{
pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
pm=1
newpop=mutation(pop,pm)
%}
function [newpop,record]=mutation(pop,pm)
popsize=numel(pop);
record=zeros(popsize,1);%记录个体变异为1，不变异为0
gen_length=numel(pop{1});%个体长度
newpop=pop;
r=rand(popsize,1);
for pop_i=1:popsize
    if r(pop_i)<pm%判断是否发生变异
        record(pop_i)=1;
        if rand(1)<=0.5%变异在管道检查次序
            mutation_point=randperm(gen_length/2,2);
        else
            mutation_point=randperm(gen_length/2,2)+gen_length/2;
        end
        parent=cell2mat(pop{pop_i});
        child=parent;       
        child(mutation_point(1))=parent((mutation_point(2)));%交换位置
        child(mutation_point(2))=parent((mutation_point(1)));%交换位置
        newpop{pop_i}=num2cell(child);
    end
end

end