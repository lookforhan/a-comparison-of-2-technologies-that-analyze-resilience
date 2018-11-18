%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%�Ŵ��㷨�ӳ���
%Name: mutation.m
%����
function [newpop,record]=mutation2(pop,pm)
popsize=numel(pop);
newpop=pop;
record=zeros(popsize,1);%��¼�������Ϊ1��������Ϊ0
for pop_i=1:popsize
    r=rand(1);
    if r<pm
        record(pop_i)=1;
        parent=cell2mat(pop{pop_i});
        child=parent;
        n_genetic=numel(parent);
        mutation_point=randperm(n_genetic,2);
        child(mutation_point(1))=parent((mutation_point(2)));%����λ��
        child(mutation_point(2))=parent((mutation_point(1)));%����λ��
        newpop{pop_i}=num2cell(child);
    end
end

end